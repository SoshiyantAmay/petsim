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

local function createNewPet()
	-- Show input dialog for pet name
	local buttons = { "OK", "Cancel", enterbutton = 1, escapebutton = 2 }
	local pressed = love.window.showMessageBox("New Pet", "Would you like to name your pet?", buttons, "info")

	if pressed == 1 then
		-- Show text input for name (info type shows OK button only)
		local success, name = love.window.showMessageBox("Enter Name", "Enter your pet's name:", "", "info")

		-- If name is empty or canceled, generate default name
		if not name or name:len() == 0 then
			name = "Pet" .. (#gameState.game:get_pets() + 1)
		end

		gameState.game:create_pet(name, "generic", "normal")
		gameState.pet = gameState.game:get_pets()[#gameState.game:get_pets()]
		gameState.game:save()
	end
end

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

		if pressed == 1 then
			createNewPet()
		end
	end
	lastPetStatus = currentPet:get_status()
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
end

-- Helper function to show the debug info when needed by pressing 'd'
function love.keypressed(key)
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
