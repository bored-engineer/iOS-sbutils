#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
#include <stdbool.h>

CFArrayRef SBSCopyApplicationDisplayIdentifiers(bool onlyActive, bool debuggable);

int main() {
    char buf[1024];
    CFArrayRef ary = SBSCopyApplicationDisplayIdentifiers(false, false);
    CFIndex i;
    for(i = 0; i < CFArrayGetCount(ary); i++) {
        CFStringGetCString(CFArrayGetValueAtIndex(ary, i),buf, sizeof(buf), kCFStringEncodingUTF8);
        printf("%s\n", buf);
    }
    return 0;
}
