#!/usr/bin/env bash

DARK='{{colors.primary.default.hex | darken 15}}'
MID='{{colors.primary.default.hex}}'
LIGHT='{{colors.primary.default.hex | lighten 20}}'
COL_LABEL='{{colors.primary.default.hex}}'
COL_TITLE='{{colors.secondary.default.hex}}'
COL_DATA='{{colors.on_surface.default.hex}}'

hex_to_rgb() { local h=${1

read -r DR DG DB <<< "$(hex_to_rgb "$DARK")"
read -r MR MG MB <<< "$(hex_to_rgb "$MID")"
read -r LR LG LB <<< "$(hex_to_rgb "$LIGHT")"
read -r LAR LAG LAB <<< "$(hex_to_rgb "$COL_LABEL")"
read -r TIR TIG TIB <<< "$(hex_to_rgb "$COL_TITLE")"
read -r DAR DAG DAB <<< "$(hex_to_rgb "$COL_DATA")"

PAL2='{{colors.secondary.default.hex}}'
PAL3='{{colors.tertiary.default.hex}}'
PAL4='{{colors.error.default.hex}}'
PAL6='{{colors.surface_variant.default.hex}}'

read -r P2R P2G P2B <<< "$(hex_to_rgb "$PAL2")"
read -r P3R P3G P3B <<< "$(hex_to_rgb "$PAL3")"
read -r P4R P4G P4B <<< "$(hex_to_rgb "$PAL4")"
read -r P6R P6G P6B <<< "$(hex_to_rgb "$PAL6")"

IFS= read -r -d '' ART << 'GRID'
            
    +.  ++  
   ++++..   
GRID

LOGO="$HOME/.config/pfetch/logo.txt"

sgr() {
    local parts=""
    if [ -n "$1" ]; then parts="38;2;${1};${2};${3}"; else parts="39"; fi
    if [ -n "$4" ]; then parts="${parts};48;2;${4};${5};${6}"; else parts="${parts};49"; fi
    printf '\033[%sm' "$parts"
}

color_of() {
    case $1 in
        '#') echo "$DR $DG $DB" ;;
        '+') echo "$MR $MG $MB" ;;
        '.') echo "$LR $LG $LB" ;;
        *)   echo "" ;;
    esac
}

mapfile -t ROWS <<< "$ART"
NROWS=${
(( NROWS % 2 != 0 )) && { ROWS+=(""); NROWS=$((NROWS + 1)); }

MAXW=0
for row in "${ROWS[@]}"; do (( ${
for i in "${!ROWS[@]}"; do
    while (( ${
done

{
    for (( y=0; y<NROWS; y+=2 )); do
        line=""
        for (( x=0; x<MAXW; x++ )); do
            tc="${ROWS[$y]:$x:1}"; bc="${ROWS[$((y+1))]:$x:1}"
            read -r tr tg tb <<< "$(color_of "$tc")"
            read -r br bg bb <<< "$(color_of "$bc")"
            if [ -z "$tr" ] && [ -z "$br" ]; then line+=" "
            elif [ -z "$br" ]; then line+="$(sgr "$tr" "$tg" "$tb" "" "" "")▀"
            elif [ -z "$tr" ]; then line+="$(sgr "$br" "$bg" "$bb" "" "" "")▄"
            elif [ "$tr $tg $tb" = "$br $bg $bb" ]; then line+="$(sgr "$tr" "$tg" "$tb" "" "" "")█"
            else line+="$(sgr "$tr" "$tg" "$tb" "$br" "$bg" "$bb")▀"
            fi
        done
        printf '%s\033[m\n' "$(echo "$line" | sed 's/ *$//')"
    done
} > "$LOGO"

SOURCE="$HOME/.config/pfetch/source.sh"

cat > "$SOURCE" << 'SRCEOF'

_TC_LABEL=$(printf '\033[1;38;2;__LR__;__LG__;__LB__m')
_TC_TITLE=$(printf '\033[1;38;2;__TR__;__TG__;__TB__m')
_TC_DATA=$(printf '\033[38;2;__DR__;__DG__;__DB__m')
_TC_RESET=$(printf '\033[m')

get_os() {
    [ "$distro" ] && {
        log os "neko void" >&6
        return
    }
    while IFS='=' read -r key val; do
        case $key in PRETTY_NAME) distro=$val ;; esac
    done < /etc/os-release
    distro=${distro
    distro=${distro%%[\"\']}
}

get_title() {
    user=${USER:-$(id -un)}
    hostname=${HOSTNAME:-${hostname:-$(hostname)}}
    log "${_TC_TITLE}${user}${_TC_RESET}@${_TC_TITLE}${hostname}" " " >&6
}

log() {
    [ "$2" ] || return
    name=$1
    {
        set -f
        set +f -- $2
        info=$*
    }
    printf '\033[%sC' "${ascii_width--1}"
    printf '%s%s%s' "$_TC_LABEL" "$name" "$_TC_RESET"
    printf %s "$PF_SEP"
    printf '\033[%sD\033[%sC' "${#name}" "${PF_ALIGN-$info_length}"
    printf '%s%s%s\n' "$_TC_DATA" "$info" "$_TC_RESET"
    info_height=$((${info_height:-0} + 1))
}

get_ascii() {
    _logo=${PF_LOGO:-$HOME/.config/pfetch/logo.txt}
    PF_COL1=2
    PF_COL3=6
    ascii=""
    ascii_width=0
    ascii_height=0
    while IFS= read -r line || [ -n "$line" ]; do
        ascii_height=$((ascii_height + 1))
        _w=$(printf '%s' "$line" |
            LC_ALL=C sed -e 's/\x1b\[[0-9;]*m//g' \
                -e 's/▀/X/g; s/▄/X/g; s/█/X/g' |
            LC_ALL=C awk '{ print length($0) }')
        [ "${_w:-0}" -gt "$ascii_width" ] && ascii_width=$_w
        ascii="$ascii$line
"
    done < "$_logo"
    ascii_width=$((ascii_width + 4))
    printf '%s\033[m\033[%sA' "$ascii" "$ascii_height" >&6
}

get_cpu() {
    log cpu "$(lscpu | grep 'Model name:' | cut -d: -f2- | xargs)" >&6
}

get_font() {
    log font "$(grep -Ei '^font-family' ~/.config/ghostty/config | cut -d= -f2 | xargs)" >&6
}

get_icons() {
    log icons "$(grep -Ei '^gtk-icon-theme-name' ~/.config/gtk-3.0/settings.ini | cut -d= -f2 | xargs)" >&6
}

get_nix() {
    _hm=$(home-manager packages 2>/dev/null | wc -l)
    _pr=$(nix profile list --json 2>/dev/null | \
          python3 -c "import sys,json; d=json.load(sys.stdin); print(sum(1 for e in d.get('elements',{}).values() if 'home-manager' not in e.get('attrPath','')))" 2>/dev/null || echo 0)
    _total=$(( ${_hm:-0} + ${_pr:-0} ))
    [ "$_total" -gt 0 ] && log nix "${_total} (nix)" >&6
}

get_palette() {
    _p2=$(printf '\033[48;2;__P2R__;__P2G__;__P2B__m')
    _p3=$(printf '\033[48;2;__P3R__;__P3G__;__P3B__m')
    _p4=$(printf '\033[48;2;__P4R__;__P4G__;__P4B__m')
    _p6=$(printf '\033[48;2;__P6R__;__P6G__;__P6B__m')
    _r=$(printf '\033[m')
    palette="${_p2}  ${_p3}  ${_p4}  ${_p6}  ${_r}"
    printf '\n' >&6
    log "$palette
        " " " >&6
}
SRCEOF

sed -i \
    -e "s/__LR__/${LAR}/g" -e "s/__LG__/${LAG}/g" -e "s/__LB__/${LAB}/g" \
    -e "s/__TR__/${TIR}/g" -e "s/__TG__/${TIG}/g" -e "s/__TB__/${TIB}/g" \
    -e "s/__DR__/${DAR}/g" -e "s/__DG__/${DAG}/g" -e "s/__DB__/${DAB}/g" \
    -e "s/__P2R__/${P2R}/g" -e "s/__P2G__/${P2G}/g" -e "s/__P2B__/${P2B}/g" \
    -e "s/__P3R__/${P3R}/g" -e "s/__P3G__/${P3G}/g" -e "s/__P3B__/${P3B}/g" \
    -e "s/__P4R__/${P4R}/g" -e "s/__P4G__/${P4G}/g" -e "s/__P4B__/${P4B}/g" \
    -e "s/__P6R__/${P6R}/g" -e "s/__P6G__/${P6G}/g" -e "s/__P6B__/${P6B}/g" \
    "$SOURCE"

echo "pfetch: logo.txt + source.sh regenerados con colores del tema"
