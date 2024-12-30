-- Load globals
require("src.globals")
local Constants = require("src.ui.constants")
local Button = require("src.ui.button")
local Draw = require("src.ui.draw")
local GameState = require("src.game.state")
local Fonts = require("src.ui.fonts")

-- Game state
local gameState
local fonts
local backgroundImage

function love.load()
	love.window.setMode(Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)

	-- Initialize fonts
	fonts = Fonts.load()

	-- Load background
	backgroundImage = love.graphics.newImage("assets/background.jpg")

	-- Initialize game state
	gameState = GameState.initialize()
end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 then -- Left click
		Button.handleClick(x, y, gameState)
	end
end

function love.draw()
	Draw.background(backgroundImage)
	Draw.title(gameState, fonts)
	Draw.petInfo(gameState, fonts)
	Draw.stats(gameState, fonts)
	Draw.buttons(fonts)
end
