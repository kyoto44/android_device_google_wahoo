LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := CalculatorGooglePrebuilt CalendarGooglePrebuilt CarrierMetrics CarrierWifi DevicePolicyPrebuilt DiagnosticsToolPrebuilt GoogleTTS Ornament Photos PrebuiltBugle PrebuiltDeskClockGoogle Showcase TipsPrebuilt Tycho talkback
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)
