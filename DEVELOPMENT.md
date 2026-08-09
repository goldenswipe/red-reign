# Red Reign Development Guide

## Project Setup Checklist

This document provides a step-by-step guide to complete and enhance the Red Reign Godot project.

## Phase 1: Core Game Loop (Complete)
- [x] Game manager and state management
- [x] Enemy spawning and wave management
- [x] Tower placement system
- [x] Tower firing and projectiles
- [x] Enemy pathfinding and damage
- [x] UI displays (gold, lives, wave)

## Phase 2: Audio Setup

### Audio Buses
The project defines three audio buses in `project.godot`:
- `Master`: Main volume control
- `Effects`: Tower shots and sound effects
- `Music`: Background music

### Adding Audio Files
1. Create `/assets/music/` and `/assets/sounds/` directories
2. Add `.mp3` or `.ogg` files for:
   - Background music
   - Tower firing sounds
   - Enemy death sounds
   - UI click sounds
   - Wave start sound

### Assign to Game
- Drag music files to `$AudioStreamPlayer` in main scene
- Add sound effects to individual tower/enemy nodes

## Phase 3: Graphics & Visuals

### Sprite Setup
1. Create `assets/sprites/` directory
2. Add 2D sprite art for:
   - Towers (basic, sniper, splash)
   - Enemies (basic, fast, tank, blimp)
   - UI elements
   - Map background

### Implementing Sprites
Replace ColorRect nodes with Sprite2D nodes:
```gdscript
# In tower.gd or enemy.gd
@onready var sprite = $Sprite2D
sprite.texture = preload("res://assets/sprites/tower_basic.png")
```

### Map Design
1. Create a background image or design in `assets/`
2. Set as `Background` ColorRect texture
3. Design enemy path using Path2D curve editor in Godot

## Phase 4: Map & Level Design

### Create Custom Path
1. In the Godot Editor, select `Map/EnemyPath`
2. Use the curve editing tools to draw a winding path
3. Adjust `path_follow.curve.bake_interval` for smoothness
4. Test path by running game

### Multiple Maps
1. Create different main scene variations
2. Store in `scenes/maps/` subdirectory
3. Implement map selection in main menu

## Phase 5: Enhanced UI

### Main Menu
Create `scenes/menu.tscn` with:
- Game title
- Play button
- Settings button
- Credits button

### Tower Shop
Create `scenes/ui/tower_shop.tscn`:
```gdscript
# Show available towers with previews
# Display cost and stats
# Handle selection
```

### Upgrade Menu
Implement in-game tower upgrade interface:
- Click tower to show menu
- Upgrade button with cost
- Sell button with refund calculation

## Phase 6: Game Balance & Polish

### Balance Parameters
Adjust in respective files:
- Enemy health/speed: `wave_manager.gd`
- Tower damage/cost: `tower.gd` and scene files
- Gold progression: `game_manager.gd`
- Wave difficulty: `wave_manager.gd` wave_data array

### Recommended Progression
```
Wave  | Enemies      | Types          | Difficulty
1-3   | Basic        | Basic only     | Easy
4-6   | Mixed        | Basic + Fast   | Medium
7-8   | Complex      | All types      | Hard
9-10  | Endless      | High stats     | Very Hard
11+   | Escalating   | Boss types     | Insane
```

### Economy Balance
- Starting gold: 500
- Basic tower cost: 100
- Medium tower cost: 150-200
- Enemy kill rewards: 50-150 based on type
- Upgrade cost: 25-50 per level

## Phase 7: Advanced Features

### Special Tower Types
```gdscript
# Create specialized towers
- Ice Tower: Slows enemies
- Laser Tower: High single target
- Cannon Tower: Area damage
- Tesla Tower: Chain damage
```

### Enemy Abilities
```gdscript
# Add boss enemies
- Flying: Ignores collision
- Regenerating: Heals over time
- Splitting: Spawns smaller units
- Shielded: Reduces damage
```

### Power-ups
- Double damage
- Slow time
- Extra lives
- Gold multiplier

## Phase 8: Polish & Optimization

### Performance
- Use object pooling for projectiles
- Implement spatial partitioning for tower targeting
- Optimize path calculations

### Visual Effects
- Add screen shake on tower fire
- Particle effects for explosions
- Damage number pop-ups
- Tower build/sell animations

### Quality of Life
- Keyboard shortcuts for tower selection
- Speed controls (1x/2x/4x)
- Replay function
- Statistics/achievements

## Common GDScript Patterns

### Adding a New Tower Type
```gdscript
# 1. Create scene in scenes/towers/
# 2. Add to tower_placement_manager.gd:
tower_templates: Dictionary = {
    "custom": preload("res://scenes/towers/custom_tower.tscn"),
}

# 3. Add to tower data function:
"custom": {"cost": 200, "damage": 20, "fire_rate": 0.7, "range": 250}

# 4. Configure in scene inspector
```

### Adding Wave Enemy Type
```gdscript
# 1. In enemy.gd, add to get_color_by_type():
"custom": return Color.CYAN

# 2. In wave_manager.gd, add stats in spawn_enemy():
"custom":
    enemy.speed = 250
    enemy.max_health = 40
    enemy.gold_reward = 75

# 3. Add to wave_data in WaveManager
```

### Creating Upgrade System
```gdscript
# In tower.gd
var upgrades: Dictionary = {
    "damage": {"cost": 50, "multiplier": 1.2},
    "speed": {"cost": 40, "multiplier": 1.15},
    "range": {"cost": 60, "multiplier": 1.1}
}

func purchase_upgrade(upgrade_type: String):
    var cost = upgrades[upgrade_type]["cost"]
    # Implement purchase logic
```

## Debugging Tips

### Check Wave Spawning
```gdscript
# Add to wave_manager.gd _ready():
print("Wave data loaded: ", wave_data.size(), " waves")

# In spawn_wave():
print("Spawning wave ", current_wave, " with ", wave_info["count"], " enemies")
```

### Monitor Tower Targeting
```gdscript
# In tower.gd update_target():
print("Current target: ", current_target.enemy_type if current_target else "None")
```

### Check Gold/Lives
```gdscript
# In game_manager.gd:
print("Gold: ", gold, " | Lives: ", lives)
```

## Directory Structure After Completion

```
red-reign/
├── project.godot
├── README.md
├── DEVELOPMENT.md
├── scenes/
│   ├── main.tscn
│   ├── menu.tscn
│   ├── enemy.tscn
│   ├── projectile.tscn
│   ├── maps/
│   │   ├── map_level1.tscn
│   │   └── map_level2.tscn
│   ├── towers/
│   │   ├── basic_tower.tscn
│   │   ├── sniper_tower.tscn
│   │   ├── splash_tower.tscn
│   │   ├── ice_tower.tscn
│   │   └── laser_tower.tscn
│   └── ui/
│       ├── tower_shop.tscn
│       ├── pause_menu.tscn
│       └── game_over.tscn
├── scripts/
│   ├── game_manager.gd
│   ├── ui_manager.gd
│   ├── tower.gd
│   ├── tower_placement_manager.gd
│   ├── enemy.gd
│   ├── projectile.gd
│   ├── wave_manager.gd
│   ├── pause_menu.gd
│   ├── game_over_screen.gd
│   ├── tower_menu.gd
│   └── placement_grid.gd
├── assets/
│   ├── sprites/
│   │   ├── towers/
│   │   ├── enemies/
│   │   ├── ui/
│   │   └── effects/
│   ├── sounds/
│   │   ├── towers/
│   │   ├── enemies/
│   │   ├── ui/
│   │   └── effects/
│   └── music/
│       ├── menu.ogg
│       ├── level1.ogg
│       └── boss.ogg
└── .gitignore
```

## Next Steps

1. Set up the audio system
2. Create sprite assets or use placeholder rectangles
3. Design game maps and paths
4. Implement main menu
5. Add tower upgrade/sell functionality
6. Balance game difficulty
7. Add visual feedback and effects
8. Optimize performance
9. Add additional content (maps, towers, enemies)
10. Release!

---

**Remember**: Start simple, test frequently, and iterate on gameplay before adding complex features.
