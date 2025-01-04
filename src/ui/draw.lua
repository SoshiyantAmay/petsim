local Constants = require("src.ui.constants")
local Button = require("src.ui.button")
local Stats = require("src.ui.stats")

local Draw = {}

function Draw.background(backgroundImage)
	-- Scale the image to fit the window while maintaining aspect ratio
	local bgScaleX = Constants.WINDOW_WIDTH / backgroundImage:getWidth()
	local bgScaleY = Constants.WINDOW_HEIGHT / backgroundImage:getHeight()
	local scale = math.max(bgScaleX, bgScaleY)

	-- Calculate centered position
	local bgX = (Constants.WINDOW_WIDTH - backgroundImage:getWidth() * scale) / 2
	local bgY = (Constants.WINDOW_HEIGHT - backgroundImage:getHeight() * scale) / 2

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(backgroundImage, bgX, bgY, 0, scale, scale)

	-- Overlay
	love.graphics.setColor(0, 0, 0, 0.3)
	love.graphics.rectangle("fill", 0, 0, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
end

function Draw.title(gameState, fonts)
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle("fill", Constants.WINDOW_WIDTH / 4, 10, Constants.WINDOW_WIDTH / 2, 40)

	love.graphics.setColor(1, 1, 1, 0.7)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("PetSim - Day " .. gameState.game.current_day, 0, 12, Constants.WINDOW_WIDTH, "center")
end

function Draw.petInfo(gameState, fonts)
	-- Background box
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle(
		"fill",
		10,
		Constants.STATS_Y - Constants.STATUS_BOX_PADDING,
		Constants.BAR_WIDTH + 150,
		95 -- Adjusted height to accommodate all content
	)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(fonts.status)
	local status = gameState.pet:get_status()
	--
	-- Format difficulty with first letter capitalized
	local difficulty = status.difficulty:sub(1, 1):upper() .. status.difficulty:sub(2)

	love.graphics.print(
		status.name
			.. " ("
			.. status.species
			.. ") | "
			.. (status.is_alive and "Alive" or "Dead")
			.. " @ "
			.. status.age
			.. " days"
			.. " | Difficulty: "
			.. difficulty,
		Constants.STATS_X,
		Constants.STATS_Y - 10
	)
end

function Draw.stats(gameState, fonts)
	love.graphics.setFont(fonts.game)
	local status = gameState.pet:get_status()
	local baseY = Constants.STATS_Y + 15 -- Start bars after pet info

	Stats.drawBar("Health", status.health, baseY)
	Stats.drawBar("Hunger", status.hunger, baseY + Constants.BAR_PADDING)
	Stats.drawBar("Happiness", status.happiness, baseY + Constants.BAR_PADDING * 2)
	Stats.drawBar("Energy", status.energy, baseY + Constants.BAR_PADDING * 3)
end

function Draw.buttons(gameState, fonts)
	love.graphics.setFont(fonts.button) -- Set fonts once here and button will get it
	Button.drawAll(gameState) -- This will use the proper button drawing with disabled states
end

return Draw
