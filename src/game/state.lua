local Game = require("src.game")

local GameState = {}

function GameState.initialize()
	local state = {}

	state.game = Game.new()
	if not state.game:load() then
		state.game:create_pet("Blob", "generic", "normal")
		state.game:save()
	end

	state.pet = state.game:get_pets()[1]
	return state
end

return GameState
