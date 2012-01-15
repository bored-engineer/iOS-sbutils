#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>

CFArrayRef SBSCopyPublicURLSchemes();

int main() {
    char buf[1024];
    CFArrayRef ary = SBSCopyPublicURLSchemes();
    CFIndex i;
    for(i = 0; i < CFArrayGetCount(ary); i++) {
        CFStringGetCString(CFArrayGetValueAtIndex(ary, i), buf, sizeof(buf), kCFStringEncodingUTF8);
        printf("%s\n", buf);
    }
    return 0;
}
