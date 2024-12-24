local config = {
	initial_pet_stats = {
		hunger = 50,
		happiness = 50,
		energy = 100,
		health = 100,
	},
	species = {
		dog = {
			base_happiness_gain = 25,
			base_energy_cost = 15,
		},
		cat = {
			base_happiness_gain = 20,
			base_energy_cost = 10,
		},
		generic = {
			base_happiness_gain = 15,
			base_energy_cost = 12,
		},
	},
	difficulty = {
		easy = {
			stat_decay_rate = 0.5,
			age_penalty = 0.8,
		},
		normal = {
			stat_decay_rate = 1,
			age_penalty = 1,
		},
		hard = {
			stat_decay_rate = 1.5,
			age_penalty = 1.2,
		},
	},
}

return setmetatable(config, {
	__index = function(_, k)
		error("Trying to access undefined config key: " .. k)
	end,
})
