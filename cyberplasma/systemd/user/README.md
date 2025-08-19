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
