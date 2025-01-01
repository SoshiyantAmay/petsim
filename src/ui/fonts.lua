local Fonts = {}

function Fonts.load()
	-- Genera UI elements
	Fonts.game = love.graphics.newFont("assets/fonts/Rajdhani-Light.ttf", 13)
	-- Pixel font for title
	Fonts.title = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 16)
	-- Pet status
	Fonts.status = love.graphics.newFont("assets/fonts/Rajdhani-Regular.ttf", 15)
	-- Buttons
	Fonts.button = love.graphics.newFont("assets/fonts/Rajdhani-SemiBold.ttf", 15)
	return Fonts
end

return Fonts
