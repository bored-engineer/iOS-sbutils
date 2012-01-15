include theos/makefiles/common.mk

TOOL_NAME = sbalert sbdevice

sbalert_FILES = sbalert.mm
sbalert_FRAMEWORKS = CoreFoundation

sbdevice_FILES = sbdevice.mm
sbdevice_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tool.mk
