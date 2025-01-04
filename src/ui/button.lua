local Constants = require("src.ui.constants")
local GameState = require("src.game.state")

local Button = {}

-- Load icons
local exitIcon = love.graphics.newImage("assets/icons/exit.png")
local cartIcon = love.graphics.newImage("assets/icons/cart.png")
local nextdayIcon = love.graphics.newImage("assets/icons/day-and-night.png")

Button.buttons = {
	{ text = "Next Day", action = "nextday", icon = nextdayIcon },
	{ text = "Shop", action = "shop", icon = cartIcon },
	{ text = "Exit", action = "exit", icon = exitIcon, alwaysEnabled = true },
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

function Button.draw(text, x, y, width, height, disabled, icon)
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

	-- Icon (if present)
	if icon then
		love.graphics.setColor(1, 1, 1, disabled and 0.5 or 1)
		local iconSize = height - 10 -- Icon size slightly smaller than button height
		local iconX = x + 5 -- Padding from left
		local iconY = y + (height - iconSize) / 2 -- Centered vertically
		love.graphics.draw(icon, iconX, iconY, 0, iconSize / icon:getWidth(), iconSize / icon:getHeight())
	end

	-- Button text
	if disabled then
		love.graphics.setColor(unpack(Colors.disabled.text))
	else
		love.graphics.setColor(unpack(Colors.enabled.text))
	end
	local textWidth = love.graphics.getFont():getWidth(text)
	local textHeight = love.graphics.getFont():getHeight()
	local textX
	if icon then
		-- If there's an icon, position text after it
		textX = x + height + (width - height - textWidth) / 2 -- Center text in remaining space
	else
		textX = x + (width - textWidth) / 2 -- Center text in full button width
	end
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
			if btn.action == "nextday" then
				gameState.game:advance_day()
			elseif btn.action == "shop" then
				-- This will be handled by the shop module
				gameState.showShop = true
			elseif btn.action == "exit" then
				gameState.game:save()
				love.event.quit()
			end
			gameState.pet:check_death()
			gameState.game:save()
			GameState.checkPetDeath(gameState)
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
			shouldBeDisabled,
			btn.icon
		)
	end
end

return Button
