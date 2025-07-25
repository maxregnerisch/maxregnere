#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# UN1CA configuration file
ROM_VERSION="3.0.0-g0s"
ROM_VERSION+="-$(git rev-parse --short HEAD)"
ROM_CODENAME="Quantum"

# Source ROM firmware
case "$TARGET_SINGLE_SYSTEM_IMAGE" in
    "g0s")
        # Galaxy S22 (One UI 6)
        SOURCE_CODENAME="s906b"
        SOURCE_FIRMWARE="SM-S906B/EUX/351273090276500"
        SOURCE_EXTRA_FIRMWARES=()
        SOURCE_API_LEVEL=34
        SOURCE_PRODUCT_FIRST_API_LEVEL=33
        SOURCE_VNDK_VERSION="33"
        SOURCE_HAS_SYSTEM_EXT=true
        SOURCE_SUPER_GROUP_NAME="group_mrrom"
        
        # MRROM Features
        QUANTUM_ENCRYPTION_ENABLED=true
        NEURAL_UI_ENABLED=true
        HW_ACCEL_S906B_ENABLED=true
        ZERO_LATENCY_IO_ENABLED=true
        ADAPTIVE_POWER_MGMT_ENABLED=true
        AI_VISION_ENHANCE_ENABLED=true
        
        # Device Specific Config
        SOURCE_AUTO_BRIGHTNESS_TYPE="4"
        SOURCE_DVFS_CONFIG_NAME="dvfs_policy_quantum"
        SOURCE_NFC_CHIP_VENDOR="NXP"
        SOURCE_FP_SENSOR_CONFIG="ultrasonic_in_display,settings=5,quantum_animation"
        SOURCE_HAS_MASS_CAMERA_APP=false
        SOURCE_HAS_QHD_DISPLAY=true
        SOURCE_HFR_MODE="3"
        SOURCE_HFR_SUPPORTED_REFRESH_RATE="48,60,120"
        SOURCE_HFR_DEFAULT_REFRESH_RATE="120"
        SOURCE_DISPLAY_CUTOUT_TYPE="punchhole"
        SOURCE_HFR_SEAMLESS_BRT="85,90"
        SOURCE_HFR_SEAMLESS_LUX="250,2400"
        SOURCE_IS_ESIM_SUPPORTED=false
        SOURCE_HAS_HW_MDNIE=true
        SOURCE_MDNIE_SUPPORTED_MODES="37906"
        SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION="1"
        SOURCE_SUPPORT_WIFI_6E=true
        SOURCE_SUPPORT_HOTSPOT_DUALAP=true
        SOURCE_SUPPORT_HOTSPOT_WPA3=true
        SOURCE_SUPPORT_HOTSPOT_6GHZ=false
        SOURCE_SUPPORT_HOTSPOT_WIFI_6=true
        SOURCE_SUPPORT_HOTSPOT_ENHANCED_OPEN=true
        SOURCE_AUDIO_SUPPORT_ACH_RINGTONE=true
        SOURCE_AUDIO_SUPPORT_VIRTUAL_VIBRATION=true

        # Neural UI Features
        DYNAMIC_ISLAND_ENABLED=true
        GLASSY_UI_ENABLED=true
        MAXREGNER_SOUNDSCHEME="Quantum-Resonance-v4"
        ENABLE_NEON_UI_ELEMENTS=true
        ENABLE_AOD_OVERLAY_WIDGETS=true
        ENABLE_HAPTIC_RESONANCE_MODE=true
        ENABLE_SEAMLESS_BOOT_UI_ANIMATIONS=true
        ENABLE_LIVE_ICON_ANIMATIONS=true
        ENABLE_NOTCH_DYNAMIC_INDICATORS=true
        ENABLE_TOUCH_WAVE_EFFECTS=true
        ENABLE_PARALLAX_UI_LAYERS=true
        ENABLE_CONTEXTUAL_UI_ADAPTATION=true
        ENABLE_UX_INTELLISENSE_FEATURE=true
        ENABLE_APP_OPEN_GLYPH_EFFECTS=true
        ENABLE_NOTIFICATION_SHIMMERING=true
        ENABLE_TRANSLUCENT_POWER_MENU=true
        ENABLE_DYNAMIC_AUDIO_ROUTING_UI=true
        ENABLE_SWIPEABLE_CARDS_UI=true
        ENABLE_NIGHTGLOW_UI_THEME=true
        ENABLE_REALTIME_UI_STATS_OVERLAY=true
        ENABLE_ADVANCED_AOD_SCHEDULER=true
        ENABLE_SYSTEM_UI_FADE_IN_ON_WAKE=true
        ENABLE_AUTO_THEME_BLEND_WALLPAPER=true
        ;;
    *)
        echo "\"$TARGET_SINGLE_SYSTEM_IMAGE\" is not a valid system image."
        return 1
        ;;
esac

return 0