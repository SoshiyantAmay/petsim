local Constants = require("src.ui.constants")
local Button = require("src.ui.button")
local Stats = require("src.ui.stats")
local Cemetery = require("src.ui.cemetery")

local coinsIcon = love.graphics.newImage("assets/icons/coins.png")
local sortUpIcon = love.graphics.newImage("assets/icons/sort-up.png")
local sortDownIcon = love.graphics.newImage("assets/icons/sort-down.png")

local Draw = {}

function Draw.background(backgroundImage)
	local bgScaleX = Constants.General.WINDOW_WIDTH / backgroundImage:getWidth()
	local bgScaleY = Constants.General.WINDOW_HEIGHT / backgroundImage:getHeight()
	local scale = math.max(bgScaleX, bgScaleY)

	local bgX = (Constants.General.WINDOW_WIDTH - backgroundImage:getWidth() * scale) / 2
	local bgY = (Constants.General.WINDOW_HEIGHT - backgroundImage:getHeight() * scale) / 2

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(backgroundImage, bgX, bgY, 0, scale, scale)

	love.graphics.setColor(0, 0, 0, 0.2)
	love.graphics.rectangle("fill", 0, 0, Constants.General.WINDOW_WIDTH, Constants.General.WINDOW_HEIGHT)
end

function Draw.title(gameState, fonts)
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle("fill", Constants.General.WINDOW_WIDTH / 4, 10, Constants.General.WINDOW_WIDTH / 2, 40, 5)

	love.graphics.setColor(1, 1, 1, 0.7)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("PetSim - Day " .. gameState.game.current_day, 0, 12, Constants.General.WINDOW_WIDTH, "center")
end

function Draw.petInfo(gameState, fonts)
	love.graphics.setColor(0, 0, 0, 0.35)
	love.graphics.rectangle(
		"fill",
		10,
		Constants.General.STATS_Y - Constants.General.STATUS_BOX_PADDING,
		Constants.General.BAR_WIDTH + 150,
		110,
		5
	)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(fonts.status)
	local status = gameState.pet:get_status()

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
			.. Utils.firstToUpper(status.difficulty),
		Constants.General.STATS_X,
		Constants.General.STATS_Y - 10
	)
end

function Draw.stats(gameState, fonts)
	love.graphics.setFont(fonts.game)
	local status = gameState.pet:get_status()
	local baseY = Constants.General.STATS_Y + 15 -- Start bars after pet info

	Stats.drawBar("Health", status.health, baseY)
	Stats.drawBar("Hunger", status.hunger, baseY + Constants.General.BAR_PADDING)
	Stats.drawBar("Happiness", status.happiness, baseY + Constants.General.BAR_PADDING * 2)
	Stats.drawBar("Energy", status.energy, baseY + Constants.General.BAR_PADDING * 3)
	Stats.drawBar("Intelligence", status.intelligence, baseY + Constants.General.BAR_PADDING * 4)
end

function Draw.buttons(gameState, fonts)
	love.graphics.setFont(fonts.button) -- Set fonts once here and button will get it
	Button.drawAll(gameState) -- This will use the proper button drawing with disabled states
end

function Draw.coins(gameState, fonts)
	local coinsScale = (35 / coinsIcon:getWidth())

	-- Match title height and position
	local boxHeight = 40 -- Same as pet info box
	local boxWidth = 110
	local boxX = 10
	local boxY = 10

	-- Draw coins box with same opacity and roundness
	love.graphics.setColor(0, 0, 0, 0.35) -- Match pet info opacity
	love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight, 5)

	-- Draw coins icon and text
	love.graphics.setColor(1, 0.75, 0.2, 1)
	love.graphics.setFont(fonts.coins)
	local coinsText = gameState.pet.coins

	-- Draw icon
	love.graphics.draw(coinsIcon, boxX + 7, boxY + 2, 0, coinsScale, coinsScale)

	-- Draw text after icon
	love.graphics.print(coinsText, boxX + 50, 12)
end
-- [Previous code remains the same until Draw.cemetery function]

function Draw.cemetery(gameState, fonts)
	if not gameState.showCemetery then
		return
	end

	-- Draw background overlay
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", 0, 0, Constants.General.WINDOW_WIDTH, Constants.General.WINDOW_HEIGHT)

	local windowX = (Constants.General.WINDOW_WIDTH - Constants.Cemetery.POPUP_WIDTH) / 2
	local windowY = (Constants.General.WINDOW_HEIGHT - Constants.Cemetery.POPUP_HEIGHT) / 2

	-- Draw cemetery window
	love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
	love.graphics.rectangle(
		"fill",
		windowX,
		windowY,
		Constants.Cemetery.POPUP_WIDTH,
		Constants.Cemetery.POPUP_HEIGHT,
		10
	)

	-- Draw title
	love.graphics.setFont(fonts.title)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		"Pet Cemetery",
		windowX,
		windowY + Constants.Cemetery.WINDOW_PADDING - 5,
		Constants.Cemetery.POPUP_WIDTH,
		"center"
	)

	-- Draw close button
	love.graphics.setFont(fonts.close)
	love.graphics.setColor(1, 1, 1, 0.8)
	local closeX = windowX + Constants.Cemetery.POPUP_WIDTH - Constants.Cemetery.WINDOW_PADDING - 10
	local closeY = windowY + Constants.Cemetery.WINDOW_PADDING
	love.graphics.print("×", closeX, closeY)

	-- Draw search box
	love.graphics.setFont(fonts.button)
	love.graphics.setColor(0.2, 0.2, 0.2, 1)
	local searchBoxX = windowX + Constants.Cemetery.WINDOW_PADDING
	local searchBoxY = windowY + Constants.Cemetery.WINDOW_PADDING * 2.5 + 30
	local searchBoxWidth = 200
	local searchBoxHeight = 25
	love.graphics.rectangle("fill", searchBoxX + 50, searchBoxY, searchBoxWidth, searchBoxHeight)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Search:  " .. Cemetery.getSearchText(), searchBoxX, searchBoxY + 5)

	-- Constants for table layout
	local tableX = windowX + Constants.Cemetery.WINDOW_PADDING
	local tableY = searchBoxY + searchBoxHeight + Constants.Cemetery.WINDOW_PADDING + 15
	local tableWidth = Constants.Cemetery.POPUP_WIDTH - (Constants.Cemetery.WINDOW_PADDING * 2)

	-- Draw table headers
	local headerX = tableX
	local headerY = tableY
	local sortColumn, sortDirection = Cemetery.getSortInfo()

	for _, col in ipairs(Cemetery.getColumns()) do
		-- Header background
		love.graphics.setColor(0.3, 0.3, 0.3, 1)
		love.graphics.rectangle("fill", headerX, headerY, col.width, Constants.Cemetery.HEADER_HEIGHT)

		-- Header text
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(
			col.title,
			headerX + Constants.Cemetery.WINDOW_PADDING / 2,
			headerY + (Constants.Cemetery.HEADER_HEIGHT - fonts.button:getHeight()) / 2
		)

		-- Sort indicator
		if sortColumn == col.name then
			love.graphics.setColor(1, 1, 0, 1)
			local icon = sortDirection == 1 and sortUpIcon or sortDownIcon
			local iconScale = Constants.Cemetery.HEADER_HEIGHT * 0.5 / icon:getHeight()
			love.graphics.draw(
				icon,
				headerX + col.width - (icon:getWidth() * iconScale) - Constants.Cemetery.WINDOW_PADDING / 2,
				headerY + (Constants.Cemetery.HEADER_HEIGHT - icon:getHeight() * iconScale) / 2,
				0,
				iconScale,
				iconScale
			)
		end

		headerX = headerX + col.width + Constants.Cemetery.COLUMN_PADDING
	end

	-- Draw data rows
	local rowY = headerY + Constants.Cemetery.HEADER_HEIGHT + 2
	local deadPets = Cemetery.getDeadPets()(gameState)
	if Cemetery.getSearchText() ~= "" then
		deadPets = Cemetery.getFilterPetsRecursive()(deadPets, Cemetery.getSearchText(), 1)
	end
	deadPets = Cemetery.getMergeSortPets()(deadPets, sortColumn, sortDirection)

	-- Calculate visible area
	local maxVisibleY = windowY + Constants.Cemetery.POPUP_HEIGHT - Constants.Cemetery.WINDOW_PADDING

	for _, pet in ipairs(deadPets) do
		if rowY + Constants.Cemetery.ROW_HEIGHT <= maxVisibleY then
			-- Draw row background
			love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
			love.graphics.rectangle("fill", tableX, rowY, tableWidth, Constants.Cemetery.ROW_HEIGHT)

			-- Draw row content
			local contentX = tableX
			love.graphics.setColor(1, 1, 1, 1)

			for _, col in ipairs(Cemetery.getColumns()) do
				love.graphics.print(
					Utils.firstToUpper(tostring(pet[col.name])),
					contentX + Constants.Cemetery.WINDOW_PADDING / 2,
					rowY + (Constants.Cemetery.ROW_HEIGHT - fonts.button:getHeight()) / 2
				)
				contentX = contentX + col.width + Constants.Cemetery.COLUMN_PADDING
			end

			rowY = rowY + Constants.Cemetery.ROW_HEIGHT + 2
		end
	end
end

return Draw
