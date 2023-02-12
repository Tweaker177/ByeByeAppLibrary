ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:9.0
CFLAGS = #-fobjc-arc
DEBUG = 0
FINAL_PACKAGE = 0
GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ByeByeAppLibrary
ByeByeAppLibrary_FILES = Tweak.xm
ByeByeAppLibrary_FRAMEWORKS = UIKit Foundation
ByeByeAppLibrary_CFLAGS += -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += byebyeapplibrary
include $(THEOS_MAKE_PATH)/aggregate.mk
