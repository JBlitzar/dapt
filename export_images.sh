#!/usr/bin/env bash
set -e
KC="kicad-cli"
command -v kicad-cli >/dev/null 2>&1 || KC="/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli"
ROOT="$(cd "$(dirname "$0")" && pwd)"
SCH_DIR="$ROOT/PCB/dapt"
PCB_DIR="$ROOT/PCB/exported_variants"
OUT="$ROOT/docs"
TMP="$(mktemp -d)"
sch=(A_female_A_female A_female_C_male A_male_A_male A_male_C_female C_female_C_female C_female_micro_male)
pcb=(a_fem_a_fem a_fem_c_male a_male_a_male a_male_c_fem c_fem_c_fem c_fem_micro_male)
for i in "${!sch[@]}"; do
  n="${pcb[$i]}"
  "$KC" sch export svg -o "$TMP" "$SCH_DIR/${sch[$i]}.kicad_sch"
  rsvg-convert -b white -w 1600 -o "$OUT/sch_${n}.png" "$TMP/${sch[$i]}.svg"
  "$KC" pcb export svg -o "$TMP/pcb_${n}.svg" --layers "F.Cu,F.Mask,F.SilkS,Edge.Cuts" --mode-single --fit-page-to-board --exclude-drawing-sheet "$PCB_DIR/${n}.kicad_pcb"
  rsvg-convert -b "#001124" -w 1600 -o "$OUT/pcb_${n}.png" "$TMP/pcb_${n}.svg"
done
rm -rf "$TMP"
