cmd=$1

if [ -z "$cmd" ]; then
    echo "No command specified"
    exit 1
fi

pgrep_output=$(pgrep -fx -- "$cmd")

if [ -z "$pgrep_output" ]; then
    if [ "zen" != "$cmd" ]; then
        exec $cmd &> /dev/null &
    else
        exec flatpak run app.zen_browser.zen &> /dev/null &
    fi
else
    echo "Already running $cmd"
fi

