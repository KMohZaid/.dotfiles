#!/bin/bash

browser=zen-browser
browser_ps_name="zen-bin"


if [ "$1" = "--no-new" ]; then
    pgrep $browser_ps_name || exec $browser
else
    exec $browser
fi
    

