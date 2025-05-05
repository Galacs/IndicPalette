TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = IndicPalettePreferences

IndicPalettePreferences_FILES = INPRootListController.m
IndicPalettePreferences_FRAMEWORKS = UIKit
IndicPalettePreferences_PRIVATE_FRAMEWORKS = Preferences
IndicPalettePreferences_INSTALL_PATH = /Library/PreferenceBundles
IndicPalettePreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
