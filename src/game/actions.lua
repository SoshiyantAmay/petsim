local Actions = {
    feed = {
        health = 0,
        hunger = 20,
        happiness = 10,
        energy = 0,
        intelligence = 0
    },
    rest = {
        health = 0,
        hunger = -10,
        happiness = 0,
        energy = 30,
        intelligence = 0
    },
    play = {
        health = 0,
        hunger = -10,
        happiness = 15,
        energy = -12,
        intelligence = 0
    },
    train = {
        health = 0,
        hunger = -10,
        happiness = 0,
        energy = -15,
        intelligence = 10
    },
    cuddle = {
        health = 0,
        hunger = 0,
        happiness = 5,
        energy = -2,
        intelligence = 0
    },
    groom = {
        health = 5,
        hunger = 0,
        happiness = 10,
        energy = 0,
        intelligence = 0
    },
    treat = {
        health = -2,
        hunger = 5,
        happiness = 15,
        energy = 0,
        intelligence = 0
    },
    medicine = {
        health = 15,
        hunger = 0,
        happiness = -5,
        energy = 0,
        intelligence = 0
    },
    vitamins = {
        health = 5,
        hunger = 0,
        happiness = 0,
        energy = 10,
        intelligence = 0
    },
    exercise = {
        health = 10,
        hunger = -15,
        happiness = 0,
        energy = -20,
        intelligence = 0
    }
}

return Actions