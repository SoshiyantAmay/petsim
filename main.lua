-- Load required modules
require("src.globals")

local Draw = require("src.ui.draw")
local Fonts = require("src.ui.fonts")
local Button = require("src.ui.button")
local GameState = require("src.game.state")
local Constants = require("src.ui.constants")

-- Game state
local gameState
local fonts
local backgroundImage
local lastPetStatus = nil

local function checkPetStatus()
	local currentPet = gameState.pet
	if not currentPet.is_alive and (lastPetStatus == nil or lastPetStatus.is_alive) then
		local status = currentPet:get_status()
		local deathAge = status.death_age or status.age or 0
		local deathReason = status.death_reason or "unknown causes"

		local message = string.format(
			"%s has died at age %d due to %s.\nWould you like to create a new pet?",
			status.name,
			deathAge,
			deathReason
		)

		local buttons = { "Yes", "No", enterbutton = 1, escapebutton = 2 }
		local pressed = love.window.showMessageBox("Pet Death", message, buttons, "info")

		if pressed == 1 then -- If user selected yes
			GameState.createNewPet(gameState)
		end
	end
	lastPetStatus = currentPet:get_status()
end

function love.textinput(t)
	Utils.handleTextInputChar(t)
end

function love.load()
	love.window.setMode(Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
	fonts = Fonts.load()
	backgroundImage = love.graphics.newImage("assets/background.jpg")
	gameState = GameState.initialize()
end

function love.update(dt)
	checkPetStatus()
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
	Draw.buttons(gameState, fonts)
	if Utils.isNaming then
		Utils.handleTextInput()
	end
end

-- Helper function to show the debug info when needed by pressing 'd'
function love.keypressed(key)
	Utils.handleTextInputKey(key)
	if key == "d" then
		-- Collect debug info
		local debug_info = "Button States:\n\n"
		for _, btn in ipairs(Button.buttons) do
			local shouldBeDisabled = not btn.alwaysEnabled and not gameState.pet.is_alive
			debug_info = debug_info
				.. string.format(
					"%s: alwaysEnabled=%s, shouldBeDisabled=%s\n",
					btn.text,
					tostring(btn.alwaysEnabled or false),
					tostring(shouldBeDisabled)
				)
		end
		love.window.showMessageBox("Debug Info", debug_info, "info")
	end
end

function love.quit()
	if gameState and gameState.game then
		gameState.game:save()
	end
end
