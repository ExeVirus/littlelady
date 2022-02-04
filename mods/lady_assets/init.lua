local lady_assets = {}

lady_assets.register_mesh = function(name)
	autobox.register_node(
		"lady_assets:"..name, --node name
		"lady_assets_"..name..".box", --node bounding box
		{ --node def
			description =  "lady_assets:"..name,
			drawtype = "mesh",
			mesh = "lady_assets_"..name..".obj",
			use_texture_alpha = "clip",
			pointable = false,
			sunlight_propagates = true,
			paramtype2 = "facedir",
			paramtype = "light",
			tiles = {"lady_assets_"..name..".png"},
			groups = { oddly_breakable_by_hand=2 },
		},
		true
	)
end

lady_assets.register_mesh("bell_flower")
lady_assets.register_mesh("carrot")
lady_assets.register_mesh("daffodil")
lady_assets.register_mesh("desert_flower")
lady_assets.register_mesh("desert_marigold")
lady_assets.register_mesh("fence")
lady_assets.register_mesh("fern")
lady_assets.register_mesh("flower_pot")
lady_assets.register_mesh("garden_rake")
lady_assets.register_mesh("grass")
lady_assets.register_mesh("grass_blade_1")
lady_assets.register_mesh("grass_medium")
lady_assets.register_mesh("grass_plant_1")
lady_assets.register_mesh("grass_short")
lady_assets.register_mesh("grass_tuft")
lady_assets.register_mesh("hummingbird")
lady_assets.register_mesh("ivy")
lady_assets.register_mesh("leafy_green")
lady_assets.register_mesh("mushroom")
lady_assets.register_mesh("mushroom_2")
lady_assets.register_mesh("pastel_flowers")
lady_assets.register_mesh("pushlin")
lady_assets.register_mesh("roses")
lady_assets.register_mesh("slug_1")
lady_assets.register_mesh("slug_2")
lady_assets.register_mesh("tree_roots")
--lady_assets.register_mesh("tree_stump")
autobox.register_node(
	"lady_assets:".."tree_stump", --node name
	"lady_assets_".."tree_stump"..".box", --node bounding box
	{ --node def
		description =  "lady_assets:".."tree_stump",
		drawtype = "mesh",
		mesh = "lady_assets_".."tree_stump"..".obj",
		sunlight_propagates = true,
		pointable = false,
		use_texture_alpha = "clip",
		paramtype2 = "facedir",
		paramtype = "light",
		tiles = {"lady_assets_".."tree_stump"..".png"},
		inventory_image = "lady_assets_tree_stump_inv.png",
		wield_image = "lady_assets_tree_stump_inv.png",
		groups = { oddly_breakable_by_hand=2 },
	},
	true
)
lady_assets.register_mesh("trowel")
lady_assets.register_mesh("tulips")
lady_assets.register_mesh("twig_1")
lady_assets.register_mesh("vine_1")
lady_assets.register_mesh("watering_can")

--Water For game
minetest.register_node("lady_assets:water", {
	description = "Water",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.475, 0.5},
		},
	},
	pointable = false,
	connects_to = "lady_assets:lady_assets_water",
	connect_sides = { "top", "bottom"},
	use_texture_alpha = "clip",
	waving = 3,
	tiles = {
		{
			name = "lady_assets_water.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	drowning = 1,
	post_effect_color = {a = 50, r = 15, g = 30, b =45},
	groups = { oddly_breakable_by_hand = 2},
})

--Water For game
minetest.register_node("lady_assets:star", {
	description = "Star",
	drawtype = "mesh",
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	},
	use_texture_alpha = "clip",
	mesh = "lady_assets_star.obj",
	pointable = false,
	tiles = {
		{
			name = "lady_assets_star.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 4,
				aspect_h = 1,
				length = 1.45,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = { oddly_breakable_by_hand = 2},
})

--Grass For game
minetest.register_node("lady_assets:grass", {
	pointable = false,
	description = "grass",
	drawtype = "normal",
	tiles = {"lady_assets_grass.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { oddly_breakable_by_hand = 2},
})

stairsplus:register_all("lady_assets", "grass", "lady_assets:grass", {
	description = "Grass",
	tiles = {"lady_assets_grass.png"},
	groups = {oddly_breakable_by_hand=2},
	pointable = false,
})
