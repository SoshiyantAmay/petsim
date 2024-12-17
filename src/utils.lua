local json = require("lib.json") -- Assuming you'll add a JSON library

local Utils = {}

-- Save game to file
function Utils.save_game(data)
	local save_path = "data/saves.json"
	local encoded_data = json.encode(data)

	local file, err = io.open(save_path, "w")
	if not file then
		print("Error saving game: " .. err)
		return false
	end

	file:write(encoded_data)
	file:close()
	return true
end

-- Load game from file
function Utils.load_game()
	local save_path = "data/saves.json"
	local file, err = io.open(save_path, "r")

	if not file then
		print("No saved game found.")
		return nil
	end

	local content = file:read("*all")
	file:close()

	return json.decode(content)
end

-- Generate random pet name
function Utils.generate_pet_name()
	local prefixes = { "Fluffy", "Buddy", "Whiskers", "Rex", "Luna" }
	local suffixes = { "Jr", "the Great", "Star", "Brave", "Wild" }

	local prefix = prefixes[math.random(#prefixes)]
	local suffix = suffixes[math.random(#suffixes)]

	return prefix .. " " .. suffix
end

return Utils
