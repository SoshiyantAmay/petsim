local Constants = require("src.ui.constants")
local GameState = require("src.game.state")

local Button = {}

Button.buttons = {
	{ text = "Refresh", action = "refresh", alwaysEnabled = true },
	{ text = "Next Day", action = "nextday" },
	{ text = "Feed", action = "feed" },
	{ text = "Rest", action = "rest" },
	{ text = "Play", action = "play" },
	{ text = "Exit", action = "exit", alwaysEnabled = true },
}

-- Color definitions for better management
local Colors = {
	enabled = {
		background = { 0.2, 0.2, 0.2, 0.5 }, -- Dark gray
		border = { 0.5, 0.5, 0.5, 0.5 },
		text = { 1, 1, 1, 0.8 }, -- White
	},
	disabled = {
		background = { 0.8, 0.8, 0.8, 0.5 }, -- Light gray
		border = { 0.7, 0.7, 0.7, 0.5 },
		text = { 0.5, 0.5, 0.5, 0.8 }, -- Medium gray
	},
}

function Button.draw(text, x, y, width, height, disabled)
	-- Button background
	if disabled then
		love.graphics.setColor(unpack(Colors.disabled.background))
	else
		love.graphics.setColor(unpack(Colors.enabled.background))
	end
	love.graphics.rectangle("fill", x, y, width, height, 5)

	-- Button border
	if disabled then
		love.graphics.setColor(unpack(Colors.disabled.border))
	else
		love.graphics.setColor(unpack(Colors.enabled.border))
	end
	love.graphics.rectangle("line", x, y, width, height, 5)

	-- Button text
	if disabled then
		love.graphics.setColor(unpack(Colors.disabled.text))
	else
		love.graphics.setColor(unpack(Colors.enabled.text))
	end
	local textWidth = love.graphics.getFont():getWidth(text)
	local textHeight = love.graphics.getFont():getHeight()
	local textX = x + (width - textWidth) / 2
	local textY = y + (height - textHeight) / 2
	love.graphics.print(text, textX, textY)
end

function Button.isInside(x, y, button_x, button_y, width, height)
	return x >= button_x and x <= button_x + width and y >= button_y and y <= button_y + height
end

function Button.handleClick(x, y, gameState)
	for i, btn in ipairs(Button.buttons) do
		local button_y = Constants.BUTTONS_START_Y + (i - 1) * (Constants.BUTTON_HEIGHT + Constants.BUTTON_PADDING)

		-- Only check if button is disabled if it's not always enabled
		local isDisabled = not btn.alwaysEnabled and not gameState.pet.is_alive

		if
			not isDisabled
			and Button.isInside(
				x,
				y,
				Constants.BUTTONS_START_X,
				button_y,
				Constants.BUTTON_WIDTH,
				Constants.BUTTON_HEIGHT
			)
		then
			if btn.action == "refresh" then
				GameState.checkPetDeath(gameState)
				gameState.game:save()
			elseif btn.action == "nextday" then
				gameState.game:advance_day()
				gameState.game:save()
			elseif btn.action == "feed" then
				gameState.pet:feed()
				gameState.game:save()
			elseif btn.action == "rest" then
				gameState.pet:rest()
				gameState.game:save()
			elseif btn.action == "play" then
				gameState.pet:play()
				gameState.game:save()
			elseif btn.action == "exit" then
				gameState.game:save() -- Save before exiting
				love.event.quit()
			end
		end
	end
end

function Button.drawAll(gameState)
	love.graphics.setFont(love.graphics.getFont())
	for i, btn in ipairs(Button.buttons) do
		local button_y = Constants.BUTTONS_START_Y + (i - 1) * (Constants.BUTTON_HEIGHT + Constants.BUTTON_PADDING)

		-- Always draw enabled colors for alwaysEnabled buttons, regardless of pet state
		local shouldBeDisabled = not btn.alwaysEnabled and not gameState.pet.is_alive

		Button.draw(
			btn.text,
			Constants.BUTTONS_START_X,
			button_y,
			Constants.BUTTON_WIDTH,
			Constants.BUTTON_HEIGHT,
			shouldBeDisabled -- This will be false for Refresh and Exit buttons
		)
	end
end

return Button
