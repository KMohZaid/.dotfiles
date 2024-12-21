#!/bin/bash

browser=floorp
browser_ps_name="floorp"


if [ "$1" = "--no-new" ]; then
    pgrep $browser_ps_name || exec $browser
else
    exec $browser
fi
    

