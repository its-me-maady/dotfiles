#!/bin/bash

if pgrep -x wshowkeys >/dev/null; then
    pkill -x wshowkeys
else
    nohup wshowkeys >/dev/null 2>&1 &
fi

