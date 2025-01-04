local Constants = require("src.ui.constants")

local Shop = {}

Shop.actions = {
	{ text = "Feed", action = "feed", icon = love.graphics.newImage("assets/icons/feed.png") },
	{ text = "Rest", action = "rest", icon = love.graphics.newImage("assets/icons/rest.png") },
	{ text = "Play", action = "play", icon = love.graphics.newImage("assets/icons/play.png") },
	{ text = "Train", action = "train", icon = love.graphics.newImage("assets/icons/train.png") },
	{ text = "Cuddle", action = "cuddle", icon = love.graphics.newImage("assets/icons/cuddle.png") },
	{ text = "Groom", action = "groom", icon = love.graphics.newImage("assets/icons/groom.png") },
	{ text = "Treat", action = "treat", icon = love.graphics.newImage("assets/icons/treat.png") },
	{ text = "Medicine", action = "medicine", icon = love.graphics.newImage("assets/icons/medicine.png") },
	{ text = "Vitamins", action = "vitamins", icon = love.graphics.newImage("assets/icons/vitamins.png") },
	{ text = "Exercise", action = "exercise", icon = love.graphics.newImage("assets/icons/exercise.png") },
}

Shop.WINDOW_PADDING = 20
Shop.POPUP_WIDTH = 400
Shop.POPUP_HEIGHT = 500
Shop.RADIO_SIZE = 8
Shop.RADIO_SPACING_X = 200
Shop.RADIO_SPACING_Y = 60
Shop.ICON_SIZE = 45
Shop.ICON_PADDING = 10
Shop.BUY_BUTTON = {
	width = 120,
	height = 30,
}

local Colors = {
	window = { 0.1, 0.1, 0.1, 0.8 },
	enabled = { 1, 1, 1, 1 },
	disabled = { 0.5, 0.5, 0.5, 0.8 },
}

local selectedAction = nil

function Shop.draw(gameState, fonts)
	if not gameState.showShop then
		return
	end

	local windowX = (Constants.WINDOW_WIDTH - Shop.POPUP_WIDTH) / 2
	local windowY = (Constants.WINDOW_HEIGHT - Shop.POPUP_HEIGHT) / 2

	-- Draw shop window full window overlay
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", 0, 0, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)

	love.graphics.setColor(unpack(Colors.window))
	love.graphics.rectangle("fill", windowX, windowY, Shop.POPUP_WIDTH, Shop.POPUP_HEIGHT, 10)

	love.graphics.setFont(fonts.title)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("Pet Action Shop", windowX, windowY + 10, Shop.POPUP_WIDTH, "center")

	love.graphics.setFont(fonts.button)
	local startY = windowY + 70
	local itemsPerCol = 5
	local numColumns = 2

	for i, action in ipairs(Shop.actions) do
		local col = math.floor((i - 1) / itemsPerCol)
		local row = (i - 1) % itemsPerCol

		local x = windowX + Shop.POPUP_WIDTH / 2 + (col - 0.5) * Shop.RADIO_SPACING_X - Shop.RADIO_SIZE
		local y = startY + row * Shop.RADIO_SPACING_Y

		local isDisabled = not gameState.pet.is_alive
		love.graphics.setColor(isDisabled and Colors.disabled or Colors.enabled)

		-- Draw icon
		local iconScale = Shop.ICON_SIZE / action.icon:getWidth()
		love.graphics.draw(
			action.icon,
			x - Shop.ICON_SIZE - Shop.ICON_PADDING,
			y - Shop.ICON_SIZE / 2 + Shop.RADIO_SIZE,
			0,
			iconScale,
			iconScale
		)

		-- Radio circle
		love.graphics.circle("line", x + Shop.RADIO_SIZE, y, Shop.RADIO_SIZE)

		if selectedAction == action.action then
			love.graphics.circle("fill", x + Shop.RADIO_SIZE, y, Shop.RADIO_SIZE - 3)
		end

		love.graphics.print(action.text, x, y + Shop.RADIO_SIZE + 5)
	end

	local buttonX = windowX + (Shop.POPUP_WIDTH - Shop.BUY_BUTTON.width) / 2
	local buttonY = windowY + Shop.POPUP_HEIGHT - Shop.BUY_BUTTON.height - 20

	-- Draw 'Buy' button
	love.graphics.setColor(0.2, 0.2, 0.2, selectedAction and 1 or 0.5)
	love.graphics.rectangle("fill", buttonX, buttonY, Shop.BUY_BUTTON.width, Shop.BUY_BUTTON.height, 5)
	love.graphics.setColor(1, 1, 1, selectedAction and 1 or 0.5)
	love.graphics.printf("Buy", buttonX, buttonY + 5, Shop.BUY_BUTTON.width, "center")

	-- Draw window 'x' button
	love.graphics.setColor(1, 1, 1, 0.8)
	local closeX = windowX + Shop.POPUP_WIDTH - 30
	local closeY = windowY + 10
	love.graphics.print("×", closeX, closeY)
end

function Shop.handleClick(x, y, gameState)
	if not gameState.showShop then
		return false
	end

	local windowX = (Constants.WINDOW_WIDTH - Shop.POPUP_WIDTH) / 2
	local windowY = (Constants.WINDOW_HEIGHT - Shop.POPUP_HEIGHT) / 2

	local closeX = windowX + Shop.POPUP_WIDTH - 30
	local closeY = windowY + 10
	if x >= closeX and x <= closeX + 20 and y >= closeY and y <= closeY + 20 then
		gameState.showShop = false
		return true
	end

	local startY = windowY + 70
	local itemsPerCol = 5
	local numColumns = 2

	for i, action in ipairs(Shop.actions) do
		local col = math.floor((i - 1) / itemsPerCol)
		local row = (i - 1) % itemsPerCol

		local radioX = windowX + Shop.POPUP_WIDTH / 2 + (col - 0.5) * Shop.RADIO_SPACING_X - Shop.RADIO_SIZE
		local radioY = startY + row * Shop.RADIO_SPACING_Y

		local dx = x - (radioX + Shop.RADIO_SIZE)
		local dy = y - radioY

		if dx * dx + dy * dy <= Shop.RADIO_SIZE * Shop.RADIO_SIZE then
			selectedAction = action.action
			return true
		end
	end

	local buttonX = windowX + (Shop.POPUP_WIDTH - Shop.BUY_BUTTON.width) / 2
	local buttonY = windowY + Shop.POPUP_HEIGHT - Shop.BUY_BUTTON.height - 20

	if
		selectedAction
		and x >= buttonX
		and x <= buttonX + Shop.BUY_BUTTON.width
		and y >= buttonY
		and y <= buttonY + Shop.BUY_BUTTON.height
	then
		if selectedAction == "feed" then
			gameState.pet:feed()
		elseif selectedAction == "rest" then
			gameState.pet:rest()
		elseif selectedAction == "play" then
			gameState.pet:play()
		elseif selectedAction == "medicine" then
			gameState.pet:give_medicine()
		elseif selectedAction == "treat" then
			gameState.pet:give_treat()
		elseif selectedAction == "exercise" then
			gameState.pet:exercise()
		elseif selectedAction == "vitamins" then
			gameState.pet:give_vitamins()
		elseif selectedAction == "train" then
			gameState.pet:train()
		elseif selectedAction == "cuddle" then
			gameState.pet:cuddle()
		elseif selectedAction == "groom" then
			gameState.pet:groom()
		end

		gameState.pet:check_death()
		gameState.game:save()
		return true
	end

	return false
end

return Shop
