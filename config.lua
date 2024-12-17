return {
	game_version = "0.1.0",
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
