local config = {
	initial_pet_stats = {
		hunger = 50,
		happiness = 50,
		energy = 100,
		health = 100,
		intelligence = 50,
		coins = 10,
	},
	species = {
		dog = {
			base_happiness_gain = 25,
			base_energy_cost = 15,
			intelligence_gain = 12, -- Dogs learn quickly
		},
		cat = {
			base_happiness_gain = 20,
			base_energy_cost = 10,
			intelligence_gain = 15, -- Cats are naturally curious
		},
		generic = {
			base_happiness_gain = 15,
			base_energy_cost = 12,
			intelligence_gain = 10,
		},
	},
	difficulty = {
		easy = {
			stat_decay_rate = 0.5,
			age_penalty = 0.8,
			intelligence_modifier = 1.2, -- Learns faster
		},
		normal = {
			stat_decay_rate = 1,
			age_penalty = 1,
			intelligence_modifier = 1,
		},
		hard = {
			stat_decay_rate = 1.5,
			age_penalty = 1.2,
			intelligence_modifier = 0.8, -- Learns slower
		},
	},
	daily_allowance = 5, -- 10 is too much!
}

--[[
--- With setmetatable:
config.initial_pet_stat  -- Error: "Trying to access undefined config key: initial_pet_stat"

-- Without setmetatable:
config.initial_pet_stat  -- Returns nil silently-
--]]

return setmetatable(config, {
	__index = function(_, k)
		error("Trying to access undefined config key: " .. k)
	end,
})
