--██╗     ██╗████████╗████████╗██╗     ███████╗██╗      █████╗ ██████╗ ██╗   ██╗    ██████╗ ██╗   ██╗███╗   ██╗████████╗██╗███╗   ███╗███████╗
--██║     ██║╚══██╔══╝╚══██╔══╝██║     ██╔════╝██║     ██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██║   ██║████╗  ██║╚══██╔══╝██║████╗ ████║██╔════╝
--██║     ██║   ██║      ██║   ██║     █████╗  ██║     ███████║██║  ██║ ╚████╔╝     ██████╔╝██║   ██║██╔██╗ ██║   ██║   ██║██╔████╔██║█████╗  
--██║     ██║   ██║      ██║   ██║     ██╔══╝  ██║     ██╔══██║██║  ██║  ╚██╔╝      ██╔══██╗██║   ██║██║╚██╗██║   ██║   ██║██║╚██╔╝██║██╔══╝  
--███████╗██║   ██║      ██║   ███████╗███████╗███████╗██║  ██║██████╔╝   ██║       ██║  ██║╚██████╔╝██║ ╚████║   ██║   ██║██║ ╚═╝ ██║███████╗
--╚══════╝╚═╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝
-- Ascii art generated with https://patorjk.com/software/taag/
-- Originally created by ExeVirus/Just_Visiting for the 2021 Minetest Game Jam

local levels = {} -- table of registered levels to load

-------------------
-- Public API
-------------------
ll_runtime = {} --global table for other dependent mod access

-- Add register_level
local handle = nil
ll_runtime.register_level = function(mts_location, num, name, start, num_stars, image, formspec, music, size)
    handle = minetest.register_schematic(mts_location)
    --if handle ~= nil then
        table.insert(levels, {num=num, name=name, scheme=mts_location, start=start, num_stars = num_stars, image=image, formspec=formspec, music=music, size=size})
    --else
        --error("File: " .. mts_location .. "was unable to load properly, quitting")
    --end
end

-------------------
-- Local API
-------------------
local music_handle = nil
local function play_music(filename)
    --Close the previous music
    if music_handle ~= nil then
        minetest.sound_stop(music_handle) --fast fade
    end
    -- Play the new music
    music_handle = minetest.sound_play(filename, {loop=true}) --loop until close

    --if still nil, play the default
    if music_handle == nil then
        music_handle = minetest.sound_play("default", {loop=true})
    end
end

--Tracker Variables
local loaded_level = nil
local formspec_read = nil
local level_loaded = nil
local globalsteps_enabled = false
local stars_collected = 0
local time_since_start = 0
local HUD = {} -- is a table of handles

--Some declarations to local functions defined later
local main_menu = nil
local win_formspec = nil
local load_level = nil
local unload_level = nil
local reset_player = nil
local win_level = nil

-------------------
-- First time setup
--    (which executes before any levels or schematics are loaded)
-------------------
local worldmt = Settings(minetest.get_worldpath().."/world.mt")
if worldmt:get("backend") ~= "dummy" then
    worldmt:set("backend","dummy")
    worldmt:write()
    minetest.log("Changed map backend to RAM only (Dummy), forcing restart")
    error("NOT A REAL ERROR :)\n===============================\n=\n=\n=   Intial world setup complete, please reconnect!\n=\n=\n===============================")
end
-------------------
--Load our Settings
-------------------
local function handleColor(settingtypes_name, default)
    return minetest.settings:get(settingtypes_name) or default
end
local primary_c              = handleColor("primary_c",              "#06EF")
local hover_primary_c        = handleColor("hover_primary_c",        "#79B1FD")
local on_primary_c           = handleColor("on_primary_c",           "#FFFF")
local secondary_c            = handleColor("secondary_c",            "#FFFF")
local hover_secondary_c      = handleColor("hover_secondary_c",      "#AAAF")
local on_secondary_c         = handleColor("on_secondary_c",         "#000F")
local background_primary_c   = handleColor("background_primary_c",   "#F0F0F0FF")
local background_secondary_c = handleColor("background_secondary_c", "#D0D0D0FF")

local storage = minetest.get_mod_storage()
local current_level = storage:get_int("current_level") or 1
if current_level < 1 then current_level = 1 end -- just in case

-------------------
-- Main Menu and startup
-------------------
minetest.register_on_joinplayer(function(player)
    -- Show off little Lady!
    player:set_properties({
        mesh = "lady_assets_littlelady.obj",
        textures = {"lady_assets_ladybug.png"},
        visual = "mesh",
        visual_size = {x = 1, y = 1},
        collisionbox = {-0.24, 0.0, -0.26, 0.24, 1, 0.26},
        stepheight = 0.55,
        eye_height = 1,
    })
    -- Turn off builtin crap
    player:hud_set_flags(
        {
            hotbar = false,
            healthbar = false,
            crosshair = false,
            wielditem = false,
            breathbar = false,
            minimap = false,
            minimap_radar = false,
        }
    )
    --set to always sunny in CalifornIA
    player:override_day_night_ratio(1)
    player:set_stars({visible=false})
    player:set_moon({visible=false})
    player:set_sun({visible=false})

--  1. Turn off player gravity and stop them from falling
    player:set_physics_override({
        speed = 0.0,
        jump = 0.0,
        gravity = 0.0,
        sneak = false,
    })
--  2. Change the player's "I" in-game menu to quit to main menu, reset, quit, and credits
    player:set_inventory_formspec(table.concat(
        {
            "formspec_version[3]",
            "size[8,9]",
            "position[0.5,0.5]",
            "anchor[0.5,0.5]",
            "no_prepend[]",
            "bgcolor[",background_primary_c,";both;#AAAAAA40]",
            "style_type[button;border=false;bgimg=back.png^[multiply:",primary_c,";bgimg_middle=10,10;textcolor=",on_primary_c,"]",
            "style_type[button:hovered;bgimg=back.png^[multiply:",hover_primary_c,";bgcolor=#FFF]",
            "button_exit[0.6,0.25;6.8,1;menu;Quit to Menu]",
            "button_exit[0.6,1.5;6.8,1;reset;Reset to start]",
            "button_exit[0.6,2.75;6.8,1;view;View Starting Message]",
            "hypertext[2,4;4,4.75;;<global halign=center color=",primary_c," size=32 font=Regular>Credits<global halign=center color=",on_secondary_c," size=16 font=Regular>\n",
            "Original Game by ExeVirus\n",
            "Source code is MIT License, 2021\n",
            "Media/Music is:\nSee LICENSE Files\n",
            "Music coming to Spotify and other streaming services!\n]",
        }
    ))
-- 3. Display the main Menu
    minetest.show_formspec(player:get_player_name(),"menu",main_menu())
end)

-- Function display_main_menu()
main_menu = function(scroll_in)
    local times = minetest.deserialize(storage:get_string("times"))
    local scroll = scroll_in or 0
    local r =  {
        "formspec_version[3]",
        "size[11,11]",
        "position[0.5,0.5]",
        "anchor[0.5,0.5]",
        "no_prepend[]",
        "bgcolor[",background_primary_c,";both;#AAAAAA40]",
        "box[0,0;11,1;",primary_c,"]",
        "style_type[button;border=false;bgimg=back.png^[multiply:",secondary_c,";bgimg_middle=10,3;textcolor=",on_secondary_c,"]",
        "style_type[button:hovered;bgcolor=",hover_secondary_c,"]",
        "hypertext[1,0.08;9,5;;<global halign=center color=",on_primary_c," size=36 font=Regular>Little Lady]",
        "button[7.5,0.15;3.3,0.7;exit;Quit Little Lady]",
        "hypertext[2.6,1.25;3.9,0.9;;<global halign=center color=",on_secondary_c," size=20 font=Regular>Best Time]",
        "hypertext[6.6,1.25;1.8,0.9;;<global halign=center color=",on_secondary_c," size=20 font=Regular>Level]",
        "box[2.4,1.9;6.2,8.2;",background_secondary_c,"]",
        "scroll_container[2.5,2;6,8;scroll;vertical;0.2]",
    }
    for i=1, #levels, 1 do
        if i <= current_level then
            table.insert(r,"image_button[4.1,".. (i-1)*2+0.1 ..";1.8,1.8;"..levels[i].image..";level"..i..";"..levels[i].name.."]")
            if times ~= nil then
                if times[i] ~= nil then
                    table.insert(r,"hypertext[0.1,".. (i-1)*2+0.8 ..";3.9,0.9;;<global halign=center color=" .. on_secondary_c .. " size=20 font=Regular>"..string.sub(os.date("%X",18000+times[i]), 4, -4).."]")
                else
                    table.insert(r,"hypertext[0.1,".. (i-1)*2+0.8 ..";3.9,0.9;;<global halign=center color=" .. on_secondary_c .. " size=20 font=Regular>Incomplete]")
                end
            else
                table.insert(r,"hypertext[0.1,".. (i-1)*2+0.8 ..";3.9,0.9;;<global halign=center color=" .. on_secondary_c .. " size=20 font=Regular>Incomplete]")
            end
        else
            table.insert(r,"image[4.1,".. (i-1)*2+0.1 ..";1.8,1.8;"..levels[i].image.."^[colorize:#000:170]")
        end
    end
    table.insert(r,"scroll_container_end[]")
    table.insert(r,"scrollbaroptions[max="..tostring((#levels - 4) * 10)..";thumbsize="..tostring((#levels - 5) * 2.5).."]")
    table.insert(r,"scrollbar[8.6,1.9;0.5,8.2;vertical;scroll;"..tostring(scroll).."]")
    play_music("theme")
    return table.concat(r)
end

-------------------
--On receive
-------------------
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local scroll_in = nil
    if formname == "menu" then
        if fields.scroll then
            scroll_in = tonumber(minetest.explode_scrollbar_event(fields.scroll).value)
        end
            --Loop through all fields for level selected
        for fieldtext,_ in pairs(fields) do
            if string.sub(fieldtext,1,5) == "level" then
                loaded_level = tonumber(string.sub(fieldtext,6,-1))
                if levels[loaded_level] ~= nil and loaded_level <= current_level then
                    load_level(player)
                    minetest.close_formspec(player:get_player_name(),"menu")
                else
                    loaded_level = nil
                end
            end
        end
        if fields.quit then
            minetest.after(0.10, function() minetest.show_formspec(player:get_player_name(), "menu", main_menu(scroll_in)) end)
            return
        elseif fields.exit then
            minetest.request_shutdown("Thanks for playing!")
            return
        else
            --minetest.show_formspec(player:get_player_name(), "game:main", main_menu(width_in, height_in, scroll_in))
        end
    elseif formname == "" then --pause menu
        if fields.menu then
            unload_level(player, false)
        elseif fields.reset then
            reset_player(player)
        elseif fields.view then
            minetest.after(0.15,function(player)
                minetest.show_formspec(player:get_player_name(),"level",levels[loaded_level].formspec)
            end,player)
        end
    elseif formname == "win" then
        minetest.after(0.10, function() minetest.show_formspec(player:get_player_name(), "menu", main_menu()) end)
    elseif formname == "level" then
        if loaded_level ~= nil then
            formspec_read = true
            if level_loaded then
                globalsteps_enabled = true
            end
        end
    end
end)

load_level = function(player)
    level_loaded = false
    stars_collected = 0
    --  1. Show HUD element that shows loading
    HUD.loading_back = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.5, y = 0.5},
        offset    = {x = 0, y = 0},
        text      = "back.png^[colorize:#000:170",
        scale     = { x = 100, y = 100},
        alignment = { x = 0, y = 0 },
    })

    HUD.loading_text = player:hud_add({
        hud_elem_type = "text",
        position  = {x = 0.5, y = 0.8},
        offset    = {x = 0, y = 0},
        text      = "Loading...",
        scale     = { x = 100, y = 100},
        alignment = { x = 0, y = 0 },
        number = tonumber(primary_c),
        size = {x=5}
    })
    --  1. Load schematic <num>.mts at 0,0,0 position
    minetest.place_schematic( {x=0,y=0,z=0}, levels[loaded_level].scheme, "0", {}, true, nil)
    --  2. Show formspec to read while loading
    minetest.show_formspec(player:get_player_name(),"level",levels[loaded_level].formspec)
    play_music(levels[loaded_level].music)
    --  3. Wait an arbitrary amount of time, scaled by level size
    local time_to_load = levels[loaded_level].size.x * levels[loaded_level].size.z / 200
    minetest.after(time_to_load, function(player)
        time_since_start = 0

        -- 4. Remove HUD overlay. 
        player:hud_remove(HUD.loading_back) 
        player:hud_remove(HUD.loading_text)

        -- 5. Add Star part of HUD overlay
        HUD.star = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0.5, y = 0},
            offset    = {x = 60, y = 40},
            text      = "lady_assets_star_inv.png",
            scale     = { x = 2, y = 2},
            alignment = { x = 0, y = 0 },
        })
        HUD.star_total = player:hud_add({
            hud_elem_type = "text",
            position  = {x = 0.5, y = 0},
            offset    = {x = -16, y = 40},
            text      = "of "..levels[loaded_level].num_stars,
            scale     = { x = 100, y = 100},
            alignment = { x = 0, y = 0 },
            number = tonumber(primary_c),
            size = {x=2}
        })
        HUD.star_count = player:hud_add({
            hud_elem_type = "text",
            position  = {x = 0.5, y = 0},
            offset    = {x = -66, y = 40},
            text      = "0",
            scale     = { x = 100, y = 100},
            alignment = { x = 0, y = 0 },
            number = tonumber(primary_c),
            size = {x=2}
        })

        -- 6. Add timer part of HUD overlay
        HUD.timer = player:hud_add({
            hud_elem_type = "text",
            position  = {x = 1, y = 0},
            offset    = {x = -10, y = 20},
            text      = string.sub(os.date("%X",18000+time_since_start), 4, -4),
            scale     = { x = 100, y = 100},
            alignment = { x = -1, y = 0 },
            number = tonumber(primary_c),
            size = {x=2}
        })
        --  7. When finished loading, move player into position "start", and set player physics
        reset_player(player)
        player:set_physics_override({
            speed = 1.0,
            jump = 0.0,
            gravity = 0.3,
            sneak = false,
        })

        --  8. Enable Globalstep for water drowning and to update the hud timer (time since start)
        if formspec_read then
            globalsteps_enabled = true
        end
        level_loaded = true
    end, player)
    
    
    
end

win_level = function(player)
    -- 0. Update player meta to note current level completion number (1-99 etc)
    if current_level <= loaded_level then
        current_level = current_level + 1
        storage:set_int("current_level", current_level)
    end
    -- 1. Show Win Formspec message
    minetest.show_formspec(player:get_player_name(), "win", win_formspec())
    
    -- 2. Update the player best time
    local times = minetest.deserialize(storage:get_string("times"))
    if times ~= nil then
        if times[loaded_level] == nil or times[loaded_level] > time_since_start then
            times[loaded_level] = time_since_start
        end
    else
        times = {}
        times[loaded_level] = time_since_start
    end
    storage:set_string("times",minetest.serialize(times))
    
    -- 3. Unload Level function
    unload_level(player, true)
end

win_formspec = function()
    return table.concat({
        "formspec_version[3]",
        "size[4,4]",
        "position[0.5,0.5]",
        "anchor[0.5,0.5]",
        "no_prepend[]",
        "bgcolor[",background_primary_c,";false;#AAAAAA40]",
        "box[0,0;4,1;",primary_c,"]",
        "style_type[button;border=false;bgimg=back.png^[multiply:",secondary_c,";bgimg_middle=10,3;textcolor=",on_secondary_c,"]",
        "style_type[button:hovered;bgcolor=",hover_secondary_c,"]",
        "hypertext[0.15,0.25;3.7,2;;<global halign=center color=",on_primary_c," size=20 font=Regular>Level Complete!]",
        "hypertext[0.5,1.58;3,2;;<global halign=center color=",on_secondary_c," size=20 font=Regular>Time: \n",
        string.sub(os.date("%X",18000+time_since_start), 4, -4), "]",
        "button_exit[0.35,3.15;3.3,0.7;quit;Continue]",
    })
end

reset_player = function(player)
    player:set_pos(levels[loaded_level].start)
end

unload_level = function(player, win)
    globalsteps_enabled = false
    -- 0. Remove HUD
    player:hud_remove(HUD.star)
    player:hud_remove(HUD.star_count)
    player:hud_remove(HUD.star_total)
    player:hud_remove(HUD.timer)
    player:set_physics_override({
        speed = 0.0,
        jump = 0.0,
        gravity = 0.0,
        sneak = false,
    })
    minetest.after(0.5,function(player)
        player:set_physics_override({
            speed = 0.0,
            jump = 0.0,
            gravity = 0.0,
            sneak = false,
        })
    end,player)

    formspec_read = nil
    level_loaded = nil
    
    -- 1. Unload current level
    minetest.delete_area({x=0,y=0,z=0}, levels[loaded_level].size)
    loaded_level = nil

    -- 2. If they won, don't do anything, otherwise show the main menu
    if win == false then
        minetest.after(0.1,function(player)
            minetest.show_formspec(player:get_player_name(),"menu", main_menu())
        end,player)
    end
end

local _time = 0 --globalstep specific tracker
minetest.register_globalstep(function(dtime)
    if globalsteps_enabled then 
        local player = minetest.get_player_by_name("singleplayer")
        _time = _time + dtime
        if _time > 0.05 then
            _time = 0
            local pos = player:get_pos()
            local node = minetest.get_node({x=pos.x, y=pos.y+0.5, z=pos.z})
            if node.name == "lady_assets:water" then
                -- When the player is inside water, they drown and reset_player()
                reset_player(player)
                --play water sound

                --minetest.chat_send_player("singleplayer", "Drowning!")
            else
                -- When player is inside a star, remove the star, make a sound, increment the star counter, and if enough stars have been collected, win_level
                pos.y = pos.y + 0.2
                node = minetest.get_node(pos)
                if node.name == "lady_assets:star" then
                    minetest.remove_node(pos)
                    stars_collected = stars_collected + 1
                    if stars_collected >= levels[loaded_level].num_stars then
                        player:hud_change(HUD.star_count, "text", stars_collected)
                        win_level(player)
                    else
                        player:hud_change(HUD.star_count, "text", stars_collected)
                    end
                end
            end
        end	

        -- 3. Increment the timer counter
        time_since_start = dtime + time_since_start
        player:hud_change(HUD.timer, "text", string.sub(os.date("%X",18000+time_since_start), 4, -4))
    end
end)

