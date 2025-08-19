# CyberPlasma systemd user units

These units manage optional components for the CyberPlasma setup.

## Units
- `cyberplasma.target` – groups all CyberPlasma services.
- `eww.service` – launches EWW widgets.
- `glava.service` – starts the GLava audio visualizer.
- `yakuake.service` – runs the Yakuake drop-down terminal.

## Dependencies
- `eww` for `eww.service`
- `glava` for `glava.service`
- `yakuake` for `yakuake.service`

Ensure these packages are installed before enabling the services.

## Enablement
Copy the unit files to `~/.config/systemd/user/` and enable the target:

```bash
systemctl --user enable --now cyberplasma.target
```

This will pull in the individual services via `WantedBy=cyberplasma.target`.
