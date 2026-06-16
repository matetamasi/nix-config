#!/usr/bin/env bash

ACTION=$1
STEP=5

if [[ "$ACTION" == "up" ]]; then
    CMD="increment"
elif [[ "$ACTION" == "down" ]]; then
    CMD="decrement"
else
    echo "Usage: $0 [up|down]"
    exit 1
fi

MONITOR_ID=$(dms ipc brightness list | grep '^ddc:' | head -n 1 | sed 's/ .*//')

if [[ -n "$MONITOR_ID" ]]; then
    dms ipc brightness "$CMD" "$STEP" "$MONITOR_ID"
fi
