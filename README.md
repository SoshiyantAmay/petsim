# PetSim - Virtual Pet Simulation Game

## Actions and Their Effects on Pet Attributes

### Base Effects on Pet Attributes (Before Difficulty Multipliers)

| Action    | Hunger | Happiness | Energy | Health |
|-----------|--------|-----------|---------|---------|
| Feed      | +20    | +10       | -       | -       |
| Rest      | -10    | -         | +30     | -       |
| Play      | -10    | +X*       | -Y*     | -       |
| Train     | -10    | -         | -15     | -       |
| Cuddle    | -      | +5        | -2      | -       |
| Groom     | -      | +10       | -       | +5      |
| Treat     | +5     | +15       | -       | -2      |
| Medicine  | -      | -5        | -       | +15     |
| Vitamins  | -      | -         | +10     | +5      |
| Exercise  | -15    | -         | -20     | +10     |

*Note: Play's happiness gain (X) and energy cost (Y) vary by species:
- Dog: Happiness +25, Energy -15
- Cat: Happiness +20, Energy -10
- Generic: Happiness +15, Energy -12

### Difficulty Modifiers

| Difficulty | Stat Decay Rate | Age Penalty |
|------------|-----------------|-------------|
| Easy       | 0.5x           | 0.8x        |
| Normal     | 1.0x           | 1.0x        |
| Hard       | 1.5x           | 1.2x        |

### Daily Decay (Per Age Up)
All stats (Hunger, Energy, Happiness) decrease by:
- Base: -5
- Modified by: Difficulty decay rate × Age penalty

## Additional Rules

### Attribute Constraints
- All attributes are capped between 0 and 100

### Critical States
When any of these reaches 0:
- Hunger = 0: Health -10 × difficulty_modifier
- Energy = 0: Health -10 × difficulty_modifier
- Happiness = 0: Health -10 × difficulty_modifier

### Death Condition
- When Health reaches 0, pet dies

### Difficulty Impact
The difficulty modifier affects both the positive and negative effects of actions:
- Higher difficulties result in smaller gains and larger losses
- Lower difficulties result in larger gains and smaller losses
