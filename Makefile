include theos/makefiles/common.mk

TOOL_NAME = sbalert

sbalert_FILES = sbalert.mm
sbalert_FRAMEWORKS = CoreFoundation



include $(THEOS_MAKE_PATH)/tool.mk
