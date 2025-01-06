local Constants = {
	General = {
		WINDOW_WIDTH = 700,
		WINDOW_HEIGHT = 500,
		BAR_WIDTH = 150,
		BAR_HEIGHT = 10,
		BAR_PADDING = 15,
		STATS_X = 20,
		STATS_Y = 395,
		STATUS_BOX_PADDING = 15,
		BUTTON_WIDTH = 120,
		BUTTON_HEIGHT = 55,
		BUTTON_PADDING = 10,
		BUTTON_ICON_PADDING = 35,
		BUTTONS_START_X = 570,
		BUTTONS_START_Y = 70,
	},
	Cemetery = {
		WINDOW_PADDING = 10,
		POPUP_WIDTH = 600,
		POPUP_HEIGHT = 400,
		HEADER_HEIGHT = 30,
		ROW_HEIGHT = 25,
		COLUMN_PADDING = 10,
	},
	Shop = {
		WINDOW_PADDING = 20,
		POPUP_WIDTH = 400,
		POPUP_HEIGHT = 500,
		RADIO_SIZE = 8,
		RADIO_SPACING_X = 180,
		RADIO_SPACING_Y = 60,
		ICON_SIZE = 45,
		ICON_PADDING = 10,
		COIN_COLUMN_OFFSET = 60,
		BUY_BUTTON = {
			width = 120,
			height = 30,
		},
	},
}

return setmetatable(Constants, {
	__index = function(_, k)
		error("Trying to access undefined config key: " .. k)
	end,
})
