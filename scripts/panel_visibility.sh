#!/usr/bin/env bash
# Show or hide a Plasma panel on a given screen using DBus.
# Usage: panel_visibility.sh [show|hide] <screen-id>

set -euo pipefail

action="${1:-}"
screen="${2:-}"

if [[ -z "$action" || -z "$screen" ]]; then
    echo "Usage: $0 [show|hide] <screen-id>" >&2
    exit 1
fi

if [[ "$action" != "show" && "$action" != "hide" ]]; then
    echo "Action must be 'show' or 'hide'" >&2
    exit 1
fi

script="
const ids = panelIds;
for (var i = 0; i < ids.length; ++i) {
  var p = panelById(ids[i]);
  if (p.screen === $screen) {
    if ('$action' === 'hide') {
      p.hiding = 'autohide';
      p.hide();
    } else {
      p.hiding = 'none';
      p.show();
    }
  }
}
"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$script"
