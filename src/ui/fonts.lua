local Fonts = {
	game = nil,
	title = nil,
	status = nil,
}

function Fonts.load()
	Fonts.game = love.graphics.newFont(10)
	Fonts.title = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 14)
	Fonts.status = love.graphics.newFont(11)
	return Fonts
end

return Fonts
