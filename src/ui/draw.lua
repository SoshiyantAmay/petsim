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
	love.graphics.rectangle("fill", Constants.WINDOW_WIDTH / 4, 10, Constants.WINDOW_WIDTH / 2, 30)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("PetSim - Day " .. gameState.game.current_day, 0, 18, Constants.WINDOW_WIDTH, "center")
end

function Draw.petInfo(gameState, fonts)
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle("fill", 10, Constants.STATS_Y - 10, Constants.BAR_WIDTH + 120, 90)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(fonts.status)
	local status = gameState.pet:get_status()
	love.graphics.print(
		status.name
			.. " ("
			.. status.species
			.. ") - Age: "
			.. status.age
			.. " days - "
			.. (status.is_alive and "Alive" or "Dead"),
		Constants.STATS_X,
		Constants.STATS_Y - 5
	)
end

function Draw.stats(gameState, fonts)
	love.graphics.setFont(fonts.game)
	local status = gameState.pet:get_status()
	local y = Constants.STATS_Y
	Stats.drawBar("Health", status.health, y + Constants.BAR_PADDING)
	Stats.drawBar("Hunger", status.hunger, y + Constants.BAR_PADDING * 2)
	Stats.drawBar("Happiness", status.happiness, y + Constants.BAR_PADDING * 3)
	Stats.drawBar("Energy", status.energy, y + Constants.BAR_PADDING * 4)
end

function Draw.buttons(gameState, fonts)
	love.graphics.setFont(fonts.game) -- Set fonts once here and button will get it
	Button.drawAll(gameState) -- This will use the proper button drawing with disabled states
end

return Draw
