#!/usr/bin/env sh

get_themes()
{
    unset thmList
    unset thmWall

    while read thmDir ; do
        # NOTE: without -f in readlink will give relative which maybe relative to specific path, so with -f we take absolute path
        if [ ! -e "$(readlink -f "${thmDir}/wall.set")" ] ; then
            echo "fixing link :: ${thmDir}/wall.set"
            ln -fs "$(find "${thmDir}" -type f | head -1)" "${thmDir}/wall.set"
        fi
        thmList+=("$(basename "${thmDir}")")
        thmWall+=("$(readlink -f "${thmDir}/wall.set")")
    done < <(find "${confDir}/hypr_themes/" -mindepth 1 -maxdepth 1 -type d | sort)

    if [ "${1}" == "--verbose" ] ; then
        echo "// Theme Control //"
        for indx in "${!thmList[@]}" ; do
            echo -e ":: \${thmList[${indx}]}=\"${thmList[indx]}\" :: \${thmWall[${indx}]}=\"${thmWall[indx]}\""
        done
    fi
}

#// set variables

scrDir="$(dirname "$(realpath "$0")")"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="${HOME}/.cache/hypr_themes"
mkdir -p "${cacheDir}"
## source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"

# Get configuration
get_conf() {
    local varName="${1}"
    grep -oP "^${varName}=\"\K[^\"]*" "${confDir}/hypr_themes/theme.conf"
}
hyprTheme=$(get_conf "hyprTheme")

#// hypr vars

if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null; then
    export hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
    export hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"
fi
#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))


#// scale for monitor

mon_x_res=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
mon_scale=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .scale' | sed "s/\.//")
mon_x_res=$(( mon_x_res * 100 / mon_scale ))


#// generate config
themeSelect=2 # TODO: for now, adapt to style 2
case "${themeSelect}" in
2) # adapt to style 2
    elm_width=$(( (20 + 12) * rofiScale * 2 ))
    max_avail=$(( mon_x_res - (4 * rofiScale) ))
    col_count=$(( max_avail / elm_width ))
    r_override="window{width:100%;background-color:#00000003;} listview{columns:${col_count};} element{border-radius:${elem_border}px;background-color:@main-bg;} element-icon{size:20em;border-radius:${icon_border}px 0px 0px ${icon_border}px;}"
    thmbExtn="quad" ;;
*) # default to style 1
    elm_width=$(( (23 + 12 + 1) * rofiScale * 2 ))
    max_avail=$(( mon_x_res - (4 * rofiScale) ))
    col_count=$(( max_avail / elm_width ))
    r_override="window{width:100%;} listview{columns:${col_count};} element{border-radius:${elem_border}px;padding:0.5em;} element-icon{size:23em;border-radius:${icon_border}px;}"
    thmbExtn="sqre" ;;
esac


#// launch rofi menu

get_themes --verbose

rofiSel=$(for i in ${!thmList[@]} ; do
    current_wall="${thmWall[i]}"
    current_hash=$(echo -n "${current_wall}" | sha1sum | awk '{print $1}')
    cache_file="${cacheDir}/${current_hash}.${thmbExtn}"

    # Create thumbnail if not exists
    if [ ! -f "${cache_file}" ]; then
        if [ $thmbExtn == "sqre" ] ; then
            magick "${current_wall}[0]" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "${cache_file}"
        else
            magick "${current_wall}[0]" -resize 500x500^ -gravity center -extent 500x500 \
              \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" \
                 -draw "polygon 400,500 500,500 500,0 450,0" \
                 -fill black \
                 -draw "polygon 500,500 500,0 450,500" \
                 \) \
              -alpha off -compose CopyOpacity -composite "${cache_file}.png"
            mv "${cache_file}.png" "${cache_file}"
        fi
    fi

    echo -en "${thmList[i]}\x00icon\x1f${cache_file}\n"
done | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${hyprTheme}")


#// apply theme

if [ ! -z "${rofiSel}" ] ; then
    "${scrDir}/themeswitch.v2.sh" -s "${rofiSel}"
    notify-send -a "t1" -i "$HOME/.config/dunst/icons/hyprdots.png" " ${rofiSel}"
fi

