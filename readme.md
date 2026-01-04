# ZX Spectrum Tilemap Scroller

A simple tilemap scroller for the ZX Spectrum, written in C using Z88DK.

## Controls

- O: Scroll left
- P: Scroll right
- Q: Scroll up
- A: Scroll down

## Building

1. Make sure you have Z88DK installed
2. Run `make` to build the project
3. Load the resulting .tap file in your ZX Spectrum emulator

## Requirements

- Z88DK (tested with v2.2)
- A ZX Spectrum emulator (e.g., Fuse, ZXSpin, or ZEsarUX)

## How to use it

Build default sample game:
`make`

Build using a different config:
`make CONFIG=config/basic_game.json`

Run in Fuse:
`make run CONFIG=config/basic_config.json`