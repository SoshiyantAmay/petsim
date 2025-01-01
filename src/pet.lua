local Pet = {}
Pet.__index = Pet

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
	self.death_reason = nil
	self.death_age = nil

	return self
end

-- New method to check death conditions
function Pet:check_death()
	if self.happiness <= 0 then
		self.health = math.max(0, self.health - 10 * self.difficulty_modifier.stat_decay_rate)
		self.death_reason = "depression"
	end

	if self.hunger <= 0 then
		self.health = math.max(0, self.health - 10 * self.difficulty_modifier.stat_decay_rate)
		self.death_reason = "starvation"
	end

	if self.energy <= 0 then
		self.health = math.max(0, self.health - 10 * self.difficulty_modifier.stat_decay_rate)
		self.death_reason = "exhaustion"
	end

	if self.health <= 0 and self.is_alive then
		self.is_alive = false
		self.death_age = self.age
		return true
	end
	return false
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
	self.hunger = math.max(0, self.hunger - 10 * decay_rate)

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
	self.happiness = math.max(0, self.happiness - 5 * decay_rate * age_penalty)
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
		death_reason = self.death_reason,
		death_age = self.death_age,
	}
end

-- Give medicine when pet's health is low
function Pet:give_medicine()
	if not self.is_alive then
		return false
	end

	self.health = math.min(100, self.health + 15 * self.difficulty_modifier.stat_decay_rate)
	self.happiness = math.max(0, self.happiness - 5) -- Pets usually don't like medicine
	return true
end

-- Give vitamins for stat boosts
function Pet:give_vitamins()
	if not self.is_alive then
		return false
	end

	self.health = math.min(100, self.health + 5)
	self.energy = math.min(100, self.energy + 10)
	return true
end

-- Train pet to learn new skills
function Pet:train()
	if not self.is_alive then
		return false
	end

	self.energy = math.max(0, self.energy - 15 * self.difficulty_modifier.stat_decay_rate)
	self.hunger = math.max(0, self.hunger - 10 * self.difficulty_modifier.stat_decay_rate)
	-- Could add a skills/experience system
	return true
end

-- Pet/Cuddle for quick happiness boost
function Pet:cuddle()
	if not self.is_alive then
		return false
	end

	self.happiness = math.min(100, self.happiness + 5)
	-- Less energy cost than playing
	self.energy = math.max(0, self.energy - 2)
	return true
end

-- Groom/Clean pet
function Pet:groom()
	if not self.is_alive then
		return false
	end

	self.happiness = math.min(100, self.happiness + 10)
	self.health = math.min(100, self.health + 5)
	return true
end

-- Give treats (quick happiness boost but affects health)
function Pet:give_treat()
	if not self.is_alive then
		return false
	end

	self.happiness = math.min(100, self.happiness + 15)
	self.hunger = math.min(100, self.hunger + 5)
	self.health = math.max(0, self.health - 2) -- Small health penalty for treats
	return true
end

-- Exercise (improves health but costs energy)
function Pet:exercise()
	if not self.is_alive then
		return false
	end

	self.health = math.min(100, self.health + 10)
	self.energy = math.max(0, self.energy - 20)
	self.hunger = math.max(0, self.hunger - 15)
	return true
end

return Pet
