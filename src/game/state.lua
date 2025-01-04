local Game = require "src.game"

local GameState = {}

function GameState.initialize()
  local state = {}

  state.game = Game.new()
  state.showShop = false -- Initialize shop state

  if not state.game:load() then
    state.game:create_pet("Blob", "generic", "normal")
    state.game:save()
  end
  state.pet = state.game:get_pets()[#state.game:get_pets()]
  return state
end

function GameState.checkPetDeath(state)
  local currentPet = state.pet
  if not currentPet.is_alive then
    local status = currentPet:get_status()
    local deathAge = status.death_age or status.age or 0
    local deathReason = status.death_reason or "unknown causes"

    local message = string.format(
      "%s has died at age %d due to %s.\nWould you like to create a new pet?",
      status.name,
      deathAge,
      deathReason
    )

    local buttons = { "Yes", "No", enterbutton = 1, escapebutton = 2 }
    local pressed = love.window.showMessageBox("Pet Death", message, buttons, "info")

    if pressed == 1 then
      GameState.createNewPet(state)
    end
  end
end

function GameState.createNewPet(state)
  Utils.startTextInput(function(name)
    if not name or name:len() == 0 then
      name = "Pet" .. (#state.game:get_pets() + 1)
    end

    state.game:create_pet(name, "generic", Utils.selectedDifficulty)
    local lastPetIndex = #state.game:get_pets()
    state.pet = state.game:get_pets()[lastPetIndex]
    state.game:save()
  end)
end

return GameState
