#!/usr/bin/env python3
import sys

for t in sys.stdin:
    hours = 0
    minutes = 0
    seconds = 0.0

    t = t.strip()
    if "h" in t:
        hours, t = t.split("h")
        hours = int(hours)
    if "m" in t:
        minutes, t = t.split("m")
        minutes = int(minutes)
    seconds = t.strip("s")
    seconds = float(seconds)

    print(f"{hours * 60 * 60 + minutes * 60 + seconds:3.2f}")
