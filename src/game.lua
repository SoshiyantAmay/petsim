local Pet = require("src.pet")

local Game = {}

-- Initialize a new game
function Game.new()
	local self = {
		pets = {},
		current_day = 1,
	}
	setmetatable(self, { __index = Game })
	return self
end

-- Create a new pet
function Game:create_pet(name, species, difficulty)
	local pet = Pet.new(name, species, difficulty or "normal")
	table.insert(self.pets, pet)
	return pet
end

-- Advance game day
function Game:advance_day()
	for _, pet in ipairs(self.pets) do
		pet:age_up()
	end
	self.current_day = self.current_day + 1
end

-- Get all pets
function Game:get_pets()
	return self.pets
end

-- Save game state
function Game:save()
	local save_data = {
		current_day = self.current_day,
		pets = {},
	}

	for _, pet in ipairs(self.pets) do
		table.insert(save_data.pets, pet:get_status())
	end

	return Utils.save_game(save_data)
end

-- Load game state
function Game:load()
	local loaded_data = Utils.load_game()
	if not loaded_data then
		return nil
	end

	self.current_day = loaded_data.current_day
	self.pets = {}

	for _, pet_data in ipairs(loaded_data.pets) do
		local pet = Pet.new(pet_data.name, pet_data.species)
		-- Restore pet attributes
		pet.hunger = pet_data.hunger
		pet.happiness = pet_data.happiness
		pet.energy = pet_data.energy
		pet.age = pet_data.age
		pet.health = pet_data.health
		pet.is_alive = pet_data.is_alive

		table.insert(self.pets, pet)
	end

	return self
end

return Game
