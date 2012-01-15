#include <CoreFoundation/CoreFoundation.h>
#include <stdbool.h>
#define SBSApplicationLaunchUnlockDevice 4
#define SBSApplicationDebugOnNextLaunch_plus_SBSApplicationLaunchWaitForDebugger 0x402

bool SBSProcessIDForDisplayIdentifier(CFStringRef id, pid_t *pid);
int SBSLaunchApplicationWithIdentifier(CFStringRef id, char flags);
int SBSLaunchApplicationForDebugging(CFStringRef bundleID, CFURLRef openURL, CFArrayRef arguments, CFDictionaryRef environment, CFStringRef stdout, CFStringRef stderr, char flags);

int main(int argc, char **argv) {
    bool p = false;
    const char *url = NULL;
    const char *bundle;
    int flags = SBSApplicationLaunchUnlockDevice;

    int c;
    while((c = getopt(argc, argv, "pdbu:")) != -1)
    switch(c) {
        case 'p': p = true; break;
        case 'd': flags |= SBSApplicationDebugOnNextLaunch_plus_SBSApplicationLaunchWaitForDebugger; break;
        case 'b': flags |= 1; break;
        case 'u': url = optarg; break;
        default: goto usage;
    }
    if(optind == argc) goto usage;
    bundle = argv[optind];

    CFMutableArrayRef arguments = CFArrayCreateMutable(NULL, 0, &kCFTypeArrayCallBacks);
    while(++optind != argc) CFArrayAppendValue(arguments, CFStringCreateWithCString(NULL, argv[optind], kCFStringEncodingUTF8));


    CFStringRef cs = CFStringCreateWithCString(NULL, bundle, kCFStringEncodingUTF8);
    CFURLRef cu = url ? CFURLCreateWithBytes(NULL, (UInt8*)url, strlen(url), kCFStringEncodingUTF8, NULL) : NULL;
    if(url && !cu) {
        fprintf(stderr, "invalid URL\n");
        return 1;
    }
    int err;
    if((err = SBSLaunchApplicationForDebugging(cs, cu, arguments, NULL, NULL, NULL, flags))) {
        fprintf(stderr, "SBSLaunchApplicationWithIdentifier failed: %d\n", err);
        return 1;
    }
    if(p) {
        pid_t pid;
        while(!SBSProcessIDForDisplayIdentifier(cs, &pid)) {
            usleep(50000);
        }
        printf("%d\n", (int) pid);
    }
    return 0;

    usage:
    fprintf(stderr, "Usage: sblaunch [-p] [-d] [-b] [-u url] <bundle> [arguments...]\n"
                    "  -p: print pid\n"
                    "  -d: launch for debugging\n"
                    "  -b: launch in background\n"
                    );
    return 1;
}
