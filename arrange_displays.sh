#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Arrangement
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.packageName Display Scripts

# Usage: ./arrange_displays.sh [layout]
# Layouts: up-and-down (default), side-by-side, external-left, laptop-only, external-only, toggle

# Ensure Homebrew binaries are on PATH (required when run from Raycast)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! command -v displayplacer &>/dev/null; then
  echo "displayplacer not found. Install with: brew install displayplacer"
  exit 1
fi

# --- Screen IDs ---
EXTERNAL="67CDF9A2-1A6E-4CAD-80D4-C46F201EECE3"   # 34" ultrawide 3440x1440
MACBOOK="37D8832A-2D66-02CA-B9F7-8F30A301B230"     # MacBook built-in 1512x982

# --- Default layout (change this to switch defaults) ---
LAYOUT="${1:-toggle}"

case "$LAYOUT" in

  up-and-down)
    # External ultrawide on top (main), MacBook below-center
    # [ 34" Ultrawide 3440x1440 ] (main)
    #         [ MacBook 1512x982 ]
    displayplacer \
      "id:$EXTERNAL res:3440x1440 hz:144 color_depth:8 enabled:true scaling:off origin:(0,0) degree:180" \
      "id:$MACBOOK  res:1512x982  hz:120 color_depth:8 enabled:true scaling:on  origin:(949,1440) degree:0"
    ;;

  side-by-side)
    # External on the right (main), MacBook on the left
    # [ MacBook ] [ 34" Ultrawide ]
    displayplacer \
      "id:$MACBOOK  res:1512x982  hz:120 color_depth:8 enabled:true scaling:on  origin:(-1512,360) degree:0" \
      "id:$EXTERNAL res:3440x1440 hz:144 color_depth:8 enabled:true scaling:off origin:(0,0) degree:180"
    ;;

  external-left)
    # External on the left (main), MacBook on the right
    # [ 34" Ultrawide ] [ MacBook ]
    displayplacer \
      "id:$EXTERNAL res:3440x1440 hz:144 color_depth:8 enabled:true scaling:off origin:(0,0) degree:180" \
      "id:$MACBOOK  res:1512x982  hz:120 color_depth:8 enabled:true scaling:on  origin:(3440,229) degree:0"
    ;;

  laptop-only)
    # Only MacBook screen active
    displayplacer \
      "id:$MACBOOK  res:1512x982  hz:120 color_depth:8 enabled:true scaling:on  origin:(0,0) degree:0" \
      "id:$EXTERNAL res:3440x1440 hz:144 color_depth:8 enabled:false scaling:off origin:(0,0) degree:180"
    ;;

  external-only)
    # Only external screen active (useful when lid is closed)
    displayplacer \
      "id:$EXTERNAL res:3440x1440 hz:144 color_depth:8 enabled:true scaling:off origin:(0,0) degree:180" \
      "id:$MACBOOK  res:1512x982  hz:120 color_depth:8 enabled:false scaling:on  origin:(0,0) degree:0"
    ;;

  toggle)
    MACBOOK_ORIGIN=$(displayplacer list 2>&1 | awk "/^Persistent screen id: $MACBOOK/{found=1} found && /^Origin:/{print \$2; exit}")
    if [[ "$MACBOOK_ORIGIN" == "(949,1440)" ]]; then
      LAYOUT="side-by-side"
    elif [[ "$MACBOOK_ORIGIN" == "(-1512,360)" ]]; then
      LAYOUT="up-and-down"
    else
      LAYOUT="side-by-side"
    fi
    echo "Detected current layout, toggling to: $LAYOUT"
    exec "$0" "$LAYOUT"
    ;;

  *)
    echo "Unknown layout: $LAYOUT"
    echo "Available layouts: up-and-down, side-by-side, external-left, laptop-only, external-only, toggle"
    exit 1
    ;;

esac

echo "Applied layout: $LAYOUT"
