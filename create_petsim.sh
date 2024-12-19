#!/bin/bash

# Create project directory
PROJECT_DIR="petsim"
mkdir -p "$PROJECT_DIR"

# Create subdirectories
mkdir -p "$PROJECT_DIR/src"
mkdir -p "$PROJECT_DIR/data"
mkdir -p "$PROJECT_DIR/lib"
mkdir -p "$PROJECT_DIR/tests"

# Create source files
touch "$PROJECT_DIR/src/main.lua"
touch "$PROJECT_DIR/src/pet.lua"
touch "$PROJECT_DIR/src/game.lua"
touch "$PROJECT_DIR/src/utils.lua"

# Create data files
touch "$PROJECT_DIR/data/pets.json"
touch "$PROJECT_DIR/data/saves.json"

# Create configuration and readme
touch "$PROJECT_DIR/config.lua"
touch "$PROJECT_DIR/README.md"

# Optional: Add initial content to README
echo "# PetSim - Virtual Pet Simulation Game" > "$PROJECT_DIR/README.md"

echo "PetSim project structure created successfully in $PROJECT_DIR"
