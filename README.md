# 🌌 Lua Space

Lua Space is a tiny solar system of classic-inspired video games built in Lua. Each planet hosts a different game you can play with a friend in a cooperative experience.

Currently, the system includes three games:

- 🛸 Space Invaders
- 💀 Thanks
- 🏓 Pong

## 🚀 Getting Started

### Requirements

- LÖVE2D

### Run the game

Clone the repository and launch it with LÖVE2D:

~~~ powershell
git clone <repo>
love lua-space
~~~

~~~ powershell
📂 Project Structure
lua-space/
│── assets/         # Fonts and other reusable resources
│── images/         # All image files (sprites, textures, backgrounds, etc.)
│── shaders/        # GLSL shader code
│── minigames/      # Each minigame is a Lua table with update(dt) and draw()
│── main_hub.lua    # The hub world where you choose planets (minigames)
│── planets.lua     # Planet creation logic
│── particles.lua   # Particle system code
│── player.lua      # Player logic for the hub
│── shader.lua      # Core shader handling
│── controls.lua    # Drawing and handling controls
│── conf.lua        # LÖVE2D configuration file
│── main.lua        # Main entry point
~~~

## 🕹️ How It Works

Main Hub: The starting area where you control your player and choose planets.

Planets: Each planet represents a different minigame.

Minigames: Implemented as Lua tables exposing two functions:

update(dt) → updates game logic

draw() → renders the game

The hub calls these functions to run the selected minigame seamlessly.

# ✨ Future Plans

Add more planets (minigames)

Expand shaders and visual effects

New assets (fonts, music, etc.)