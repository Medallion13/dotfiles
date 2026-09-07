# mkdir + cd en un solo paso
mkcd() { mkdir -p "$1" && cd "$1"; }

# Ver qué proceso ocupa un puerto
port() { lsof -nP -iTCP:"$1" -sTCP:LISTEN; }

# fast backup
bak() { cp -a "$1" "$1.bak.$(date +%Y%m%d%H%M%S)"; }
