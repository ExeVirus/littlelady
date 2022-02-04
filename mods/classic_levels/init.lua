local primary_c              = "#06EF"
local hover_primary_c        = "#79B1FD"
local on_primary_c           = "#FFFF"
local secondary_c            = "#FFFF"
local hover_secondary_c      = "#AAAF"
local on_secondary_c         = "#000F"
local background_primary_c   = "#F0F0F0FF"
local background_secondary_c = "#D0D0D0FF"
local settings = {
    background_color = secondary_c,
    font_color = on_secondary_c,
    heading_1_color = on_secondary_c,
    heading_2_color = on_secondary_c,
    heading_3_color = on_secondary_c,
    heading_4_color = on_secondary_c,
    heading_5_color = on_secondary_c,
    heading_6_color = on_secondary_c,
    heading_1_size = "26",
    heading_2_size = "24",
    heading_3_size = "22",
    heading_4_size = "20",
    heading_5_size = "18",
    heading_6_size = "16",
    code_block_mono_color = primary_c,
    code_block_font_size = 14,
    mono_color = primary_c,
    block_quote_color = primary_c,
}

local header = table.concat({
    "formspec_version[4]",
    "size[12,10]",
    "position[0.5,0.5]",
    "bgcolor[",background_primary_c,";false;#AAAAAA40]",
    "style_type[button;border=false;bgimg=back.png^[multiply:",primary_c,";bgimg_middle=10,3;textcolor=",on_primary_c,"]",
    "style_type[button:hovered;bgcolor=",hover_primary_c,"]",
    "box[0,0;12,1;" .. primary_c .."]",
    "button_exit[4,9;4,0.9;;Begin]",
})


local function level(level_num, name, num_stars, sound, start, size, markdown)
    ll_runtime.register_level(
        minetest.get_modpath("classic_levels").."/schemes/"..level_num..".mts",
        level_num,
        name,
        start,
        num_stars,
        "classic_"..level_num..".png",
            header .. 
            "hypertext[0,0.08;12,5;;<global halign=center color=" .. on_primary_c .. " size=36 font=Regular>"..name.."]"..
            md2f.md2f(0,1,12,7.9,markdown,"", settings),
        sound,
        size
    )
end

level(1, "Trainee", 4, "1", {x=5.5,y=1,z=5.5}, {x=10,y=22,z=10}, 
[[
# Welcome Little Lady!

You are the the latest ladybug to join our academy for the finest ladybugs in all the world!

We will be teaching you the ways to find your way in the world. It's not always easy being small...

In this academy, we encourage learning by doing! Your goals will always be simple: 

## Find all the stars!

But simple goals don't always make for easy solutions. You'll need your wits and brains to graduate from this academy.

### Good luck!
]]
)

level(2, "Controls", 2, "2", {x=5.5,y=3,z=10}, {x=10,y=24,z=20}, 
[[
Being a ladybug sometimes can get you into trouble. For your second lesson, we'll learn how to
navigate the world of being a wonderful ladybug. 

You can actually restart right at the start of any lesson, anytime, during a lesson. *No* you will not reset your stars or your time!
In fact, this is sometimes the only way to complete a lessson!

To reset to the start of a level, merely press "I" on your keyboard (bring up the inventory on mobile) and select "Reset to start"

In this level, there's only two stars to collect, but collecting one traps you from collecting the other!

PS: There's one other control you might like: hit "C" on your keyboard to switch views, and you can get a good look at yourself and your surroundings!
]]
)

level(3, "Water", 3, "3", {x=5.5,y=3,z=2}, {x=10,y=24,z=20}, 
[[
Water is a ladybug's best friend: it allows the plants and flowers to grow big and tall!

But, as with everything, too much water is bad for a ladybug. Be careful not to fall in. Here at the 
academy, *we'll fish you out before you drown*, but it'll cost you time, so stay sharp, and don't get wet feet!

In this lesson though, feel free to *test out the waters* to get hang of things, we wont laugh :)
]]
)

level(4, "Flowers", 3, "4", {x=18,y=1,z=18}, {x=20,y=22,z=20}, 
[[
You may have noticed, in the last lesson you had to make a leap of faith... well expect to jump like that in life, and in future lessons...

Alrighty, on to our bread and butter at this academy: **FLOWERS**

Now, you might have noticed ladybugs cannot jump, but surely they fly, right? Well, not young ladybugs like you, you can merely glide down slowly,
so climbing is extremely important at this stage in your development. 

###### (4th wall break: biologists, please don't shoot me)

So, you'll be practicing your climbing skills, and a little bit of your exploration skills in this lesson: get to it!
]]
)

level(5, "Mid-Term", 5, "5", {x=9,y=1,z=4}, {x=20,y=22,z=20}, 
[[
## So you think you're hot stuff now that you've dealt with some plant climbing? 

## Take on this mid-term exam!
]]
)

level(6, "Field Trip!", 17, "6", {x=18,y=7,z=3}, {x=20,y=30,z=40}, 
[[
# Congrats on finishing that mid-term!

I think you have earned a well deserved field trip to one of our favorite natural preserves.

Don't worry, this is still a lesson, but enjoy the adventure and exploration!
]]
)

level(7, "Garden", 21, "7", {x=9.5,y=4,z=23}, {x=30,y=30,z=40}, 
[[
We're back to the basics with this lesson. You'll be exploring a garden today.

But not just any garden, it's **our most un-kept garden in the whole academy**!

Don't get discouraged, and be sure to *explore*!
]]
)

level(8, "Rocks", 19, "8", {x=2.0,y=8,z=24.5}, {x=20,y=22,z=50}, 
[[
There's always more to experience in this world of ours. 

Take the simple rock, for example. They come in millions of shapes, colors, and sizes....
]]
)