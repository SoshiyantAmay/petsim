local Constants = require("src.ui.constants")
local Button = require("src.ui.button")
local Stats = require("src.ui.stats")

local coinIcon = love.graphics.newImage("assets/icons/coin.png")
local walletIcon = love.graphics.newImage("assets/icons/wallet.png")

local Draw = {}

function Draw.background(backgroundImage)
	-- Scale the image to fit the window while maintaining aspect ratio
	local bgScaleX = Constants.WINDOW_WIDTH / backgroundImage:getWidth()
	local bgScaleY = Constants.WINDOW_HEIGHT / backgroundImage:getHeight()
	local scale = math.max(bgScaleX, bgScaleY)

	-- Calculate centered position
	local bgX = (Constants.WINDOW_WIDTH - backgroundImage:getWidth() * scale) / 2
	local bgY = (Constants.WINDOW_HEIGHT - backgroundImage:getHeight() * scale) / 2

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(backgroundImage, bgX, bgY, 0, scale, scale)

	-- Overlay for better visibility
	love.graphics.setColor(0, 0, 0, 0.2)
	love.graphics.rectangle("fill", 0, 0, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
end

function Draw.title(gameState, fonts)
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle("fill", Constants.WINDOW_WIDTH / 4, 10, Constants.WINDOW_WIDTH / 2, 40, 5)

	love.graphics.setColor(1, 1, 1, 0.7)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("PetSim - Day " .. gameState.game.current_day, 0, 12, Constants.WINDOW_WIDTH, "center")
end

function Draw.petInfo(gameState, fonts)
	-- Background box
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle(
		"fill",
		10,
		Constants.STATS_Y - Constants.STATUS_BOX_PADDING,
		Constants.BAR_WIDTH + 150,
		110, -- Adjusted height to accommodate all content
		5
	)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(fonts.status)
	local status = gameState.pet:get_status()

	-- Print pet status info bar
	love.graphics.print(
		status.name
			.. " ("
			.. status.species
			.. ") | "
			.. (status.is_alive and "Alive" or "Dead")
			.. " @ "
			.. status.age
			.. " days"
			.. " | Difficulty: "
			.. Utils.firstToUpper(status.difficulty), -- Format difficulty level name with first letter capitalized
		Constants.STATS_X,
		Constants.STATS_Y - 10
	)
end

function Draw.stats(gameState, fonts)
	love.graphics.setFont(fonts.game)
	local status = gameState.pet:get_status()
	local baseY = Constants.STATS_Y + 15 -- Start bars after pet info

	Stats.drawBar("Health", status.health, baseY)
	Stats.drawBar("Hunger", status.hunger, baseY + Constants.BAR_PADDING)
	Stats.drawBar("Happiness", status.happiness, baseY + Constants.BAR_PADDING * 2)
	Stats.drawBar("Energy", status.energy, baseY + Constants.BAR_PADDING * 3)
	Stats.drawBar("Intelligence", status.intelligence, baseY + Constants.BAR_PADDING * 4)
end

function Draw.buttons(gameState, fonts)
	love.graphics.setFont(fonts.button) -- Set fonts once here and button will get it
	Button.drawAll(gameState) -- This will use the proper button drawing with disabled states
end

function Draw.wallet(gameState, fonts)
	local coinScale = (28 / coinIcon:getWidth())
	local walletScale = (72 / walletIcon:getWidth())

	-- Match pet info box height and position
	local boxHeight = 110 -- Same as pet info box
	local backgroundWidth = 200
	local padding = 10 -- Reduced padding to be closer to pet info
	local backgroundX = Constants.WINDOW_WIDTH - backgroundWidth - padding
	local backgroundY = Constants.STATS_Y - Constants.STATUS_BOX_PADDING

	-- Draw wallet background with same opacity and roundness
	love.graphics.setColor(0, 0, 0, 0.35) -- Match pet info opacity
	love.graphics.rectangle("fill", backgroundX, backgroundY, backgroundWidth, boxHeight, 5)

	-- Center wallet vertically in the box
	local walletY = backgroundY + (boxHeight - walletIcon:getHeight() * walletScale) / 2

	-- Draw wallet icon and text
	love.graphics.setColor(1, 0.75, 0.2, 1)
	love.graphics.setFont(fonts.wallet)
	local walletText = gameState.pet.coins

	-- Draw icon
	love.graphics.draw(walletIcon, backgroundX + 10, walletY, 0, walletScale, walletScale)

	-- Draw text after icon
	love.graphics.print(walletText, backgroundX + walletIcon:getWidth() * walletScale + 60, walletY + 25)

	-- Draw coin icon after text
	love.graphics.draw(coinIcon, backgroundX + walletScale + 100, walletY + 30, 0, coinScale, coinScale)
end

return Draw
