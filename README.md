# Project-CyberPlasma
Cyberpunk-themed Plasma KDE rice kit. Main color theme right now is purple/cyan/magenta glow. Ships with all the goodies:

- Window decorations
- Various plasmoids for system monitors, network monitors etc..
- Color theming

## Prerequisites
- KDE Plasma 6 with KWin (X11 session required)
- Git for cloning the repository
- (Optional) [EWW](https://elkowar.github.io/eww/) for widget customization

## Security
All helper scripts in `cyberplasma/scripts` are POSIX-compliant and run without elevated privileges. Inputs are sanitized, and network requests include fixed timeouts. The project operates entirely in user space without requiring escalated permissions. Continuous integration runs ShellCheck to maintain script quality.

## Installation

### Window Decorations
1. Create the Aurorae theme directory:
   ```bash
   mkdir -p ~/.local/share/aurorae/themes/CyberPlasma
   ```
2. Copy the decoration files:
   ```bash
   cp "Window Decorations"/*.svg ~/.local/share/aurorae/themes/CyberPlasma/
   ```
3. Enable the theme from *System Settings → Appearance → Window Decorations*.

### Future EWW Config
An EWW configuration will be provided in a future update. Once available:
1. Copy the `eww/` directory to `~/.config/eww`.
2. Start the daemon and open the widgets:
   ```bash
   eww daemon
   eww open top_bar
   eww open left_column
   ```

## GridMode and FreeMode
CyberPlasma leverages KWin's tiling system and provides two layouts:

- **GridMode** – windows snap to a predefined grid for efficient tiling.
- **FreeMode** – windows float freely without tiling.

### Hotkeys
Use the following shortcuts to switch between modes:

- `Meta+G` toggles **GridMode**.
- `Meta+F` toggles **FreeMode**.
- `Meta+T`, `Meta+Shift+T`, and `Meta+Alt+T` toggle Bismuth tiling on or off.

### Persistence
The current mode is remembered and restored on login so your preferred layout
survives restarts.

### Per-app exceptions
To keep certain applications in FreeMode even when GridMode is active, create a
window rule under *System Settings → Window Management → Window Rules* and set
tiling to **Off** for that app.

### KWin Window Rules
The repository ships with rules to keep EWW widgets and the GLava visualizer on top, out of the taskbar and unfocusable.
Apply them by copying the file:
```bash
cp kde/kwinrulesrc ~/.config/kwinrulesrc
```
If you already maintain your own rules, import and merge via *System Settings → Window Management → Window Rules*.

### Floating exceptions
Bismuth's `bismuth/config.json` marks media players, Steam, and game executables so they float in Command Mode. Install it with:
```bash
mkdir -p ~/.config/bismuth
cp bismuth/config.json ~/.config/bismuth/
```


## Screenshot
A preview of the CyberPlasma setup:

![CyberPlasma screenshot](screenshot.png)
