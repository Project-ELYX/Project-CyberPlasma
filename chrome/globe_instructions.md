🌍 Globe Widget — Design & Implementation Spec
Visual target

Uses the chrome/globe.svg bezel you already have (circle center (170, 152), radius R = 96).

Light lat/long grid is in the SVG (no heavy rendering).

We draw a pulsing pin for your current public IP location.

Optional: draw VPN badge and a tiny pin for the VPN egress if different.

Optional (later): a faint great-circle arc from “here → endpoint.”

Data sources (and privacy)

Public IP: curl --max-time 2 ifconfig.co (or ifconfig.io, etc.) — cache.

GeoIP:

Preferred offline: GeoLite2-City (MaxMind) via mmdblookup or a tiny Python reader.

Online fallback (if you’re okay with it): ipinfo.io/$IP (again, cache).

VPN state: nmcli -g NAME,TYPE,STATE con show --active or presence of wg0/tun*.

Ping: ping -c1 -w1 1.1.1.1 | awk (or fping -c1 -t500) — clamp to 3–5 s.

Caching: write JSON to ~/.cache/cyberplasma/globe.json with {ip, lat, lon, ts}. Refresh every 300–600 s or on IP change.

If requests fail, show the bezel + “No IP” and keep the last known pin dimmed.

Projection (orthographic) — the right way

Let:

φ = latitude (radians), λ = longitude (radians) of the point (your location).

φ₀, λ₀ = globe center lat/lon (radians).

Default: center on your own location → φ₀=φ, λ₀=λ (pin sits dead center).

Alternative: center on a fixed (φ₀,λ₀)= (0,0) if you prefer a world-centric view.

Orthographic equations: