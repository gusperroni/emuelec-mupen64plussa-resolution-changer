# Mupen64Plus Standalone Resolution Updater

## Overview

This project contains scripts for Emuelec to update the resolution of Mupen64Plus Standalone based on the system settings or a configuration file. If neither source provides a valid resolution, a default fallback resolution of 1920x1080 is used

## Structure

- **bin**
  - `m64p.sh` - A modified launcher script for Mupen64Plus Standalone, based on the one provided on Emuelec v4.7. This script attempts to get the resolution from a config file located in the Mupen64Plus folder (see `m64p_resolution_changer.sh`). If the config file is absent or contains an invalid resolution, the script fetches the resolution from the system. If all attempts fail, it fallbacks to 1920x1080
- **scripts**
  - `m64p_resolution_changer.sh` - A script to create or clear the config file in the Mupen64Plus folder. It also provides a dialog menu with options for the user to select the desired resolution

## Usage

1. Download the latest release ZIP file from the [Releases](https://github.com/gusperroni/emuelec-mupen64plussa-resolution-changer/releases) page
2. Unpack the ZIP file into your Emuelec folder
   - The `bin` folder should merge with the existing `bin` folder
   - The `scripts` folder should merge with the existing `scripts` folder
3. At Emuelec, go to Scripts and open `m64p_resolution_changer.sh`, then choose the desired resolution and press `Start`
4. Launch a game using Mupen64Plus Standalone emulator

## Important

This tool is experimental, besidses not related to [Emuelec](https://github.com/EmuELEC/EmuELEC/) or [Mupen64Plus](https://mupen64plus.org/) projects, and not for commercial purposes, I made it to learn about Emuelec, shell scripts using dialog and managing project at Github.
