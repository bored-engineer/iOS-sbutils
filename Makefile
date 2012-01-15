export TARGET_CODESIGN_FLAGS="-Ssign.plist"

include theos/makefiles/common.mk

TOOL_NAME = sbalert sbecid sbdevice sblaunch sbbundleids sbopenurl sburlschemes

sbalert_FILES = sbalert.mm
sbalert_FRAMEWORKS = CoreFoundation

sbecid_FILES = sbecid.mm
sbecid_FRAMEWORKS = IOKit Foundation UIKit
sbecid_LDFLAGS = -llockdown

sbdevice_FILES = sbdevice.mm
sbdevice_FRAMEWORKS = UIKit

sblaunch_FILES = sblaunch.c
sblaunch_FRAMEWORKS = CoreFoundation 
sblaunch_PRIVATE_FRAMEWORKS = SpringBoardServices 

sbbundleids_FILES = sbbundleids.c
sbbundleids_FRAMEWORKS = CoreFoundation 
sbbundleids_PRIVATE_FRAMEWORKS = SpringBoardServices 

sbopenurl_FILES = sbopenurl.c
sbopenurl_FRAMEWORKS = CoreFoundation 
sbopenurl_PRIVATE_FRAMEWORKS = SpringBoardServices 

sburlschemes_FILES = sburlschemes.c
sburlschemes_FRAMEWORKS = CoreFoundation 
sburlschemes_PRIVATE_FRAMEWORKS = SpringBoardServices 


include $(THEOS_MAKE_PATH)/tool.mk
