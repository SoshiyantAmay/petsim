local Fonts = {}

function Fonts.load()
	-- Genera UI elements
	Fonts.game = love.graphics.newFont("assets/fonts/Rajdhani-Light.ttf", 13)
	-- Dialog
	Fonts.dialog = love.graphics.newFont("assets/fonts/Rajdhani-Regular.ttf", 15)
	-- Pixel font for title
	Fonts.title = love.graphics.newFont("assets/fonts/Righteous-Regular.ttf", 28)
	-- Pet status
	Fonts.status = love.graphics.newFont("assets/fonts/Rajdhani-Medium.ttf", 13)
	-- Buttons
	Fonts.button = love.graphics.newFont("assets/fonts/Rajdhani-Medium.ttf", 15)
	-- Wallet (Main)
	Fonts.wallet = love.graphics.newFont("assets/fonts/Rajdhani-Medium.ttf", 25)
	return Fonts
end

return Fonts
