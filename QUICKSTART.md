# Red Reign - Quick Start Guide

## Installation & Setup

1. **Open in Godot 4**
   - Open Godot 4 and create a new project
   - Copy this project's files into your project directory
   - Or open the project.godot file directly

2. **Project Configuration**
   - The main scene is already configured as `res://scenes/main.tscn`
   - All scripts and dependencies are set up
   - No additional installations needed!

## First Game Run

1. Press **F5** or click **Play** to start the game
2. The first wave should begin automatically
3. You'll see:
   - Game stats in top-left (Gold, Lives, Wave)
   - Red rectangles representing towers
   - Gray rectangles representing enemies
   - Yellow squares as projectiles

## Game Controls

| Action | Key |
|--------|-----|
| Place Tower | Click on map after selecting tower type |
| Pause | **ESC** or **P** |
| Resume | **P** when paused |
| Quit | Click "Quit" button in pause menu |

## First Steps to Customize

### Change Starting Resources
Edit `scripts/game_manager.gd`:
```gdscript
func _ready():
    current_level = 1
    gold = 500          # Change starting gold
    lives = 20          # Change starting lives
```

### Adjust Tower Stats
Edit `scenes/towers/basic_tower.tscn` properties:
- `damage`: How much health enemies lose per hit
- `fire_rate`: Shots per second (higher = faster)
- `range_radius`: Attack radius in pixels
- `cost`: Gold required to build

### Modify Enemy Difficulty
Edit `scripts/wave_manager.gd` in the `spawn_enemy()` function:
```gdscript
"basic":
    enemy.speed = 200          # Pixels per second
    enemy.max_health = 30      # Hit points
    enemy.gold_reward = 50     # Gold earned when killed
```

## Create Your First Custom Tower

1. Duplicate `scenes/towers/basic_tower.tscn` → `custom_tower.tscn`
2. Modify properties:
   - Change `tower_type` to "custom"
   - Adjust damage, fire_rate, range_radius, cost
   - Change `base_color` for different appearance

3. Register in `scripts/tower_placement_manager.gd`:
```gdscript
tower_templates: Dictionary = {
    "basic": preload("res://scenes/towers/basic_tower.tscn"),
    "custom": preload("res://scenes/towers/custom_tower.tscn"),  # ADD THIS
}
```

4. Add data in `get_tower_data()`:
```gdscript
"custom": {
    "cost": 150,
    "damage": 20,
    "fire_rate": 0.8,
    "range": 250
}
```

## Understanding the Wave System

Waves are defined in `scripts/wave_manager.gd`:
```gdscript
wave_data: Array = [
    {"count": 5, "type": "basic", "delay": 0.5},   # 5 enemies spawn 0.5s apart
    {"count": 8, "type": "basic", "delay": 0.4},   # More enemies, faster spawn
    # ... more waves
]
```

## Performance Tips

If the game runs slowly:
1. Reduce number of enemies per wave in `wave_manager.gd`
2. Lower resolution in `project.godot` → `display/window/size`
3. Remove visual debug elements from scenes

## Troubleshooting

### Enemies don't spawn
- Check that `EnemyPath` exists in the scene tree
- Verify `PathFollow2D` is a child of `EnemyPath`
- Ensure wave data is not empty

### Towers don't fire
- Verify enemies are within range (check `range_radius`)
- Ensure projectile scene is at `res://scenes/projectile.tscn`
- Check tower has sufficient fire_rate

### Game crashes on start
- Open the Output panel (bottom of editor)
- Look for error messages
- Check that all script paths are correct

### Gold/Lives don't display
- Ensure UI nodes exist with correct names (GoldLabel, LivesLabel, WaveLabel)
- Check that UIManager is connected to GameManager signals

## File Organization

```
scripts/          → Game logic and behavior
├── game_manager.gd       → Main game controller
├── enemy.gd              → Enemy behavior
├── tower.gd              → Tower behavior
├── projectile.gd         → Projectile behavior
├── wave_manager.gd       → Wave spawning
└── ui_manager.gd         → UI updates

scenes/           → Game scenes
├── main.tscn             → Main game scene (START HERE)
├── enemy.tscn            → Enemy template
├── projectile.tscn       → Projectile template
└── towers/               → Tower templates
    ├── basic_tower.tscn
    ├── sniper_tower.tscn
    └── splash_tower.tscn

assets/           → Media files
├── sprites/              → Images (not yet added)
├── sounds/               → Audio effects (not yet added)
└── music/                → Background music (not yet added)
```

## Next: Add Graphics

1. Create `assets/sprites/` folder
2. Add sprite images for towers and enemies
3. In each scene, replace `ColorRect` with `Sprite2D`
4. Set `Sprite2D.texture` to your image file

## Next: Add Audio

1. Create `assets/sounds/` and `assets/music/` folders
2. Add `.ogg` or `.mp3` audio files
3. Drag audio to `AudioStreamPlayer` nodes
4. Adjust `AudioStreamPlayer.bus` property

## Common Tasks

### Increase Difficulty
- Reduce `delay` between enemy spawns
- Increase `count` of enemies
- Reduce `lives` starting amount
- Increase enemy `speed` or `max_health`

### Make Towers Stronger
- Increase `damage` value
- Increase `fire_rate` (higher number = faster)
- Increase `range_radius`
- Reduce `cost`

### Add More Waves
- Add entries to `wave_data` array in `wave_manager.gd`
- Create mixed wave example:
```gdscript
{
    "count": 10,
    "type": "basic",
    "delay": 0.3,
    "mixed": [
        {"type": "fast", "count": 3, "delay": 0.5},
        {"type": "tank", "count": 2, "delay": 1.0}
    ]
}
```

## Getting Help

1. Check Godot documentation: https://docs.godotengine.org
2. Review GDScript guide: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html
3. Look at script comments for implementation details
4. Use the Output panel to debug errors

---

**Have fun developing Red Reign! 🎮**
