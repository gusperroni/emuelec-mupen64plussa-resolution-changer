#!/bin/bash

# Source predefined functions and variables
. /etc/profile

CONFIGDIR="/emuelec/configs/mupen64plussa"

if [[ ! -f "${CONFIGDIR}/InputAutoCfg.ini" ]]; then
	mkdir -p ${CONFIGDIR}
	cp /usr/local/share/mupen64plus/InputAutoCfg.ini ${CONFIGDIR}/
fi

if [[ ! -f "${CONFIGDIR}/mupen64plus.cfg" ]]; then
	mkdir -p ${CONFIGDIR}
	cp /usr/local/share/mupen64plus/mupen64plus.cfg ${CONFIGDIR}/
fi

FILE="${1}"
if [[ "${FILE: -4}" == ".zip" ]]; then
	mkdir -p /tmp/mupen64plus
	rm -fr /tmp/mupen64plus/*.*
	unzip "${1}" -d "/tmp/mupen64plus"
	FILE=$( ls /tmp/mupen64plus/*.*64* )	
fi

AUTOGP=$(get_ee_setting mupen64plus_auto_gamepad)
if [[ "${AUTOGP}" != "0" ]]; then
  set_mupen64_joy.sh
fi

# Use framebuffer driver to get current resolution
get_resolution_from_system() {
  if [[ -f /sys/class/graphics/fb0/modes ]]; then
    RES=$(head -n 1 /sys/class/graphics/fb0/modes | grep -oP '\d+x\d+')
    echo $RES
  else
    echo ""
  fi
}

# Use a resolution file in configdir to get resolution
get_user_resolution() {
  if [[ -f "${CONFIGDIR}/resolution.cfg" ]]; then
    USER_RES=$(grep -oP '\d+x\d+' "${CONFIGDIR}/resolution.cfg")
    echo $USER_RES
  else
    echo ""
  fi
}

case "$(oga_ver)" in
  "OGA"*)
    RES_W="480"
    RES_H="320"
  ;;
  "OGS")
    RES_W="854"
    RES_H="480"
  ;;
  "GF")
    RES_W="640"
    RES_H="480"
  ;;
  *)
    USER_RES=$(get_user_resolution)
    if [[ -n "$USER_RES" ]]; then
      IFS='x' read -r RES_W RES_H <<< "$USER_RES"
    else
      RES=$(get_resolution_from_system)
      if [[ -z "$RES" ]]; then
        RES_W="1920"
        RES_H="1080"
      else
        IFS='x' read -r RES_W RES_H <<< "$RES"
      fi
    fi
  ;;
esac

echo "RESOLUTION=${RES_W} ${RES_H}"

sed -i "s/ScreenWidth.*/ScreenWidth = ${RES_W}/g" "${CONFIGDIR}/mupen64plus.cfg"
sed -i "s/ScreenHeight.*/ScreenHeight = ${RES_H}/g" "${CONFIGDIR}/mupen64plus.cfg"

case ${2} in
	"m64p_gl64mk2")
		mupen64plus --configdir ${CONFIGDIR} --gfx mupen64plus-video-glide64mk2 "${FILE}"
	;;
	*)
		mupen64plus --configdir ${CONFIGDIR} --gfx mupen64plus-video-rice "${FILE}"
	;;
esac

rm -fr /tmp/mupen64plus/*.*