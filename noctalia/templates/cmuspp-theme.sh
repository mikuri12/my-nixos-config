#!/usr/bin/env bash
set -euo pipefail

THEMES_DIR="$HOME/themes"
OUT="$THEMES_DIR/noctalia.xml"

surface="{{colors.surface.default.rgb_csv}}"
surface_variant="{{colors.surface_variant.default.rgb_csv}}"
on_surface="{{colors.on_surface.default.rgb_csv | set_lightness 83}}"
on_surface_variant="{{colors.on_surface_variant.default.rgb_csv | set_lightness 83}}"
on_surface_dim="{{colors.on_surface.default.rgb_csv}}"
primary="{{colors.primary.default.rgb_csv}}"
error="{{colors.error.default.rgb_csv}}"

split() {
    local prefix="$1" csv="$2" r g b
    IFS=, read -r r g b <<<"$csv"
    printf -v "${prefix}_r" '%s' "$r"
    printf -v "${prefix}_g" '%s' "$g"
    printf -v "${prefix}_b" '%s' "$b"
}

split bg   "$surface"
split bgv  "$surface_variant"
split fg   "$on_surface"
split fgv  "$on_surface_variant"
split dim  "$on_surface_dim"
split acc  "$primary"
split warn "$error"

mkdir -p "$THEMES_DIR"

cat >"$OUT" <<XML
<?xml version="1.0" encoding="UTF-8"?>
<!-- Generado por Noctalia. No editar a mano: se sobrescribe al cambiar de paleta. -->
<theme name="Noctalia">
  <fg0  r="${fg_r}" g="${fg_g}" b="${fg_b}"/>
  <fg1  r="${fgv_r}" g="${fgv_g}" b="${fgv_b}"/>
  <fg2  r="${fg_r}" g="${fg_g}" b="${fg_b}"/>
  <fg3  r="${dim_r}" g="${dim_g}" b="${dim_b}"/>

  <acc  r="${acc_r}" g="${acc_g}" b="${acc_b}"/>
  <warn r="${warn_r}" g="${warn_g}" b="${warn_b}"/>

  <bghdr  bgr="${bgv_r}" bgg="${bgv_g}" bgb="${bgv_b}" fgr="${acc_r}" fgg="${acc_g}" fgb="${acc_b}"/>
  <bgsel  bgr="${bgv_r}" bgg="${bgv_g}" bgb="${bgv_b}" fgr="${fg_r}" fgg="${fg_g}" fgb="${fg_b}"/>
  <bgplay bgr="${bg_r}" bgg="${bg_g}" bgb="${bg_b}" fgr="${acc_r}" fgg="${acc_g}" fgb="${acc_b}"/>
  <bgstat bgr="${bg_r}" bgg="${bg_g}" bgb="${bg_b}" fgr="${fgv_r}" fgg="${fgv_g}" fgb="${fgv_b}"/>
</theme>
XML

python3 - "$THEMES_DIR" "$HOME/.last_theme" <<'PY' || true
import os, re, sys

themes, state = sys.argv[1], sys.argv[2]
if not os.path.isdir(themes):
    raise SystemExit(0)

# Temas compilados dentro del binario, en su orden de registro.
order = ["default", "catppuccin", "dracula", "nord", "gruvbox",
         "rosepine", "tokyonight", "everforest", "cream"]

for entry in os.listdir(themes):
    if not entry.endswith(".xml"):
        continue
    try:
        with open(os.path.join(themes, entry), encoding="utf8") as fh:
            found = re.search(r'<theme name="([^"]*)"', fh.read())
    except OSError:
        continue
    if found and found.group(1) not in order:
        order.append(found.group(1))

if "Noctalia" in order:
    with open(state, "w") as fh:
        fh.write("%d\n" % order.index("Noctalia"))
PY
