#
# Copyright (C) 2018 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_PACKAGES += \
    vndk_package

PRODUCT_ACTIONABLE_COMPATIBLE_PROPERTY_DISABLE := true

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_SOONG_NAMESPACES += \
    device/google/wahoo \
    vendor/google/camera \
    hardware/google/camera \
    hardware/google/pixel \
    hardware/google/interfaces

PRODUCT_COPY_FILES += \
    device/google/wahoo/default-permissions.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default-permissions/default-permissions.xml \
    device/google/wahoo/component-overrides.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sysconfig/component-overrides.xml \
    frameworks/native/data/etc/aosp_excluded_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/aosp_excluded_hardware.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

# Set the SVN for the targeted MR release
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.svn=52

# Enforce privapp-permissions whitelist
PRODUCT_PROPERTY_OVERRIDES += \
    ro.control_privapp_permissions=disabled

PRODUCT_PACKAGES += \
    messaging

ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PACKAGES += chre_test_client
endif

LOCAL_PATH := device/google/wahoo

SRC_MEDIA_HAL_DIR := hardware/qcom/media/msm8998
SRC_DISPLAY_HAL_DIR := hardware/qcom/display/msm8998
SRC_CAMERA_HAL_DIR := hardware/qcom/camera/msm8998

TARGET_SYSTEM_PROP := $(TARGET_SYSTEM_PROP) $(LOCAL_PATH)/system.prop

# Get kernel-headers
PRODUCT_VENDOR_KERNEL_HEADERS := device/google/wahoo/kernel-headers

$(call inherit-product, device/google/wahoo/utils.mk)

PRODUCT_CHARACTERISTICS := nosdcard
PRODUCT_SHIPPING_API_LEVEL := 26

PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.recovery.hardware.rc:recovery/root/init.recovery.$(PRODUCT_HARDWARE).rc \
    $(LOCAL_PATH)/rootdir/etc/init.hardware.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.wahoo.usb.rc \
    $(LOCAL_PATH)/rootdir/etc/ueventd.hardware.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    $(LOCAL_PATH)/rootdir/bin/init.elabel.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/init.elabel.sh \
    $(LOCAL_PATH)/rootdir/bin/init.power.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.power.sh \
    $(LOCAL_PATH)/rootdir/bin/init.radio.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.radio.sh \
    $(LOCAL_PATH)/rootdir/bin/init.qcom.devstart.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.devstart.sh \
    $(LOCAL_PATH)/rootdir/bin/init.qcom.ipastart.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.ipastart.sh \
    $(LOCAL_PATH)/rootdir/bin/init.insmod.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.insmod.sh \
    $(LOCAL_PATH)/rootdir/bin/init.ramoops.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.ramoops.sh \
    frameworks/native/services/vr/virtual_touchpad/idc/vr-virtual-touchpad-0.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/vr-virtual-touchpad-0.idc \
    frameworks/native/services/vr/virtual_touchpad/idc/vr-virtual-touchpad-1.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/vr-virtual-touchpad-1.idc

ifeq (,$(filter %_xr,$(TARGET_PRODUCT)))
  PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.hardware.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_HARDWARE).rc
else
  # XR variants for Pixel devices (e.g. walleye_xr and taimen_xr). Note that
  # this is a nonintrusive way to add XR-specific init.rc entries, as the
  # init.hardware.xr.rc file imports the original init.hardware.rc file.
  PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.hardware.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_HARDWARE).common.rc \
    $(LOCAL_PATH)/rootdir/etc/init.hardware.xr.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_HARDWARE).rc
endif

ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
  PRODUCT_COPY_FILES += \
      $(LOCAL_PATH)/rootdir/etc/init.hardware.diag.rc.userdebug:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(PRODUCT_HARDWARE).diag.rc
  PRODUCT_COPY_FILES += \
      $(LOCAL_PATH)/rootdir/etc/init.hardware.chamber.rc.userdebug:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(PRODUCT_HARDWARE).chamber.rc
else
  PRODUCT_COPY_FILES += \
      $(LOCAL_PATH)/rootdir/etc/init.hardware.diag.rc.user:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(PRODUCT_HARDWARE).diag.rc
endif

MSM_VIDC_TARGET_LIST := msm8998 # Get the color format from kernel headers
MASTER_SIDE_CP_TARGET_LIST := msm8998 # ION specific settings

# A/B support
PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier

PRODUCT_PACKAGES += \
    bootctrl.msm8998 \
    bootctrl.msm8998.recovery

PRODUCT_PROPERTY_OVERRIDES += \
    ro.cp_system_other_odex=1

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    update_engine_sideload

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    a_sns_test \
    bootctl \
    update_engine_client

# Write flags to the vendor space in /misc partition.
PRODUCT_PACKAGES += \
    misc_writer

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml\
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml\
    frameworks/native/data/etc/android.hardware.camera.ar.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.ar.xml\
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.assist.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.assist.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.context_hub.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.context_hub.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/android.hardware.vr.headtracking-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vr.headtracking.xml \
    frameworks/native/data/etc/android.hardware.vr.high_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vr.high_performance.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/android.hardware.telephony.carrierlock.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.carrierlock.xml \

# power.stats HAL
PRODUCT_PACKAGES += \
    android.hardware.power.stats@1.0-service.pixel

# Remove unwanted packages
PRODUCT_PACKAGES += \
    RemovePackages

# health HAL
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.wahoo

# Audio fluence, ns, aec property, voice and media volume steps
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qc.sdk.audio.fluencetype=fluencepro \
    persist.audio.fluence.voicecall=true \
    persist.audio.fluence.speaker=true \
    persist.audio.fluence.voicecomm=true \
    persist.audio.fluence.voicerec=false \
    ro.config.vc_call_vol_steps=7 \
    ro.config.media_vol_steps=25

# graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610

# b/73640835
PRODUCT_PROPERTY_OVERRIDES += \
    sdm.debug.rotator_downscale=1

# Disable buffer age (b/74534157)
PRODUCT_PROPERTY_OVERRIDES += \
    debug.hwui.use_buffer_age=false

# Enable camera EIS3.0
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.is_type=5 \
    persist.camera.gzoom.at=0 \
    persist.camera.llv.fuse=2

# Enable camera ae saturation stats
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.saturationext=1

# OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.feature=1 \
    persist.data.iwlan.enable=true \
    persist.radio.RATE_ADAPT_ENABLE=1 \
    persist.radio.ROTATION_ENABLE=1 \
    persist.radio.VT_ENABLE=1 \
    persist.radio.VT_HYBRID_ENABLE=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.custom_ecc=1 \
    persist.radio.data_ltd_sys_ind=1 \
    persist.radio.is_wps_enabled=true \
    persist.radio.videopause.mode=1 \
    persist.radio.sap_silent_pin=1 \
    persist.radio.sib16_support=1 \
    persist.radio.data_con_rprt=true \
    persist.vendor.radio.mt_sms_ack=30 \
    persist.radio.always_send_plmn=false\
    persist.rcs.supported=1

# Radio Hal
PRODUCT_PACKAGES += \
    android.hardware.radio@1.1.vendor \
    android.hardware.radio.config@1.0 \
    librmnetctl \
    libxml2

ifeq (,$(_vndk_test))
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.rild.libpath=/vendor/lib64/libril-qc-qmi-1.so
else
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so
endif

# Disable snapshot timer
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.snapshot_enabled=0 \
    persist.radio.snapshot_timer=0

# By default, enable zram; experiment can toggle the flag,
# which takes effect on boot
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.zram_enabled=1

PRODUCT_PROPERTY_OVERRIDES += \
  ro.vendor.extension_library=libqti-perfd-client.so

# settings to enable Device Orientation Sensors
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qti.sensors.dev_ori=true

# settings to disable unused secondary wakeup
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qti.sensors.wu=false

# settings to disable unused algorithms
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qti.sdk.sensors.gestures=false \
    ro.qti.sensors.amd=false \
    ro.qti.sensors.cmc=false \
    ro.qti.sensors.facing=false \
    ro.qti.sensors.pedometer=false \
    ro.qti.sensors.rmd=false \
    ro.qti.sensors.scrn_ortn=false

# use SMGR supplied version of step detector and counter
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qti.sensors.step_counter=false \
    ro.qti.sensors.step_detector=false

# camera gyro and laser sensor
PRODUCT_PROPERTY_OVERRIDES += \
  persist.camera.gyro.android=20 \
  persist.camera.tof.direct=1 \
  persist.camera.max.previewfps=60 \
  persist.camera.sensor.hdr=2

# camera TNR controls
PRODUCT_PROPERTY_OVERRIDES += \
  persist.camera.tnr.video=1 \

# WLAN driver configuration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi_concurrency_cfg.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wifi_concurrency_cfg.txt

#ipacm configuration files
PRODUCT_COPY_FILES += \
    hardware/qcom/data/ipacfg-mgr/msm8998/ipacm/src/IPACM_cfg.xml:$(TARGET_COPY_OUT_VENDOR)/etc/IPACM_cfg.xml

PRODUCT_PACKAGES += \
    hwcomposer.msm8998 \
    android.hardware.graphics.composer@2.1-impl:64 \
    android.hardware.graphics.composer@2.1-service \
    gralloc.msm8998 \
    android.hardware.graphics.allocator@2.0-impl:64 \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    libbt-vendor

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# Light HAL
PRODUCT_PACKAGES += \
    lights.wahoo \
    android.hardware.light@2.0-impl:64 \
    android.hardware.light@2.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.lights=wahoo

# eSE applet HALs
PRODUCT_PACKAGES += \
    esed

# Memtrack HAL
PRODUCT_PACKAGES += \
    memtrack.msm8998 \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth.a2dp@1.0.vendor \
    android.hardware.bluetooth@1.0-impl-qti:64 \
    android.hardware.bluetooth@1.0-service-qti \
    android.hardware.bluetooth@1.0-service-qti.rc

PRODUCT_PACKAGES += \
    libldacBT_bco

# Bluetooth SoC
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.qcom.bluetooth.soc=cherokee

# Property for loading BDA from bdaddress module in kernel
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.bt.bdaddr_path=/sys/module/bdaddress/parameters/bdaddress

# Bluetooth WiPower
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.bluetooth.emb_wp_mode=false \
    ro.vendor.bluetooth.wipower=false

# Charger
PRODUCT_PRODUCT_PROPERTIES += \
    ro.charger.enable_suspend=true

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.2 \
    android.hardware.drm@1.2.vendor \
    android.hardware.drm@1.3 \
    android.hardware.drm@1.3.vendor \
    android.hardware.drm@1.4 \
    android.hardware.drm@1.4.vendor \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.1.vendor \
    android.hardware.drm@1.4-service.clearkey

# IMS
PRODUCT_PACKAGES += \
    com.android.ims.rcsmanager \
    PresencePolling \
    RcsService

# EUICC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml

# NFC packages
PRODUCT_PACKAGES += \
    NfcNci \
    Tag \
    android.hardware.nfc@1.1-service \

PRODUCT_PACKAGES += \
    SecureElement

PRODUCT_COPY_FILES += \
    device/google/wahoo/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf \

PRODUCT_PACKAGES += \
    android.hardware.usb@1.1-service.wahoo

PRODUCT_PACKAGES += \
    libmm-omxcore \
    libOmxCore \
    libstagefrighthw \
    libOmxVdec \
    libOmxVdecHevc \
    libOmxVenc \
    libc2dcolorconvert

PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl:32 \
    android.hardware.camera.provider@2.4-service \
    camera.device@3.2-impl \
    camera.msm8998 \
    libqomx_core \
    libmmjpeg_interface \
    libmmcamera_interface

# Google Camera HAL test libraries in debug builds
PRODUCT_PACKAGES_DEBUG += \
    libgoogle_camera_hal_proprietary_tests \
    libgoogle_camera_hal_tests.vendor

PRODUCT_PACKAGES += \
    sensors.$(PRODUCT_HARDWARE) \
    android.hardware.sensors@1.0-impl:64 \
    android.hardware.sensors@1.0-service \
    android.frameworks.sensorservice@1.0.vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sensors/hals.conf:vendor/etc/sensors/hals.conf

# Default permission grant exceptions
PRODUCT_COPY_FILES += \
    device/google/wahoo/default-permissions.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default-permissions/default-permissions.xml

PRODUCT_PACKAGES += \
    fs_config_dirs \
    fs_config_files

# Context hub HAL
PRODUCT_PACKAGES += \
    android.hardware.contexthub@1.0-impl.generic:64 \
    android.hardware.contexthub@1.0-service

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl:64 \
    android.hardware.boot@1.0-impl.recovery:64 \
    android.hardware.boot@1.0-service \

#GNSS HAL
PRODUCT_PACKAGES += \
    gps.conf \
    libgps.utils \
    libgnss \
    liblocation_api \
    android.hardware.gnss@1.0-impl-qti \
    android.hardware.gnss@1.0-service-qti

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config


HOSTAPD := hostapd
HOSTAPD += hostapd_cli
PRODUCT_PACKAGES += $(HOSTAPD)

WPA := wpa_supplicant.conf
WPA += wpa_supplicant_wcn.conf
WPA += wpa_supplicant
PRODUCT_PACKAGES += $(WPA)

ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PACKAGES += wpa_cli
endif

# Network
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks@1.3.vendor \
    android.system.net.netd@1.1.vendor

# Wifi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wificond \
    libwpa_client \
    WifiOverlay

LIB_NL := libnl_2
PRODUCT_PACKAGES += $(LIB_NL)

# Audio effects
PRODUCT_PACKAGES += \
    libvolumelistener \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcomvoiceprocessingdescriptors \
    libqcompostprocbundle

PRODUCT_PACKAGES += \
    audio.primary.msm8998 \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    libaudio-resampler \
    audio.hearing_aid.default \
    audio.bluetooth.default

PRODUCT_PACKAGES += \
    android.hardware.audio@7.0-impl:32 \
    android.hardware.audio.effect@7.0-impl:32 \
    android.hardware.soundtrigger@2.2-impl:32 \
    android.hardware.bluetooth.audio@2.0-impl \
    android.hardware.audio@2.0-service

# stereo speakers: orientation changes swap L/R channels
PRODUCT_PROPERTY_OVERRIDES += \
    ro.audio.monitorRotation=true

# Bug 62375603
# PRODUCT_PROPERTY_OVERRIDES += audio.adm.buffering.ms=4

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Audio low latency feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml

# Pro audio feature
# PRODUCT_COPY_FILES += \
#   frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml

ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PACKAGES += \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo \
    cplay
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration_bluetooth_legacy_hal.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_bluetooth_legacy_hal.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/hearing_aid_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/hearing_aid_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# audio hal tables
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_mixer_paths_wcd9340.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths_wcd9340.xml \
    $(LOCAL_PATH)/configs/audio/graphite_ipc_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/graphite_ipc_platform_info.xml \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    $(LOCAL_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \

# Codec2 modules
PRODUCT_PACKAGES += \
    com.android.media.swcodec \
    libsfplugin_ccodec \

# Codec2 switch
PRODUCT_PROPERTY_OVERRIDES += \
    debug.media.codec2=2 \

PRODUCT_PROPERTY_OVERRIDES += \
    audio.snd_card.open.retries=50

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/lowi.conf:$(TARGET_COPY_OUT_VENDOR)/etc/lowi.conf

# Fingerprint HIDL implementation
PRODUCT_PACKAGES += \
    android.frameworks.stats@1.0.vendor \
    android.hardware.biometrics.fingerprint@2.1.vendor \
    android.hardware.biometrics.fingerprint@2.2.vendor \
    android.hardware.biometrics.fingerprint@2.1-service.fpc
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/bin/init.fingerprint.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.fingerprint.sh \

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.safe_union@1.0.vendor

# GPS configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp_policy/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
# Subsystem ramdump
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.ssr.enable_ramdumps=1
endif

# Subsystem silent restart
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.ssr.restart_level=modem,slpi,adsp

# setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

PRODUCT_COPY_FILES += \
    device/google/wahoo/rootdir/etc/fstab.hardware:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(PRODUCT_HARDWARE)

# Use the default charger mode images
PRODUCT_PACKAGES += \
    charger_res_images

ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
# b/36703476: Set default log size to 1M
PRODUCT_PROPERTY_OVERRIDES += \
  ro.logd.size=1M
# b/114766334: persist all logs by default rotating on 30 files of 1MiB
PRODUCT_PROPERTY_OVERRIDES += \
  logd.logpersistd=logcatd \
  logd.logpersistd.size=30
endif

# Dumpstate HAL
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.wahoo

# Use daemon to detect folio open/close
PRODUCT_PACKAGES += \
    folio_daemon

# Storage: for factory reset protection feature
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/platform/soc/1da4000.ufshc/by-name/frp

# Include vndk/vndk-sp/ll-ndk modules
PRODUCT_PACKAGES += vndk_package

PRODUCT_ENFORCE_RRO_TARGETS := framework-res
PRODUCT_ENFORCE_RRO_TARGETS := *

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m

# Privileged permissions whitelist
PRODUCT_COPY_FILES += \
    device/google/wahoo/permissions/privapp-permissions-aosp_wahoo.xml:system/etc/permissions/privapp-permissions-aosp_wahoo.xml

PRODUCT_PACKAGES += \
    ipacm

#Set default CDMA subscription to RUIM
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_cdma_sub=0

# Set network mode to Global by default and no DSDS/DSDA
PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=10

# Add an extra 10% saturation to display colors
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.sf.color_saturation=1.1

# Easel device feature
PRODUCT_COPY_FILES += \
    device/google/wahoo/permissions/com.google.hardware.camera.easel.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.google.hardware.camera.easel.xml

# QC time-daemon to use persist
PRODUCT_PROPERTY_OVERRIDES += \
    persist.delta_time.enable=true

# Do not drop packets based upon enqueue sequence
# to avoid freeze
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.ims.dropset_feature=0

# Enable CameraHAL perfd usage
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.perfd.enable=false

# Enable Gcam FD Ensemble
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.gcam.fd.ensemble=1

# Preopt SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

# audio effects config
PRODUCT_PROPERTY_OVERRIDES += \
    fmas.hdph_sgain=0

# NFC/camera interaction workaround - DO NOT COPY TO NEW DEVICES
PRODUCT_PROPERTY_OVERRIDES += \
    ro.camera.notify_nfc=1

# default usb oem functions
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
  PRODUCT_PROPERTY_OVERRIDES += \
      persist.vendor.usb.usbradio.config=diag
endif

# Vibrator HAL
PRODUCT_PROPERTY_OVERRIDES += \
  ro.vibrator.hal.closeloop.threshold=20

# default atrace HAL
PRODUCT_PACKAGES += \
    android.hardware.atrace@1.0-service

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_color_management=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.protected_contents=true

# Use /product/etc/fstab.postinstall to mount system_other.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.postinstall.fstab.prefix=/product

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.postinstall:$(TARGET_COPY_OUT_PRODUCT)/etc/fstab.postinstall

PRODUCT_PRODUCT_PROPERTIES += \
    ro.charger.enable_suspend=true

# Build necessary packages for system
PRODUCT_PACKAGES += \
    libhidltransport \
    libhwbinder \
    libmediaplayerservice:32 \
    libstagefright_httplive:32

# Media
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.1.vendor

# Build necessary packages for vendor
PRODUCT_PACKAGES += \
    ese-ls-provision \
    ese-replay \
    libdrm.vendor \
    libhdrplusclient.vendor:32 \
    libhidltransport.vendor \
    libhwbinder.vendor \
    libjson \
    libsensorndkbridge:32 \
    libtinycompress \
    libtinyxml \
    libwifi-hal:64

# Add missing vendor props
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true \
    media.mediadrmservice.enable=true \
    ro.oem_unlock.pst_offset=6144 \
    ro.oem_unlock.pst=/dev/block/platform/soc/1da4000.ufshc/by-name/misc

PRODUCT_HOST_PACKAGES += \
    dtc

# Graphics properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.gfx.angle.supported=true \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno \
    ro.gfx.driver.0=com.google.pixel.wahoo.gfxdrv \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/uinput-fpc.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-fpc.kl \
    $(LOCAL_PATH)/configs/keylayout/uinput-fpc.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/uinput-fpc.idc \

# CHRE
PRODUCT_PACKAGES += \
    chre

# Update this list with what each blob is actually for
# libstdc++: hexagon DSP blobs
PRODUCT_PACKAGES += \
    libstdc++.vendor

PRODUCT_PACKAGES += \
    android.frameworks.displayservice@1.0.vendor

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0.vendor

# WiFi
PRODUCT_PACKAGES += \
    android.system.net.netd@1.0 \
    android.system.net.netd@1.0.vendor \
    netutils-wrapper-1.0

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0.vendor \
    android.hardware.keymaster@4.0.vendor

# Gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0.vendor

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0 \
    android.hardware.bluetooth@1.0.vendor

# OEMLock
PRODUCT_PACKAGES += \
    android.hardware.oemlock@1.0 \
    android.hardware.oemlock@1.0.vendor

# Elmyra
PRODUCT_PACKAGES += \
    ElmyraService

# Now Playing
PRODUCT_PACKAGES += \
    NowPlayingOverlay

# Shims
PRODUCT_PACKAGES += \
    lib-imsvtshim

# IORap app launch prefetching using Perfetto traces and madvise
PRODUCT_PRODUCT_PROPERTIES += \
    ro.iorapd.enable=true

include hardware/google/pixel/vibrator/drv2624/device.mk
include hardware/google/pixel/mm/device_legacy.mk
include hardware/google/pixel/thermal/device.mk

# power HAL
-include hardware/google/pixel/power-libperfmgr/aidl/device.mk
