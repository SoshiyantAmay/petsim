local json = require("dkjson") -- Ensure you have a JSON library

local Utils = {}

-- Safe file writing
function Utils.safe_write_file(path, content)
	local success, err = pcall(function()
		local file = assert(io.open(path, "w"))
		file:write(content)
		file:close()
	end)

	return success, err
end

-- Safe file reading
function Utils.safe_read_file(path)
	local success, content_or_err = pcall(function()
		local file = assert(io.open(path, "r"))
		local content = file:read("*all")
		file:close()
		return content
	end)

	return success, content_or_err
end

-- Save game to file
function Utils.save_game(data)
	local save_path = "data/saves.json"
	local encoded_data = json.encode(data)

	local success, err = Utils.safe_write_file(save_path, encoded_data)
	if not success then
		print("Error saving game: " .. tostring(err))
		return false
	end

	return true
end

-- Load game from file
function Utils.load_game()
	local save_path = "data/saves.json"
	local success, content = Utils.safe_read_file(save_path)

	if not success then
		print("No saved game found or error reading file.")
		return nil
	end

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
