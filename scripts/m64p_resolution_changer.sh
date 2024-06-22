#!/bin/bash

# Mupen64Plus Resolution Changer v0.1 by https://github.com/gusperroni
# Mupen64Plus is distributed under GNU General Public License version 2 at https://mupen64plus.org/
# This tool is experimental and not for commercial purposes

# Source predefined functions and variables
. /etc/profile

CONFIGDIR="/emuelec/configs/mupen64plussa"
RESOLUTION_FILE="${CONFIGDIR}/resolution.cfg"

# Open console and enable usage of joypad as keyboard
ee_console enable
source /usr/bin/env.sh
joy2keyStart

# Ensure resolution.cfg exists and it's empty
if [[ ! -f "${RESOLUTION_FILE}" ]]; then
    mkdir -p "${CONFIGDIR}"
    touch "${RESOLUTION_FILE}"
else
    truncate -s 0 "${RESOLUTION_FILE}"
fi

# Run dialog and get user choice
exec 3>&1
RES=$(
    dialog                                                          \
    --title 'Mupen64Plus Resolution Changer'                        \
    --ascii-lines                                                   \
    --menu 'Choose the resolution for Mupen64Plus and press Start'  \
    0 0 0                                                           \
    1920x1080 '16:9'                                                \
    1600x900 '16:9'                                                 \
    1366x768 '16:9'                                                 \
    1280x720 '16:9'                                                 \
    960x540 '4:3'                                                   \
    640x480 '4:3'                                                   \
    640x360 '4:3'                                                   \
    320x240 '4:3'                                                   \
    Auto 'Use the system resolution'                                \
    2>&1 1>&3
)

# Update resolution config file
if [[ "$RES" == "Auto" ]]; then
    echo "0" > "${RESOLUTION_FILE}"
elif [[ -n "$RES" ]]; then
    echo "$RES" > "${RESOLUTION_FILE}"
else
    echo "0" > "${RESOLUTION_FILE}"
fi

# Close file descriptor
exec 3>&-

# Close console
ee_console disable