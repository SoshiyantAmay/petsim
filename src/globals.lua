-- Add the root, src and lib directories to the package path
package.path = "./?.lua;" .. "./src/?.lua;" .. "./src/game/?.lua" .. "./src/ui/?.lua" .. "./lib/?.lua;" .. package.path

-- Load Globals
Utils = require("utils")
Config = require("config")

-- Game Difficulty Levels (mimicking enums)
Difficulty = {
	EASY = 1,
	NORMAL = 2,
	HARD = 3,
	get_name = function(choice)
		if choice == Difficulty.EASY then
			return "easy"
		elseif choice == Difficulty.HARD then
			return "hard"
		else
			return "normal"
		end
	end,
}
