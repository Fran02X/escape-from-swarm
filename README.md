# Escape From Swarm

A small top-down arena survival game made with **Godot 4**.

You are stuck in an arena while swarms of geometric creatures close in from
every side. Move, survive, and take down as many as you can.

> **Status: early prototype.** Mechanics and content are still changing fast.
> Nothing here is final, and save files are not compatible between versions.

## Features

- [x] Godot project skeleton
- [ ] Player movement (`WASD`)
- [ ] Automatic aiming and shooting at the nearest enemy
- [ ] Enemies spawning from the arena edges and chasing the player
- [ ] Bullets, damage and enemy death
- [ ] Player health, death and score
- [ ] Restart loop

## Requirements

- **Godot 4.7** or newer, standard build (no C#/.NET)
- Windows, Linux or macOS

The project uses the **Compatibility** renderer, so it also runs on older
integrated GPUs and can be exported to the web later.

## Running

```bash
git clone https://github.com/Fran02X/escape-from-swarm.git
```

1. Open Godot and click **Import**.
2. Select `project.godot` from the cloned folder.
3. Press **F5** to run.

## Controls

| Action | Key |
|---|---|
| Move | `W` `A` `S` `D` |

More controls will be documented as mechanics land.

## Project structure

```
escape-from-swarm/
├── project.godot      # Godot project configuration
├── icon.svg           # Project icon
├── LICENSE
└── README.md
```

Directories for scenes, scripts and assets will be added as the game grows.

## Roadmap

| Version | Goal |
|---|---|
| v0.1 | Playable arena loop: move, shoot, die, restart |
| v0.2 | Waves, difficulty ramp, persistent high score |
| v0.3 | Upgrades between waves |
| v0.4 | Audio, visual polish, web export |

## License

[MIT](LICENSE)
