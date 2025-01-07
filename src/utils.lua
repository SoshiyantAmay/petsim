local Constants = require("src.ui.constants")
local Json = require("lib.dkjson")

local Utils = {}

Utils.isNaming = false
Utils.currentInput = ""
Utils.inputCallback = nil
Utils.selectedDifficulty = "normal"

function Utils.startTextInput(callback)
	Utils.isNaming = true
	Utils.currentInput = ""
	Utils.inputCallback = callback
end

-- Draw a dialog including a text box for pet name entry and radio buttons
-- for difficulty selection.
function Utils.handleTextInput(fonts)
	-- Background and title
	love.graphics.setFont(fonts.dialog)
	love.graphics.setColor(0, 0, 0, 0.8)
	love.graphics.rectangle(
		"fill",
		Constants.General.WINDOW_WIDTH / 4,
		Constants.General.WINDOW_HEIGHT / 2 - 60,
		Constants.General.WINDOW_WIDTH / 2,
		120
	)

	-- Name input title and text box
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		"Enter pet name:",
		Constants.General.WINDOW_WIDTH / 4,
		Constants.General.WINDOW_HEIGHT / 2 - 55,
		Constants.General.WINDOW_WIDTH / 2,
		"center"
	)

	love.graphics.printf(
		Utils.currentInput .. "_",
		Constants.General.WINDOW_WIDTH / 4,
		Constants.General.WINDOW_HEIGHT / 2 - 25,
		Constants.General.WINDOW_WIDTH / 2,
		"center"
	)

	-- Draw difficulty selection title
	local startY = Constants.General.WINDOW_HEIGHT / 2 + 5
	love.graphics.printf(
		"Select difficulty:",
		Constants.General.WINDOW_WIDTH / 4,
		startY,
		Constants.General.WINDOW_WIDTH / 2,
		"center"
	)

	-- Calculate dimensions for proper centering
	local optionWidth = 80 -- Width of each option including radio button and text
	local totalWidth = optionWidth * 3 -- Total width of all three options
	local startX = Constants.General.WINDOW_WIDTH / 2 - totalWidth / 2 + 15 -- Starting X for first option

	-- Draw difficulty options
	for i = 1, 3 do
		local x = startX + (i - 1) * optionWidth
		local y = startY + 25
		local radioX = x + 5
		local textX = x + 20 -- Give some space after radio button

		local difficultyName = Difficulty.get_name(i)

		-- Draw radio button
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.circle("line", radioX, y + 10, 5)

		if difficultyName == Utils.selectedDifficulty then
			love.graphics.circle("fill", radioX, y + 10, 3)
		end

		-- Draw difficulty option label
		love.graphics.print(Utils.firstToUpper(difficultyName), textX, y)
	end
end

-- Function to handle difficulty selection UI
function Utils.handleDifficultyClick(x, y)
	if Utils.isNaming then
		local startY = Constants.General.WINDOW_HEIGHT / 2 + 30
		local optionWidth = 80
		local totalWidth = optionWidth * 3
		local startX = Constants.General.WINDOW_WIDTH / 2 - totalWidth / 2

		for i = 1, 3 do
			local buttonX = startX + (i - 1) * optionWidth
			local buttonY = startY

			if x >= buttonX and x <= buttonX + optionWidth and y >= buttonY and y <= buttonY + 20 then
				Utils.selectedDifficulty = Difficulty.get_name(i)
				return true
			end
		end
	end
	return false
end

function Utils.handleTextInputKey(key)
	if Utils.isNaming then
		if key == "backspace" then
			Utils.currentInput = Utils.currentInput:sub(1, -2)
		elseif key == "return" or key == "kpenter" then
			local name = Utils.currentInput
			if Utils.inputCallback then
				Utils.inputCallback(name)
			end
			Utils.isNaming = false
			Utils.currentInput = ""
			Utils.inputCallback = nil
		elseif key == "escape" then
			Utils.isNaming = false
			Utils.currentInput = ""
			Utils.inputCallback = nil
		end
		return true
	end
	return false
end

function Utils.handleTextInputChar(t)
	if Utils.isNaming and #Utils.currentInput < 20 then
		Utils.currentInput = Utils.currentInput .. t
		return true
	end
	return false
end

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
	local save_path = "data/pets.json"
	local encoded_data = Json.encode(data)

	local success, err = Utils.safe_write_file(save_path, encoded_data)
	if not success then
		print("Error saving game: " .. tostring(err))
		return false
	end

	return true
end

-- Load game from file
function Utils.load_game()
	local save_path = "data/pets.json"
	local success, content = Utils.safe_read_file(save_path)

	if not success then
		print("No saved game found or error reading file.")
		return nil
	end

	return Json.decode(content)
end

-- Debugging helper function to recursively print table contents
function Utils.printTable(t, indent)
	indent = indent or ""
	for k, v in pairs(t) do
		if type(v) == "table" then
			print(indent .. k .. ":")
			Utils.printTable(v, indent .. "  ")
		else
			print(indent .. k .. ":", v)
		end
	end
end

-- Change the first character in a string to uppercase
function Utils.firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

return Utils
