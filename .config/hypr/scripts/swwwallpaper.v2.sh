#!/usr/bin/env sh

# Lock instance
lockFile="/tmp/hypr$(id -u)$(basename ${0}).lock"
[ -e "${lockFile}" ] && echo "An instance of the script is already running..." && exit 1
touch "${lockFile}"
trap 'rm -f ${lockFile}' EXIT

confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="${HOME}/.cache/hypr_themes"
thmbDir="${cacheDir}" # TODO: edit this across all v2 scripts, mainly themeselect.v2.sh where we display the thumbnails
# Define functions
get_hashmap()
{
    # Unset previous values
    unset wallHash wallList skipStrays verboseMap

    # Iterate over arguments
    for wallSource in "$@"; do
        [ -z "${wallSource}" ] && continue
        [ "${wallSource}" == "--skipstrays" ] && skipStrays=1 && continue
        [ "${wallSource}" == "--verbose" ] && verboseMap=1 && continue

        # Find and hash images
        hashMap=$(find "${wallSource}" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
                  -exec sha1sum {} + | sort -k2)
        if [ -z "${hashMap}" ]; then
            echo "WARNING: No images found in \"${wallSource}\""
            continue
        fi

        # Read hashes and file paths into arrays
        while read -r hash image; do
            wallHash+=("${hash}")
            wallList+=("${image}")
        done <<< "${hashMap}"
    done

    # Handle empty results
    if [ "${#wallList[@]}" -eq 0 ]; then
        if [ "${skipStrays}" -eq 1 ]; then
            return 1
        else
            echo "ERROR: No images found in any source"
            exit 1
        fi
    fi

    # Print hash map if verbose option is enabled
    if [ "${verboseMap}" -eq 1 ]; then
        echo "// Hash Map //"
        for indx in "${!wallHash[@]}"; do
            echo ":: \${wallHash[${indx}]}=\"${wallHash[indx]}\" :: \${wallList[${indx}]}=\"${wallList[indx]}\""
        done
    fi
}

get_hash_from_path(){
    sha1sum "$1" | awk '{print $1}'
}
Wall_Cache() {
    ln -fs "${wallList[setIndex]}" "${wallSet}"
    ln -fs "${wallList[setIndex]}" "${wallCur}"
    # TODO: update cache file script
    # "${scrDir}/swwwallcache.sh" -w "${wallList[setIndex]}" &> /dev/null
    # "${scrDir}/swwwallbash.sh" "${wallList[setIndex]}" &
    ln -fs "${thmbDir}/${wallHash[setIndex]}.sqre" "${wallSqr}"
    # TODO: below are not in existence yet because cache script make them
    # ln -fs "${thmbDir}/${wallHash[setIndex]}.thmb" "${wallTmb}"
    # ln -fs "${thmbDir}/${wallHash[setIndex]}.blur" "${wallBlr}"
    # ln -fs "${thmbDir}/${wallHash[setIndex]}.quad" "${wallQad}"
    # ln -fs "${dcolDir}/${wallHash[setIndex]}.dcol" "${wallDcl}"
}

Wall_Change() {
    curWallHash="$(get_hash_from_path "${wallSet}")"
    for i in "${!wallHash[@]}" ; do
        if [ "${curWallHash}" == "${wallHash[i]}" ] ; then
            if [ "${1}" == "n" ] ; then
                setIndex=$(( (i + 1) % ${#wallList[@]} ))
            elif [ "${1}" == "p" ] ; then
                setIndex=$(( i - 1 ))
            fi
            break
        fi
    done
    Wall_Cache
}

Set_To_Given_Wall_Symlink() {
    newWallPath="${1}"
    newWallHash=$(get_hash_from_path "${newWallPath}")
    for i in "${!wallHash[@]}" ; do
        if [ "${newWallHash}" == "${wallHash[i]}" ] ; then
            setIndex="${i}"
            break
        fi
    done
    Wall_Cache
}

# Get configuration
get_conf() {
    local varName="${1}"
    grep -oP "^${varName}=\"\K[^\"]*" "${confDir}/hypr_themes/theme.conf"
}

# Set configuration
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

# Set variables
scrDir="$(dirname "$(realpath "$0")")"
wallSet="${cacheDir}/wall.set"
wallCur="${cacheDir}/wall.set"
wallSqr="${cacheDir}/wall.sqre"
wallTmb="${cacheDir}/wall.thmb"
wallBlr="${cacheDir}/wall.blur"
wallQad="${cacheDir}/wall.quad"
wallDcl="${cacheDir}/wall.dcol"


# Initialize theme configuration
hyprTheme=$(get_conf "hyprTheme")
hyprCurrThemeWallDir="${confDir}/hypr_themes/${hyprTheme}/wallpapers"
wallPathArray=("$hyprCurrThemeWallDir")

# Initialize variables
setIndex=0
[ ! -e "$(readlink -f "${wallSet}")" ] && ln -fs "${wallList[setIndex]}" "${wallSet}"

# Evaluate options
while getopts "nps:" option ; do
    case $option in
    n ) # set next wallpaper
        xtrans="grow"
        get_hashmap "${wallPathArray[@]}" --verbose
        Wall_Change n
        ;;
    p ) # set previous wallpaper
        xtrans="outer"
        get_hashmap "${wallPathArray[@]}" --verbose
        Wall_Change p
        ;;
    s ) # set input wallpaper
        if [ -z "${OPTARG}" ] ; then
            echo "ERROR: empty value to -s option"
        elif [ ! -f "${OPTARG}" ] ; then
            echo "ERROR: file \"${OPTARG}\" does not exist"
        else
            newWallPath=$(readlink -f "${OPTARG}")
            newWallDir=$(dirname "${newWallPath}") # newWallPath is not wall.set, so we already  have /wallpapers dir in dirname
            get_hashmap "${newWallDir}" --verbose
            Set_To_Given_Wall_Symlink "${newWallPath}"
        fi
        ;;
    * ) # invalid option
        echo "... invalid option ..."
        echo "$(basename "${0}") -[option]"
        echo "n : set next wall"
        echo "p : set previous wall"
        echo "s : set input wallpaper"
        exit 1 ;;
    esac
done

# Check swww daemon
swww query &> /dev/null
if [ $? -ne 0 ] ; then
    swww-daemon --format xrgb &
    swww query && swww restore
fi

# Set defaults
[ -z "${xtrans}" ] && xtrans="grow"
[ -z "${wallFramerate}" ] && wallFramerate=60
[ -z "${wallTransDuration}" ] && wallTransDuration=0.4

# Apply wallpaper
echo ":: applying wall :: \"$(readlink -f "${wallSet}")\""
swww img "$(readlink "${wallSet}")" --transition-bezier .43,1.19,1,.4 --transition-type "${xtrans}" --transition-duration "${wallTransDuration}" --transition-fps "${wallFramerate}" --invert-y --transition-pos "$(hyprctl cursorpos | grep -E '^[0-9]' || echo "0,0")" &

