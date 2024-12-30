local Constants = require("src.ui.constants")

local Button = {}

Button.buttons = {
	{ text = "Refresh", action = "refresh" },
	{ text = "Next Day", action = "nextday" },
	{ text = "Feed", action = "feed" },
	{ text = "Rest", action = "rest" },
	{ text = "Play", action = "play" },
	{ text = "Exit", action = "exit" },
}

function Button.draw(text, x, y, width, height)
	-- Button background
	love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
	love.graphics.rectangle("fill", x, y, width, height, 5)

	-- Button border
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("line", x, y, width, height, 5)

	-- Button text
	love.graphics.setColor(1, 1, 1, 1)
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
		if
			Button.isInside(x, y, Constants.BUTTONS_START_X, button_y, Constants.BUTTON_WIDTH, Constants.BUTTON_HEIGHT)
		then
			Button.handleAction(btn.action, gameState)
		end
	end
end

function Button.handleAction(action, gameState)
	if action == "refresh" then
		gameState.game:save()
	elseif action == "nextday" then
		gameState.game:advance_day()
		gameState.game:save()
	elseif action == "feed" then
		gameState.pet:feed()
		gameState.game:save()
	elseif action == "rest" then
		gameState.pet:rest()
		gameState.game:save()
	elseif action == "play" then
		gameState.pet:play()
		gameState.game:save()
	elseif action == "exit" then
		love.event.quit()
	end
end

return Button
