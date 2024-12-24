-- Load Utils and Config as globals
require("src.globals")

-- Initialize game
local Game = require("src.game")
local game = Game.new()

-- Main game loop
local function main()
	print("Welcome to PetSim!")

	while true do
		print("\n--- Day " .. game.current_day .. " ---")
		print("1. Create Pet")
		print("2. List Pets")
		print("3. Interact with Pet")
		print("4. Show Pet Status")
		print("5. Advance Day")
		print("6. Save Game")
		print("7. Load Game")
		print("8. Exit")

		io.write("Choose an option: ")
		local choice = io.read("*n")

		if choice == 1 then
			io.write("Enter pet name (or leave blank for random): ")
			_ = io.read("*l") -- Clear the buffer
			local name = io.read("*l")
			name = (name == "" or name == nil) and Utils.generate_pet_name() or name

			print("\nSelect species:")
			print("1. Dog")
			print("2. Cat")
			print("3. Generic")
			io.write("Choose species (1-3): ")
			local species_choice = tonumber(io.read("*l"))
			local species = "generic"
			if species_choice == 1 then
				species = "dog"
			elseif species_choice == 2 then
				species = "cat"
			end

			print("\nSelect difficulty:")
			print("1. Easy")
			print("2. Normal")
			print("3. Hard")
			io.write("Choose difficulty (1-3): ")
			local diff_choice = tonumber(io.read("*l"))
			local difficulty = "normal"
			if diff_choice == 1 then
				difficulty = "easy"
			elseif diff_choice == 3 then
				difficulty = "hard"
			end

			local pet = game:create_pet(name, species, difficulty)
			print("Created pet: " .. pet.name .. " (" .. species:upper() .. ", Difficulty: " .. difficulty .. ")")
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
			local pets = game:get_pets()
			if #pets == 0 then
				print("No pets to check!")
			else
				print("Choose a pet:")
				for i, pet in ipairs(pets) do
					print(i .. ". " .. pet.name)
				end

				io.write("Pet number: ")
				local pet_choice = io.read("*n")
				local pet = pets[pet_choice]

				if pet then
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
			end
		elseif choice == 5 then
			game:advance_day()
			print("Day advanced!")
		elseif choice == 6 then
			if game:save() then
				print("Game saved successfully!")
			end
		elseif choice == 7 then
			local loaded_game = game:load()
			if loaded_game then
				game = loaded_game
				print("Game loaded successfully!")
			end
		elseif choice == 8 then
			print("Thanks for playing PetSim!")
			break
		else
			print("Invalid option!")
		end
	end
end

-- Run the game
main()
