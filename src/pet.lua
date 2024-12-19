local Config = require("../config")

local Pet = {}
Pet.__index = Pet

-- Constructor for creating a new pet
function Pet.new(name, species, difficulty)
	local self = setmetatable({}, Pet)
	local config = Config.initial_pet_stats
	local species_config = Config.species[species:lower()] or Config.species.generic
	local difficulty_config = Config.difficulty[difficulty or "normal"]

	self.name = name or "Unnamed Pet"
	self.species = species or "Generic"
	self.difficulty = difficulty or "normal"

	-- Core attributes with configuration
	self.hunger = config.hunger
	self.happiness = config.happiness
	self.energy = config.energy
	self.age = 0
	self.health = config.health

	-- Configuration modifiers
	self.species_bonus = species_config
	self.difficulty_modifier = difficulty_config

	-- Tracking flags
	self.is_alive = true

	return self
end

-- Feed the pet
function Pet:feed()
	if not self.is_alive then
		return false
	end
	local decay_rate = self.difficulty_modifier.stat_decay_rate

	self.hunger = math.min(100, self.hunger + 20 * decay_rate)
	self.happiness = math.min(100, self.happiness + 10 * decay_rate)
	return true
end

-- Play with the pet
function Pet:play()
	if not self.is_alive then
		return false
	end
	local happiness_gain = self.species_bonus.base_happiness_gain
	local energy_cost = self.species_bonus.base_energy_cost
	local decay_rate = self.difficulty_modifier.stat_decay_rate

	self.happiness = math.min(100, self.happiness + happiness_gain * decay_rate)
	self.energy = math.max(0, self.energy - energy_cost * decay_rate)
	return true
end

-- Rest/Sleep
function Pet:rest()
	if not self.is_alive then
		return false
	end
	local decay_rate = self.difficulty_modifier.stat_decay_rate

	self.energy = math.min(100, self.energy + 30 * decay_rate)
	self.hunger = math.max(0, self.hunger - 10 * decay_rate)
	return true
end

-- Age the pet
function Pet:age_up()
	local decay_rate = self.difficulty_modifier.stat_decay_rate
	local age_penalty = self.difficulty_modifier.age_penalty

	self.age = self.age + 1

	-- Decrease attributes over time
	self.hunger = math.max(0, self.hunger - 5 * decay_rate * age_penalty)
	self.energy = math.max(0, self.energy - 5 * decay_rate * age_penalty)

	-- Check for potential death conditions
	if self.hunger <= 0 or self.energy <= 0 then
		self.health = math.max(0, self.health - 10 * decay_rate)
	end

	if self.health <= 0 then
		self.is_alive = false
	end
end

-- Get pet status
function Pet:get_status()
	return {
		name = self.name,
		species = self.species,
		difficulty = self.difficulty,
		hunger = self.hunger,
		happiness = self.happiness,
		energy = self.energy,
		age = self.age,
		health = self.health,
		is_alive = self.is_alive,
	}
end

return Pet
