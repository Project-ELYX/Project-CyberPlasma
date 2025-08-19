# Project-CyberPlasma
Cyberpunk-themed Plasma KDE rice kit. Main color theme right now is purple/cyan/magenta glow. Ships with all the goodies:

- Window decorations
- Various plasmoids for system monitors, network monitors etc..
- Color theming

## Prerequisites
- KDE Plasma 5 with KWin
- Git for cloning the repository
- (Optional) [EWW](https://elkowar.github.io/eww/) for widget customization

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
   eww open cyberbar
   ```

## Screenshot
A preview of the CyberPlasma setup:

![CyberPlasma screenshot](screenshot.png)
