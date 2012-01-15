export TARGET_CODESIGN_FLAGS="-Ssign.plist"

include theos/makefiles/common.mk

TOOL_NAME = sbalert sbnetwork sbquit sblock sbdevice sblaunch sbbundleids sbopenurl sburlschemes

sbalert_FILES = sbalert.mm
sbalert_FRAMEWORKS = CoreFoundation

sbnetwork_FILES = Reachability/Reachability.m sbnetwork.mm
sbnetwork_FRAMEWORKS = Foundation SystemConfiguration

sbquit_FILES = sbquit.mm
sbquit_PRIVATE_FRAMEWORKS = GraphicsServices

sblock_FILES = sblock.mm
sblock_PRIVATE_FRAMEWORKS = GraphicsServices

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
