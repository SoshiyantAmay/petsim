local Constants = require("src.ui.constants")

local Stats = {}

function Stats.drawBar(label, value, y)
	-- Bar background
	love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
	love.graphics.rectangle("fill", Constants.General.STATS_X, y, Constants.General.BAR_WIDTH, Constants.General.BAR_HEIGHT)

	-- Bar fill
	love.graphics.setColor(0.1, 0.7, 1, 0.95)
	love.graphics.rectangle(
		"fill",
		Constants.General.STATS_X,
		y,
		Constants.General.BAR_WIDTH * (value / 100),
		Constants.General.BAR_HEIGHT
	)

	-- Bar border
	love.graphics.setColor(0, 0, 0, 0.1)
	love.graphics.setLineWidth(0.05)
	love.graphics.rectangle("line", Constants.General.STATS_X, y, Constants.General.BAR_WIDTH, Constants.General.BAR_HEIGHT)
	love.graphics.setLineWidth(1)

	-- Label and value with adjusted vertical alignment
	love.graphics.setColor(1, 1, 1)
	local textY = y - Constants.General.BAR_HEIGHT / 2 -- Center text vertically with bar
	love.graphics.print(
		label .. ": " .. math.floor(value) .. "%",
		Constants.General.STATS_X + Constants.General.BAR_WIDTH + 10,
		textY
	)
end

return Stats
