local S = default.get_translator

for name, item in pairs(minetest.registered_craftitems) do
	if (name and name ~= "") then
		local item_def = minetest.registered_craftitems[name]
		minetest.unregister_item(name)
		item.groups.dig_immediate = 2
		item.groups.attached_node = 1
		local nodedef = {
			tiles = {item.inventory_image},
			wield_image = item.inventory_image,
			drawtype = "signlike",
			paramtype = "light",
			paramtype2 = "wallmounted",
			sunlight_propagates = true,
			walkable = false,
			is_ground_content = false,
			floodable = true,
			selection_box = {
				type = "wallmounted",
			},
			groups = item.groups,
			sounds = default.node_sound_defaults(),
		}
		-- copy the item definition into the new node definition
		for k,v in pairs(item) do
			nodedef[k] = v
		end
		minetest.register_node(":"..item.name, nodedef)
	end
end

minetest.register_node(":default:stick", {
	description = "plantlike",
	inventory_image = "default_stick.png",
	drawtype = "plantlike",
	tiles = {"default_stick_placed.png"},
	wield_image = "default_stick.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = true,
	is_ground_content = false,
	floodable = true,
	groups = {stick=1, dig_immediate=3, flammable=1},
	selection_box = {
		type = "fixed",
		fixed = {-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		}
	},
	after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
		default.dig_up(pos, {name = "default:torch"}, digger)
	end,
	sounds = default.node_sound_defaults(),
})

minetest.register_node(":default:paper", {
	description = S("Paper"),
	tiles = {"default_paper_placed.png"},
	inventory_image = "default_paper.png",
	drawtype = "signlike",
	wield_image = "default_paper.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	floodable = true,
	selection_box = {
		type = "wallmounted",
	},
	groups = {choppy=2, dig_immediate=2, attached_node=1},
	sounds = default.node_sound_defaults(),
	on_construct = function(pos)
		--local n = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "field[text;;${text}]")
		meta:set_string("infotext", S("\"@1\"", ""))
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local player_name = sender:get_player_name() or ""
		if minetest.is_protected(pos, player_name) then
			minetest.record_protection_violation(pos, player_name)
			return
		end
		local meta = minetest.get_meta(pos)
		if not fields.text then return end
		print(player_name.." wrote \""..fields.text..
				"\" to sign at "..minetest.pos_to_string(pos))
		meta:set_string("text", fields.text)
		meta:set_string("infotext", S("\"@1\"", fields.text))
	end,
})

minetest.register_node(":vessels:glass_fragments", {
	description = S("Glass Fragments"),
	inventory_image = "vessels_glass_fragments.png",
	drawtype = "firelike",
	tiles = {"vessels_glass_fragments_placed.png"},
	wield_image = "vessels_glass_fragments.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	floodable = true,
	groups = {dig_immediate=3},
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
	},
	damage_per_second = 1,
	sounds = default.node_sound_glass_defaults(),
})
