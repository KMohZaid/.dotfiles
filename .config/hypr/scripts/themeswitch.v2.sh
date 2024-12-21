#!/usr/bin/env sh
# Set variables
scrDir="$(dirname "$(realpath "$0")")"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="${HOME}/.cache/hypr_themes"

# Function to set a configuration value in theme.conf
set_conf() {
    local varName="${1}"
    local varData="${2}"
    touch "${confDir}/hypr_themes/theme.conf"

    if [ $(grep -c "^${varName}=" "${confDir}/hypr_themes/theme.conf") -eq 1 ]; then
        sed -i "/^${varName}=/c${varName}=\"${varData}\"" "${confDir}/hypr_themes/theme.conf"
    else
        echo "${varName}=\"${varData}\"" >> "${confDir}/hypr_themes/theme.conf"
    fi
}

# Function to get the value of a configuration from theme.conf
get_conf() {
    local varName="${1}"
    grep -oP "^${varName}=\"\K[^\"]*" "${confDir}/hypr_themes/theme.conf"
}

# Get the current theme name using get_conf
hyprTheme=$(get_conf "hyprTheme")

# Get the theme directory based on the current theme name
hyprThemeDir="${confDir}/hypr_themes/${hyprTheme}"

# Ensure theme directory exists
if [ ! -d "${hyprThemeDir}" ]; then
    echo "ERROR: unable to detect theme directory for '${hyprTheme}'"
    exit 1
fi

# Get themes
get_themes() {
    unset thmList
    while read -r themeDir; do
        thmList+=("$(basename "${themeDir}")")
    done < <(find "${confDir}/hypr_themes/" -mindepth 1 -maxdepth 1 -type d | sort)
}
get_themes

# Define functions
Theme_Change() {
    local x_switch=$1
    for i in "${!thmList[@]}"; do
        if [ "${thmList[i]}" == "${hyprTheme}" ]; then
            if [ "${x_switch}" == 'n' ]; then
                setIndex=$(( (i + 1) % ${#thmList[@]} ))
            elif [ "${x_switch}" == 'p' ]; then
                setIndex=$(( i - 1 ))
            fi
            themeSet="${thmList[setIndex]}"
            break
        fi
    done
}

# Evaluate options
while getopts "nps:" option; do
    case $option in
    n) # Set next theme
        Theme_Change n
        export xtrans="grow"
        ;;
    p) # Set previous theme
        Theme_Change p
        export xtrans="outer"
        ;;
    s) # Set selected theme
        themeSet="$OPTARG"
        ;;
    *) # Invalid option
        echo "... invalid option ..."
        echo "$(basename "${0}") -[option]"
        echo "n : set next theme"
        echo "p : set previous theme"
        echo "s : set input theme"
        exit 1
        ;;
    esac
done

# Validate and update theme
if ! printf "%s\n" "${thmList[@]}" | grep -q -w "${themeSet}"; then
    themeSet="${hyprTheme}"
fi

set_conf "hyprTheme" "${themeSet}"
hyprNewThemeDir="${confDir}/hypr_themes/${themeSet}"
echo ":: applying theme :: \"${themeSet}\""
export reload_flag=1

# Apply changes for Hyprland
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    hyprctl keyword misc:disable_autoreload 1 -q
fi

# INFO:
################## Apply Theme File ##################
#

# Hyprland
sed '1d' "${hyprNewThemeDir}/hypr.theme" >"${confDir}/hypr/themes/theme.conf"
# Waybar
sed '1d' "${hyprNewThemeDir}/waybar.theme" >"${confDir}/waybar/theme.css"

gtkTheme="$(
    grep -oP '^\s*\$GTK[-_]THEME\s*=\s*\K.*' "${hyprNewThemeDir}/hypr.theme" ||
        grep -oP "gsettings set org.gnome.desktop.interface gtk-theme \K'[^']*'" "${hyprNewThemeDir}/hypr.theme"
)"
gtkIcon="$(
    grep -oP '^\s*\$ICON[-_]THEME\s*=\s*\K.*' "${hyprNewThemeDir}/hypr.theme" ||
        grep -oP "gsettings set org.gnome.desktop.interface icon-theme \K'[^']*'" "${hyprNewThemeDir}/hypr.theme"
)"

# Apply GTK, QT, and Flatpak configurations
sed -i "/^icon_theme=/c\icon_theme=${gtkIcon}" "${confDir}/qt5ct/qt5ct.conf"
sed -i "/^icon_theme=/c\icon_theme=${gtkIcon}" "${confDir}/qt6ct/qt6ct.conf"
sed -i "/^Theme=/c\Theme=${gtkIcon}" "${confDir}/kdeglobals"

sed -i "/^gtk-theme-name=/c\gtk-theme-name=${gtkTheme}" "${confDir}/gtk-3.0/settings.ini"
sed -i "/^gtk-icon-theme-name=/c\gtk-icon-theme-name=${gtkIcon}" "${confDir}/gtk-3.0/settings.ini"

themeDir="${HOME}/.themes"
rm -rf "${confDir}/gtk-4.0"
ln -s "${themeDir}/${gtkTheme}/gtk-4.0" "${confDir}/gtk-4.0"

if command -v flatpak >/dev/null 2>&1; then
    flatpak --user override --env=GTK_THEME="${gtkTheme}"
    flatpak --user override --env=ICON_THEME="${gtkIcon}"
fi

# INFO:
################## POST-APPLY ##################
#
echo ":: post-apply :: wallpaper and waybar"

# Set wallpaper
"${scrDir}/swwwallpaper.v2.sh" -s "$(readlink -f "${hyprNewThemeDir}/wall.set")"

# restart waybar
pkill waybar
waybar &>/dev/null &

