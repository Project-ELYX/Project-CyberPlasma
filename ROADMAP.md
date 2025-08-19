cross between eDEX-UI and Daemon2 reskin for Plasma KDE, but modular, moveable and without security concerns. Also adds several unique elements and custom theming. 


## POTENTIAL IDEAS AND IMPLEMENTATIONS ##
- Mode switch between "command" mode (more eDEX styled where the terminal is centre, then the globe, filesystem viewer, network and system panels are all brought up into place and solid locked) and then "control" mode (where terminal isnt up by default, file system viewer isnt either, and layout shifts to be more like Daemon2 for other non terminal focused workflows, but moves around but still keeps system and network panels, shifts some to top bar or taskbar and then others to the "desktop"). toggle mode via hotkey or small icon

-autohide dock in control mode (no dock/taskbar/top bar in command mode)
- consider using one side and one bottom panel, or only one bottom panel to maximize screen space. (as far as taskbar and stuff)


## eDEX-UI CARRYOVERS AND DELETIONS ##

# COMMAND MODE #

- No on screen keyboard
- want the worldview global network endpoint map
- want all system tray items (cpu usage but per core like btop, memory, top processes, uptime, date, time, temp) but remove type: linux, only show power (charge or battery) if it is a laptop being run on. swap manufacturer/model/chassis for model of cpu/gpu/motherboard.
- want network status, including state, IP (but local and public), ping, and interface. add vpn identifier on/off either here or in the global network map globe. also keep network up/down traffic
- Keep tabbed terminal views
-add panel for music visualizer and media control
- more for terminal-centric workflows; if two or more monitors, they can be split between the different modes

# CONTROL MODE #

-No on screen keyboard
- No filesystem view (open via hotkey or taskbar/search, standard use)
-No terminal view (open via hotkey or taskbar/search, standard use)
- Layout turns more like Daemon2 (fancy desktop with more freedom)
- System panel:
    - Shift date/time/power to taskbar
    - Allow options for system monitors: either some in taskbar either as text or btop style  small graphs, or as plasmoid/eww snap widgets with custom bordering on the desktop. Ensure display options for every detected sensor on the system, like Vitals is for GNOME.
    - Top processes an optional desktop widget
    - System specs optional desktop widget
- Network Panel:
    - Worldview endpoint globe thing as its own widget
    - Network/vpn status, IPs, up/down traffic etc can either be as desktop widgets or integrated into taskbar/top panel. offer the option.
- Add option for desktop or taskbar/top bar media control and audio visualizer