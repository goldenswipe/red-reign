# Red Reign - Code Reference

## Class Hierarchy

```
Node2D (GameManager)
├── AudioStreamPlayer
├── ColorRect (Background)
├── Node2D (Map)
│   ├── Node2D (PlacementGrid)
│   ├── Path2D (EnemyPath)
│   │   └── PathFollow2D
│   └── Node2D (TowerPlacementManager)
├── Node (WaveManager)
├── CanvasLayer (UI)
│   ├── HBoxContainer
│   │   ├── Label (GoldLabel)
│   │   ├── Label (LivesLabel)
│   │   └── Label (WaveLabel)
│   ├── Control (PauseMenu)
│   ├── Control (GameOverScreen)
│   └── Control (TowerMenu)
```

## Script Reference

### GameManager (game_manager.gd)
**Purpose**: Central game controller
**Key Methods**:
- `_ready()`: Initialize game
- `_process(delta)`: Handle input
- `toggle_pause()`: Pause/unpause
- `add_gold(amount)`: Award gold
- `subtract_gold(amount)`: Spend gold
- `lose_life()`: Reduce lives
- `start_wave()`: Begin wave
- `end_game(victory)`: End game

**Key Properties**:
- `is_paused: bool` - Game paused state
- `current_level: int` - Current level
- `gold: int` - Player gold (500 start)
- `lives: int` - Player lives (20 start)
- `wave: int` - Current wave number

**Signals**:
- `gold_changed(new_gold)`
- `lives_changed(new_lives)`
- `wave_started(wave_number)`
- `game_over(victory)`

### WaveManager (wave_manager.gd)
**Purpose**: Manages enemy spawning
**Key Methods**:
- `start_wave(wave_num)`: Start specified wave
- `spawn_enemy(enemy_type)`: Spawn single enemy
- `spawn_enemy_group(type, count, delay)`: Spawn group
- `check_wave_complete()`: Check if wave finished

**Enemy Types**:
```
"basic"  → Speed: 200, Health: 30, Reward: 50
"fast"   → Speed: 300, Health: 15, Reward: 75
"tank"   → Speed: 100, Health: 80, Reward: 150
"blimp"  → Speed: 150, Health: 50, Reward: 100
```

### Tower (tower.gd)
**Purpose**: Tower behavior and targeting
**Key Methods**:
- `update_target()`: Find best enemy
- `fire()`: Shoot at target
- `take_damage(damage)`: Take damage
- `upgrade()`: Increase level/stats
- `sell()`: Remove and refund gold

**Tower Types & Stats**:
```
"basic"  → Cost: 100, Damage: 10, Fire Rate: 1.0, Range: 200
"sniper" → Cost: 200, Damage: 25, Fire Rate: 0.5, Range: 300
"splash" → Cost: 150, Damage: 15, Fire Rate: 0.8, Range: 250
```

**Key Properties**:
- `tower_type: String`
- `damage: int`
- `fire_rate: float` (shots/second)
- `range_radius: float` (pixels)
- `cost: int` (gold)
- `level: int`

### Enemy (enemy.gd)
**Purpose**: Enemy behavior and health
**Key Methods**:
- `take_damage(damage)`: Receive damage
- `update_health_bar()`: Update display
- `die()`: Death and cleanup
- `reach_end()`: Reach goal end
- `is_alive()`: Check alive status

**Key Properties**:
- `speed: float`
- `max_health: int`
- `current_health: int`
- `gold_reward: int`
- `enemy_type: String`
- `path_progress: float` (0.0 to 1.0)

### Projectile (projectile.gd)
**Purpose**: Projectile firing and impact
**Key Methods**:
- `_process(delta)`: Move toward target
- `_on_area_entered(area)`: Handle impact

**Key Properties**:
- `target: Enemy` - Target enemy
- `damage: int` - Damage dealt
- `speed: float` - Movement speed
- `lifetime: float` - Max lifetime (seconds)

### UIManager (ui_manager.gd)
**Purpose**: UI updates and display
**Key Methods**:
- `update_display()`: Refresh all UI
- `_on_gold_changed(new_gold)`: Update gold display
- `_on_lives_changed(new_lives)`: Update lives display
- `_on_wave_started(wave_number)`: Update wave display

### TowerPlacementManager (tower_placement_manager.gd)
**Purpose**: Handle tower placement
**Key Methods**:
- `select_tower(tower_type)`: Select tower to place
- `create_preview_tower()`: Show placement preview
- `update_preview_position()`: Update preview location
- `check_valid_placement(pos)`: Validate placement
- `try_place_tower()`: Attempt placement
- `place_tower(type, pos)`: Place tower on map

### PlacementGrid (placement_grid.gd)
**Purpose**: Tower placement validation
**Key Methods**:
- `is_near_path(position)`: Check if too close to path
- `toggle_grid_visibility()`: Show/hide grid

## Game Flow Diagram

```
START → GameManager.start_game()
  ↓
WaveManager.start_wave(1)
  ↓
[GAMEPLAY LOOP]
├─ Player places towers (TowerPlacementManager)
├─ Towers fire at enemies (Tower.fire())
├─ Enemies take damage (Enemy.take_damage())
├─ Enemies move along path (Enemy._process())
├─ UI updates (UIManager)
└─ Check wave complete? → start next wave
  ↓
[Wave Complete After Wave 10]
  ↓
END_GAME(victory=true)

[OR]

[Lives reach 0]
  ↓
GameManager.lose_life() → lives <= 0
  ↓
END_GAME(victory=false)
```

## Common Development Tasks

### Add New Enemy Type
1. Add stats in `wave_manager.gd` spawn_enemy() switch
2. Add color in `enemy.gd` get_color_by_type()
3. Add to wave_data in WaveManager.wave_data array

### Add New Tower Type
1. Duplicate tower scene in `scenes/towers/`
2. Update tower.gd properties in scene
3. Add to tower_templates in `tower_placement_manager.gd`
4. Add to get_tower_data() function

### Adjust Difficulty
- **Easier**: Increase `lives`, decrease `count` in waves
- **Harder**: Decrease `lives`, increase enemy stats, increase wave count

### Add Wave
Edit `wave_manager.gd` wave_data array:
```gdscript
{
    "count": 15,
    "type": "basic",
    "delay": 0.3,
    "mixed": [
        {"type": "fast", "count": 5, "delay": 0.4}
    ]
}
```

## Signal Flow

```
GameManager signals:
├─ gold_changed → UIManager._on_gold_changed()
├─ lives_changed → UIManager._on_lives_changed()
├─ wave_started → UIManager._on_wave_started()
└─ game_over → GameOverScreen.show_victory/defeat()

Enemy signals:
├─ reached_end → GameManager.lose_life()
└─ died → GameManager.add_gold()

Tower signals:
└─ target_destroyed → fire_at_next_target()
```

## Performance Notes

- Max enemies per wave recommended: 50-100
- Max towers on map: 20-40 (depends on hardware)
- Projectile lifetime: 5 seconds (auto-cleanup)
- Update path calculations every 0.1 seconds

## Asset Paths

```
res://assets/
├── sprites/
│   ├── towers/
│   │   ├── basic_tower.png
│   │   ├── sniper_tower.png
│   │   └── splash_tower.png
│   └── enemies/
│       ├── basic_enemy.png
│       ├── fast_enemy.png
│       ├── tank_enemy.png
│       └── blimp_enemy.png
├── sounds/
│   ├── tower_fire.wav
│   ├── enemy_death.wav
│   └── ui_click.wav
└── music/
    ├── level_01.ogg
    └── boss_wave.ogg
```

---

Use this reference for quick lookups while developing!
