#!/usr/bin/env bash
# Generate stars.css: three box-shadow star fields stored as CSS custom
# properties (--small-stars, --medium-stars, --big-stars).
#
# The field is WIDTH x HEIGHT px. HEIGHT must match the animStar keyframes
# (-2000px) and the .space::after offset (top: 2000px) in style.css, or the
# loop shows a gap. The fixed seed makes the output reproducible.
#
# Usage: scripts/stars.sh > stars.css
set -euo pipefail

WIDTH=4000 HEIGHT=2000 SEED=42 python3 - <<'EOF'
import os
import random

width = int(os.environ["WIDTH"])
height = int(os.environ["HEIGHT"])
random.seed(int(os.environ["SEED"]))

layers = (("small", 600), ("medium", 200), ("big", 100))

def shadows(n):
    return ",\n    ".join(
        f"{random.randint(1, width)}px {random.randint(1, height)}px var(--star)"
        for _ in range(n)
    )

counts = " / ".join(str(n) for _, n in layers)
print(f"/* Star fields, generated once ({counts} stars on {width}x{height}px) */")
print(":root {")
for name, n in layers:
    print(f"  --{name}-stars:\n    {shadows(n)};")
print("}")
EOF
