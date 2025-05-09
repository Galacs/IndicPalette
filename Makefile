TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IndicPalette

IndicPalette_LIBRARIES = sparkcolourpicker
IndicPalette_FILES = Tweak.x
IndicPalette_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += IndicPalettePreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
