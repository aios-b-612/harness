#!/usr/bin/env bash
# Instala o perfil AIOS em ~/.config/opencode (qualquer usuário).
# Canônico: <repo>/profile/
set -euo pipefail

PROFILE="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${OPENCODE_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/opencode}"

echo "=== Harness profile ==="
echo "  from: $PROFILE"
echo "  to:   $DEST"

mkdir -p "$DEST/agents" "$DEST/skills"

cp -a "$PROFILE/AGENTS.md" "$DEST/AGENTS.md"

# agents
rm -f "$DEST/agents/alfred.md" "$DEST/agents/orquestrador.md" "$DEST/agents/ops-local.md" 2>/dev/null || true
cp -a "$PROFILE/agents/"*.md "$DEST/agents/"

# skills (full replace of known AIOS skills; keep unknown user skills)
for d in "$PROFILE/skills"/*; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  rm -rf "$DEST/skills/$name"
  cp -a "$d" "$DEST/skills/$name"
done

# merge defaults into opencode.json (python3; fallback: write if missing)
python3 - "$PROFILE/defaults.json" "$DEST/opencode.json" <<'PY'
import json, os, sys, time
from pathlib import Path

defaults_path, cfg_path = Path(sys.argv[1]), Path(sys.argv[2])
defaults = json.loads(defaults_path.read_text())
defaults.pop("$comment", None)

if cfg_path.exists():
    bak = cfg_path.with_name(f"opencode.json.bak-aios-{int(time.time())}")
    bak.write_text(cfg_path.read_text())
    os.chmod(bak, 0o600)
    cfg = json.loads(cfg_path.read_text())
else:
    cfg = {"$schema": "https://opencode.ai/config.json"}

cfg["default_agent"] = defaults.get("default_agent", "agent")

# optional: only set model if defaults include it AND user has none
if "model" in defaults and not cfg.get("model"):
    cfg["model"] = defaults["model"]
if "small_model" in defaults and not cfg.get("small_model"):
    cfg["small_model"] = defaults["small_model"]

perm = cfg.setdefault("permission", {})
for k, v in (defaults.get("permission") or {}).items():
    if isinstance(v, dict) and isinstance(perm.get(k), dict):
        perm[k] = {**perm[k], **v}
    else:
        perm[k] = v

agent = cfg.setdefault("agent", {})
for legacy in ("alfred", "ops-local", "orquestrador"):
    agent.pop(legacy, None)
for name, body in (defaults.get("agent") or {}).items():
    agent[name] = {**agent.get(name, {}), **body}

cfg_path.parent.mkdir(parents=True, exist_ok=True)
cfg_path.write_text(json.dumps(cfg, indent=2, ensure_ascii=False) + "\n")
os.chmod(cfg_path, 0o600)
print(f"  default_agent={cfg.get('default_agent')}")
print(f"  wrote {cfg_path}")
PY

echo "=== Harness profile installed ==="
echo "  Restart OpenCode / new session to load agents."
