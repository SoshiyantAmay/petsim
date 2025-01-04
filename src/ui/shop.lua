local Constants = require "src.ui.constants"

local Shop = {}

Shop.actions = {
  { text = "Feed", action = "feed" },
  { text = "Rest", action = "rest" },
  { text = "Play", action = "play" },
  { text = "Train", action = "train" },
  { text = "Cuddle", action = "cuddle" },
  { text = "Groom", action = "groom" },
  { text = "Treat", action = "treat" },
  { text = "Medicine", action = "medicine" },
  { text = "Vitamins", action = "vitamins" },
  { text = "Exercise", action = "exercise" },
  { text = "Close", action = "close", alwaysEnabled = true },
}

-- Constants for the shop window
Shop.WINDOW_PADDING = 20
Shop.POPUP_WIDTH = 300
Shop.POPUP_HEIGHT = 400
Shop.BUTTON_WIDTH = 120
Shop.BUTTON_HEIGHT = 25
Shop.BUTTON_PADDING = 10

-- Colors for the shop window
local Colors = {
  window = { 0.1, 0.1, 0.1, 0.9 },
  enabled = {
    background = { 0.2, 0.2, 0.2, 0.8 },
    border = { 0.5, 0.5, 0.5, 0.8 },
    text = { 1, 1, 1, 1 },
  },
  disabled = {
    background = { 0.8, 0.8, 0.8, 0.5 },
    border = { 0.7, 0.7, 0.7, 0.5 },
    text = { 0.5, 0.5, 0.5, 0.8 },
  },
}

function Shop.draw(gameState, fonts)
  if not gameState.showShop then
    return
  end

  -- Calculate window position (centered)
  local windowX = (Constants.WINDOW_WIDTH - Shop.POPUP_WIDTH) / 2
  local windowY = (Constants.WINDOW_HEIGHT - Shop.POPUP_HEIGHT) / 2

  -- Draw semi-transparent background overlay
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle("fill", 0, 0, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)

  -- Draw shop window background
  love.graphics.setColor(unpack(Colors.window))
  love.graphics.rectangle("fill", windowX, windowY, Shop.POPUP_WIDTH, Shop.POPUP_HEIGHT, 10)

  -- Draw title
  love.graphics.setFont(fonts.title)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Pet Actions", windowX, windowY + 20, Shop.POPUP_WIDTH, "center")

  -- Draw buttons
  love.graphics.setFont(fonts.button)
  local startY = windowY + 70
  local buttonsPerRow = 2
  local buttonSpacing = (Shop.POPUP_WIDTH - (Shop.BUTTON_WIDTH * buttonsPerRow) - (Shop.WINDOW_PADDING * 2))
    / (buttonsPerRow - 1)

  for i, action in ipairs(Shop.actions) do
    local row = math.floor((i - 1) / buttonsPerRow)
    local col = (i - 1) % buttonsPerRow

    local x = windowX + Shop.WINDOW_PADDING + (col * (Shop.BUTTON_WIDTH + buttonSpacing))
    local y = startY + (row * (Shop.BUTTON_HEIGHT + Shop.BUTTON_PADDING))

    -- Special case for the Close button - center it at the bottom
    if action.action == "close" then
      x = windowX + (Shop.POPUP_WIDTH - Shop.BUTTON_WIDTH) / 2
      y = windowY + Shop.POPUP_HEIGHT - Shop.BUTTON_HEIGHT - 20
    end

    local isDisabled = not action.alwaysEnabled and not gameState.pet.is_alive

    -- Draw button background
    if isDisabled then
      love.graphics.setColor(unpack(Colors.disabled.background))
    else
      love.graphics.setColor(unpack(Colors.enabled.background))
    end
    love.graphics.rectangle("fill", x, y, Shop.BUTTON_WIDTH, Shop.BUTTON_HEIGHT, 5)

    -- Draw button border
    if isDisabled then
      love.graphics.setColor(unpack(Colors.disabled.border))
    else
      love.graphics.setColor(unpack(Colors.enabled.border))
    end
    love.graphics.rectangle("line", x, y, Shop.BUTTON_WIDTH, Shop.BUTTON_HEIGHT, 5)

    -- Draw button text
    if isDisabled then
      love.graphics.setColor(unpack(Colors.disabled.text))
    else
      love.graphics.setColor(unpack(Colors.enabled.text))
    end
    local textWidth = fonts.button:getWidth(action.text)
    local textX = x + (Shop.BUTTON_WIDTH - textWidth) / 2
    local textY = y + (Shop.BUTTON_HEIGHT - fonts.button:getHeight()) / 2
    love.graphics.print(action.text, textX, textY)
  end
end

function Shop.handleClick(x, y, gameState)
  if not gameState.showShop then
    return false
  end

  local windowX = (Constants.WINDOW_WIDTH - Shop.POPUP_WIDTH) / 2
  local windowY = (Constants.WINDOW_HEIGHT - Shop.POPUP_HEIGHT) / 2
  local startY = windowY + 70
  local buttonsPerRow = 2
  local buttonSpacing = (Shop.POPUP_WIDTH - (Shop.BUTTON_WIDTH * buttonsPerRow) - (Shop.WINDOW_PADDING * 2))
    / (buttonsPerRow - 1)

  for i, action in ipairs(Shop.actions) do
    local row = math.floor((i - 1) / buttonsPerRow)
    local col = (i - 1) % buttonsPerRow

    local buttonX = windowX + Shop.WINDOW_PADDING + (col * (Shop.BUTTON_WIDTH + buttonSpacing))
    local buttonY = startY + (row * (Shop.BUTTON_HEIGHT + Shop.BUTTON_PADDING))

    -- Special case for the Close button
    if action.action == "close" then
      buttonX = windowX + (Shop.POPUP_WIDTH - Shop.BUTTON_WIDTH) / 2
      buttonY = windowY + Shop.POPUP_HEIGHT - Shop.BUTTON_HEIGHT - 20
    end

    local isDisabled = not action.alwaysEnabled and not gameState.pet.is_alive

    if
      not isDisabled
      and x >= buttonX
      and x <= buttonX + Shop.BUTTON_WIDTH
      and y >= buttonY
      and y <= buttonY + Shop.BUTTON_HEIGHT
    then
      if action.action == "close" then
        gameState.showShop = false
      elseif action.action == "feed" then
        gameState.pet:feed()
      elseif action.action == "rest" then
        gameState.pet:rest()
      elseif action.action == "play" then
        gameState.pet:play()
      elseif action.action == "medicine" then
        gameState.pet:give_medicine()
      elseif action.action == "treat" then
        gameState.pet:give_treat()
      elseif action.action == "exercise" then
        gameState.pet:exercise()
      elseif action.action == "vitamins" then
        gameState.pet:give_vitamins()
      elseif action.action == "train" then
        gameState.pet:train()
      elseif action.action == "cuddle" then
        gameState.pet:cuddle()
      elseif action.action == "groom" then
        gameState.pet:groom()
      end

      if action.action ~= "close" then
        gameState.pet:check_death()
        gameState.game:save()
      end

      return true
    end
  end
  return false
end

return Shop
