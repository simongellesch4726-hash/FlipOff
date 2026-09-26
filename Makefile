TARGET := iphone:clang:16.5:15.0
ARCHS = arm64e
THEOS_PACKAGE_SCHEME = roothide

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AccessoryAlertTest

AccessoryAlertTest_FILES = Tweak.xm
AccessoryAlertTest_FRAMEWORKS = Foundation
AccessoryAlertTest_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
