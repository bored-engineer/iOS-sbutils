#include <CoreFoundation/CoreFoundation.h>
#include <stdbool.h>
#include <unistd.h>
#define SBSApplicationLaunchUnlockDevice 4
#define SBSApplicationDebugOnNextLaunch_plus_SBSApplicationLaunchWaitForDebugger 0x402

bool SBSOpenSensitiveURLAndUnlock(CFURLRef url, char flags);

int main(int argc, char **argv) {
    if(argc != 2) {
        fprintf(stderr, "Usage: sbopenurl url\n");
        return 1;
    }
    CFURLRef cu = CFURLCreateWithBytes(NULL, (UInt8*)argv[1], strlen(argv[1]), kCFStringEncodingUTF8, NULL);
    if(!cu) {
        fprintf(stderr, "invalid URL\n");
        return 1;
    }
    int fd = dup(2);
    close(2);
    bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
    if(!ret) {
    dup2(fd, 2);
        fprintf(stderr, "SBSOpenSensitiveURLAndUnlock failed\n");
        return 1;
    }
    return 0;
}
