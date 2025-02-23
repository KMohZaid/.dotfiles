cmd=$1

if [ -z "$cmd" ]; then
    echo "No command specified"
    exit 1
fi

pgrep_output=$(pgrep -fx -- "$cmd")

if [ -z "$pgrep_output" ]; then
    exec $cmd &> /tmp/ensure_run_once_$cmd.log &
else
    echo "Already running $cmd"
fi

