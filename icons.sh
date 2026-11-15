#!/usr/bin/env bash
set -euo pipefail

raw=https://raw.githubusercontent.com
set_dir=main/Resources/Assets.xcassets/AppIcon.appiconset
sources=(
  "amped $raw/gustaferiksson/amped/$set_dir/icon_256@2x.png"
  "crew $raw/gustaferiksson/crew/main/pages/icon-512.png"
  "berth $raw/gustaferiksson/berth/main/pages/icon-512.png"
  "spaces $raw/gustaferiksson/spaces/$set_dir/icon_256x256@2x.png"
  "rinse $raw/gustaferiksson/rinse/$set_dir/icon_256x256@2x.png"
  "tidy $raw/gustaferiksson/tidy/$set_dir/icon_256x256@2x.png"
  "tape $raw/gustaferiksson/tape/$set_dir/icon_256x256@2x.png"
  "tine $raw/tinecli/tine/main/icon/tine.svg"
)

magick=$(command -v magick || command -v convert)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p icons

for entry in "${sources[@]}"; do
  read -r name url <<<"$entry"
  if ! curl -fsSL "$url" -o "$tmp/$name.src"; then
    echo "::warning::Keeping the current $name icon, $url is unavailable"
    continue
  fi

  if [[ $url == *.svg ]]; then
    rsvg-convert -w 512 -h 512 "$tmp/$name.src" -o "$tmp/$name.png"
  else
    mv "$tmp/$name.src" "$tmp/$name.png"
  fi

  "$magick" "$tmp/$name.png" -trim +repage -resize '256x256!' -strip "icons/$name.png"
done
