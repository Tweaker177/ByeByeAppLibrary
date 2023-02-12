ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:9.0
CFLAGS = #-fobjc-arc
DEBUG = 0
FINAL_PACKAGE = 0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ByeByeAppLibrary

ByeByeAppLibrary_FILES = BBARootListController.m
ByeByeAppLibrary_FRAMEWORKS = UIKit
ByeByeAppLibrary_PRIVATE_FRAMEWORKS = Preferences
ByeByeAppLibrary_INSTALL_PATH = /Library/PreferenceBundles
ByeByeAppLibrary_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
