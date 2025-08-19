# CyberPlasma systemd user units

These units manage optional components for the CyberPlasma setup.

## Units
- `cyberplasma.target` – groups all CyberPlasma services.
- `eww.service` – launches EWW widgets (`top_bar`, `left_column`).
- `glava.service` – starts the GLava audio visualizer.
- `yakuake.service` – runs the Yakuake drop-down terminal.
- `bismuth-mode.service` – restores the last Bismuth tiling mode on login.

## Dependencies
- `eww` for `eww.service`
- `glava` for `glava.service`
- `yakuake` for `yakuake.service`
- `bismuth` for `bismuth-mode.service`

Ensure these packages are installed before enabling the services.

## Widgets
The `eww.service` expects widgets named `top_bar` and `left_column` to be defined in your EWW configuration.

## Enablement
Copy the unit files to `~/.config/systemd/user/` and enable the target:

```bash
systemctl --user enable --now cyberplasma.target
```

This will pull in the individual services via `WantedBy=cyberplasma.target`.

## Plasma Panel Setup
The tiling toggle integrates with a helper script that can hide a
Plasma panel on a specific screen when entering **Command Mode** and
show it again for **Control Mode**.  Determine the screen ID of the
panel you want managed:

```bash
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.panelIds
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'panelById(PANEL_ID).screen'
```

Export `CYBERPLASMA_PANEL_SCREEN_ID` with the desired screen number so
`toggle_tiling.sh` knows which panel to control.

```bash
export CYBERPLASMA_PANEL_SCREEN_ID=1
```

Copy the `panel_visibility.sh` script to `~/scripts/` if it is not
already present.
