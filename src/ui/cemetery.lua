local Constants = require("src.ui.constants")

local Cemetery = {}

local sortColumn = "name"
local sortDirection = 1 -- 1 for ascending, -1 for descending
local searchText = ""

local columns = {
	{ name = "name", title = "Name", width = 150 },
	{ name = "age", title = "Expiry Age", width = 100 },
	{ name = "death_reason", title = "Expiration Reason", width = 200 },
	{ name = "difficulty", title = "Difficulty", width = 100 },
}

-- Recursively filters pets based on search text, maintaining original order for matching pets
-- Pets: table - Array of pet objects to search through
-- SearchText: string - Text to search for in pet attributes
-- Index: number - Current position in pets array
local function filterPetsRecursive(pets, searchText, index)
	-- Base case: if we've processed all pets, return empty array
	if index > #pets then
		return {}
	end

	-- Get current pet and initialize match flag
	local pet = pets[index]
	local matches = false

	-- Check each column (name, age, death_reason, difficulty) for matches
	for _, col in ipairs(columns) do
		local value = tostring(pet[col.name]):lower()
		-- Case-insensitive search using string.find
		if value:find(searchText:lower()) then
			matches = true
			break
		end
	end

	-- Recursive call to process remaining pets
	local remainingPets = filterPetsRecursive(pets, searchText, index + 1)

	-- If current pet matches, add it to front of results
	-- This maintains original order for matching pets
	if matches then
		table.insert(remainingPets, 1, pet)
	end

	return remainingPets
end

-- Merges two sorted arrays while maintaining sort order based on specified column and direction
-- Column: The column/key to use for comparison
-- Direction: Sort direction (1 for ascending, -1 for descending)
local function merge(left, right, column, direction)
	local result = {}
	local i = 1 -- Index for left array
	local j = 1 -- Index for right array

	-- Compare and merge elements while both arrays have elements
	while i <= #left and j <= #right do
		local leftValue = left[i][column]
		local rightValue = right[j][column]

		-- Handle numeric values differently from strings
		if type(leftValue) == "number" then
			-- Compare numbers directly with direction multiplier
			if direction * leftValue <= direction * rightValue then
				result[#result + 1] = left[i]
				i = i + 1
			else
				result[#result + 1] = right[j]
				j = j + 1
			end
		else
			-- Convert values to lowercase and compare ASCII values for strings
			if
				direction * string.lower(tostring(leftValue)):byte()
				<= direction * string.lower(tostring(rightValue)):byte()
			then
				result[#result + 1] = left[i]
				i = i + 1
			else
				result[#result + 1] = right[j]
				j = j + 1
			end
		end
	end

	-- Append remaining elements from left array, if any
	while i <= #left do
		result[#result + 1] = left[i]
		i = i + 1
	end

	-- Append remaining elements from right array, if any
	while j <= #right do
		result[#result + 1] = right[j]
		j = j + 1
	end

	return result
end

-- Recursively sorts pets array using merge sort algorithm
local function mergeSortPets(pets, column, direction)
	-- Base case: arrays of size 0 or 1 are already sorted
	if #pets <= 1 then
		return pets
	end

	-- Find middle point to divide array into two halves
	local mid = math.floor(#pets / 2)
	local left = {}
	local right = {}

	-- Populate left half of array
	for i = 1, mid do
		left[i] = pets[i]
	end

	-- Populate right half of array
	for i = mid + 1, #pets do
		right[i - mid] = pets[i]
	end

	-- Recursively sort both halves
	left = mergeSortPets(left, column, direction)
	right = mergeSortPets(right, column, direction)

	-- Merge sorted halves
	return merge(left, right, column, direction)
end

local function getDeadPets(gameState)
	local deadPets = {}
	for _, pet in ipairs(gameState.game:get_pets()) do
		if not pet.is_alive then
			table.insert(deadPets, {
				name = pet.name,
				age = pet.age,
				death_reason = pet.death_reason or "Unknown",
				difficulty = pet.difficulty,
			})
		end
	end
	return deadPets
end

function Cemetery.handleClick(x, y, gameState)
	if not gameState.showCemetery then
		return false
	end

	local windowX = (Constants.General.WINDOW_WIDTH - Constants.Cemetery.POPUP_WIDTH) / 2
	local windowY = (Constants.General.WINDOW_HEIGHT - Constants.Cemetery.POPUP_HEIGHT) / 2

	-- Handle close button click
	local closeX = windowX + Constants.Cemetery.POPUP_WIDTH - Constants.Cemetery.WINDOW_PADDING - 10
	local closeY = windowY + Constants.Cemetery.WINDOW_PADDING

	-- Simple close button hitbox
	local closeButtonSize = 30
	if x >= closeX and x <= closeX + closeButtonSize and y >= closeY and y <= closeY + closeButtonSize then
		gameState.showCemetery = false
		return true
	end

	-- Handle column header clicks
	local headerY = windowY + 90
	local headerX = windowX + Constants.Cemetery.WINDOW_PADDING

	if y >= headerY and y <= headerY + Constants.Cemetery.HEADER_HEIGHT then
		for _, col in ipairs(columns) do
			if x >= headerX and x <= headerX + col.width then
				if sortColumn == col.name then
					sortDirection = -sortDirection
				else
					sortColumn = col.name
					sortDirection = 1
				end
				return true
			end
			headerX = headerX + col.width + Constants.Cemetery.COLUMN_PADDING
		end
	end

	return false
end

function Cemetery.handleTextInput(text)
	if text ~= "" then
		searchText = searchText .. text
	end
end

function Cemetery.handleKeyPressed(key)
	if key == "backspace" then
		searchText = searchText:sub(1, -2)
	end
end

function Cemetery.getColumns()
	return columns
end

function Cemetery.getSortInfo()
	return sortColumn, sortDirection
end

function Cemetery.getSearchText()
	return searchText
end

function Cemetery.getDeadPets()
	return getDeadPets
end

function Cemetery.getFilterPetsRecursive()
	return filterPetsRecursive
end

function Cemetery.getMergeSortPets()
	return mergeSortPets
end

return Cemetery
