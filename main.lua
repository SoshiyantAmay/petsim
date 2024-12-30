-- Load globals
require("src.globals")
local Game = require("src.game")

-- Constants for UI
local WINDOW_WIDTH = 600
local WINDOW_HEIGHT = 400
local BAR_WIDTH = 150
local BAR_HEIGHT = 10
local BAR_PADDING = 15
local STATS_X = 20
local STATS_Y = WINDOW_HEIGHT - 90

-- Game state
local game
local pet
local gameFont
local titleFont
local statusFont
local backgroundImage

function initializeStage()
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
	gameFont = love.graphics.newFont(10)
	titleFont = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 14)
	statusFont = love.graphics.newFont(11)
	backgroundImage = love.graphics.newImage("assets/background.jpg")
end

function initializeGame()
	game = Game.new()
	if not game:load() then
		game:create_pet("Blob", "generic", "normal")
		game:save()
	end
	local pets = game:get_pets()
	pet = pets[1]
end

function love.load()
	initializeStage()
	initializeGame()
end

function love.draw()
	-- Draw background image
	-- Scale the image to fit the window while maintaining aspect ratio
	local bgScaleX = WINDOW_WIDTH / backgroundImage:getWidth()
	local bgScaleY = WINDOW_HEIGHT / backgroundImage:getHeight()
	local scale = math.max(bgScaleX, bgScaleY)

	-- Calculate centered position if image doesn't match window exactly
	local bgX = (WINDOW_WIDTH - backgroundImage:getWidth() * scale) / 2
	local bgY = (WINDOW_HEIGHT - backgroundImage:getHeight() * scale) / 2

	-- Draw the background image
	love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
	love.graphics.draw(backgroundImage, bgX, bgY, 0, scale, scale)

	-- Draw semi-transparent overlay for better text readability
	love.graphics.setColor(0, 0, 0, 0.3)
	love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

	-- Draw title frame
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle("fill", WINDOW_WIDTH / 4, 10, WINDOW_WIDTH / 2, 30)

	-- Draw game info
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(titleFont)
	love.graphics.printf("PetSim - Day " .. game.current_day, 0, 18, WINDOW_WIDTH, "center")

	-- Draw stats frame
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle("fill", 10, STATS_Y - 10, BAR_WIDTH + 120, 90)

	-- Draw pet info
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(statusFont)
	local status = pet:get_status()
	love.graphics.print(
		status.name
			.. " ("
			.. status.species
			.. ") - Age: "
			.. status.age
			.. " days - "
			.. (status.is_alive and "Alive" or "Dead"),
		STATS_X,
		STATS_Y - 5
	)

	-- Draw stat bars
	love.graphics.setFont(gameFont)
	drawStatBar("Health", status.health, STATS_Y + BAR_PADDING)
	drawStatBar("Hunger", status.hunger, STATS_Y + BAR_PADDING * 2)
	drawStatBar("Happiness", status.happiness, STATS_Y + BAR_PADDING * 3)
	drawStatBar("Energy", status.energy, STATS_Y + BAR_PADDING * 4)
end

function drawStatBar(label, value, y)
	-- Bar background
	love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
	love.graphics.rectangle("fill", STATS_X, y, BAR_WIDTH, BAR_HEIGHT)
	-- Bar fill
	love.graphics.setColor(0.1, 0.7, 1, 0.95)
	love.graphics.rectangle("fill", STATS_X, y, BAR_WIDTH * (value / 100), BAR_HEIGHT)
	-- Bar border
	love.graphics.setColor(0, 0, 0, 0.1)
	love.graphics.setLineWidth(0.05)
	love.graphics.rectangle("line", STATS_X, y, BAR_WIDTH, BAR_HEIGHT)
	love.graphics.setLineWidth(1)
	-- Label and value
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(label .. ": " .. math.floor(value) .. "%", STATS_X + BAR_WIDTH + 10, y)
end
