-- Load globals
require("src.globals")

-- Initialize game
local Game = require("src.game")
local game = Game.new()

local Menu = {
	SHOW_STATUS = 1,
	FEED = 2,
	PLAY = 3,
	REST = 4,
	ADVANCE_DAY = 5,
	SAVE = 6,
	EXIT = 7,
}

local function print_menu()
	print("\n--- Day " .. game.current_day .. " ---")
	print(Menu.SHOW_STATUS .. ". Show Pet Status")
	print(Menu.FEED .. ". Feed Pet")
	print(Menu.PLAY .. ". Play with Pet")
	print(Menu.REST .. ". Rest Pet")
	print(Menu.ADVANCE_DAY .. ". Advance Day")
	print(Menu.SAVE .. ". Save Game")
	print(Menu.EXIT .. ". Exit")
end

local function show_pet_status(pet)
	local status = pet:get_status()
	print("\n=== " .. status.name .. "'s Status ===")
	print("Species: " .. status.species)
	print("Difficulty: " .. status.difficulty)
	print("Age: " .. status.age .. " days")
	print("Health: " .. status.health .. "%")
	print("Hunger: " .. status.hunger .. "%")
	print("Happiness: " .. status.happiness .. "%")
	print("Energy: " .. status.energy .. "%")
	print("Status: " .. (status.is_alive and "Alive" or "Dead"))
	print("========================")
end

local function select_difficulty()
	print("\nSelect difficulty:")
	print(Difficulty.EASY .. ". Easy")
	print(Difficulty.NORMAL .. ". Normal")
	print(Difficulty.HARD .. ". Hard")
	io.write("Choose difficulty (1-3): ")
	local diff_choice = tonumber(io.read("*l"))
	return Difficulty.get_name(diff_choice)
end

local function initialize_game()
	if not game:load() then
		print("\nNo pet found. Creating a new pet...")
		local difficulty = select_difficulty()
		game:create_pet("Blob", "generic", difficulty)
        game:save()
	end

	local pets = game:get_pets()
	if #pets > 0 then
		show_pet_status(pets[1])
	end
end

-- Main game loop
local function main()
	print("Welcome to PetSim!")
	initialize_game()

	while true do
		print_menu()

		io.write("Choose an option: ")
		local choice = tonumber(io.read("*l"))
		local pets = game:get_pets()
		local pet = pets[1]

		if choice == Menu.SHOW_STATUS then
			show_pet_status(pet)
		elseif choice == Menu.FEED then
			if pet:feed() then
				print("Pet fed successfully!")
				show_pet_status(pet)
				game:save()
			end
		elseif choice == Menu.PLAY then
			if pet:play() then
				print("Played with pet!")
				show_pet_status(pet)
				game:save()
			end
		elseif choice == Menu.REST then
			if pet:rest() then
				print("Pet rested!")
				show_pet_status(pet)
				game:save()
			end
		elseif choice == Menu.ADVANCE_DAY then
			game:advance_day()
			print("Day advanced!")
			show_pet_status(pet)
			game:save()
		elseif choice == Menu.SAVE then
			if game:save() then
				print("Game saved successfully!")
			end
		elseif choice == Menu.EXIT then
			print("Thanks for playing PetSim!")
			break
		else
			print("Invalid option!")
		end
	end
end

-- Run the game
main()
