package.path = "./src/?.lua;" .. package.path
package.path = "./lib/?.lua;" .. package.path

local Game = require("src.game")
local Utils = require("src.utils")

-- Initialize game
local game = Game.new()

-- Main game loop
local function main()
	print("Welcome to PetSim!")

	while true do
		print("\n--- Day " .. game.current_day .. " ---")
		print("1. Create Pet")
		print("2. List Pets")
		print("3. Interact with Pet")
		print("4. Advance Day")
		print("5. Save Game")
		print("6. Load Game")
		print("7. Exit")

		io.write("Choose an option: ")
		local choice = io.read("*n")

		if choice == 1 then
			io.write("Enter pet name (or leave blank for random): ")
			local name = io.read()
			name = name == "" and Utils.generate_pet_name() or name

			local pet = game:create_pet(name, "Dog")
			print("Created pet: " .. pet.name)
		elseif choice == 2 then
			local pets = game:get_pets()
			for i, pet in ipairs(pets) do
				local status = pet:get_status()
				print(string.format("%d. %s (Status: %s)", i, status.name, status.is_alive and "Alive" or "Dead"))
			end
		elseif choice == 3 then
			local pets = game:get_pets()
			if #pets == 0 then
				print("No pets to interact with!")
			else
				print("Choose a pet:")
				for i, pet in ipairs(pets) do
					print(i .. ". " .. pet.name)
				end

				io.write("Pet number: ")
				local pet_choice = io.read("*n")
				local pet = pets[pet_choice]

				if pet then
					print("\nActions:")
					print("1. Feed")
					print("2. Play")
					print("3. Rest")

					io.write("Choose action: ")
					local action = io.read("*n")

					if action == 1 then
						pet:feed()
					elseif action == 2 then
						pet:play()
					elseif action == 3 then
						pet:rest()
					end

					print("Action completed!")
				end
			end
		elseif choice == 4 then
			game:advance_day()
			print("Day advanced!")
		elseif choice == 5 then
			if game:save() then
				print("Game saved successfully!")
			end
		elseif choice == 6 then
			local loaded_game = game:load()
			if loaded_game then
				game = loaded_game
				print("Game loaded successfully!")
			end
		elseif choice == 7 then
			print("Thanks for playing PetSim!")
			break
		else
			print("Invalid option!")
		end
	end
end

-- Run the game
main()
