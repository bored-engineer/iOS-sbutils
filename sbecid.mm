#include "IOKit/IOKitLib.h"

int main(int argc, char *argv[]) { 
    if (CFMutableDictionaryRef dict = IOServiceMatching("IOPlatformExpertDevice")) {
        if (io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, dict)) {
            if (CFTypeRef ecid = IORegistryEntrySearchCFProperty(service, kIODeviceTreePlane, CFSTR("unique-chip-id"), kCFAllocatorDefault, kIORegistryIterateRecursively)) {
                NSData *data((NSData *) ecid);
                size_t length([data length]);
                uint8_t bytes[length];
                [data getBytes:bytes];
                char string[length * 2 + 1];
                for (size_t i(0); i != length; ++i)
                    sprintf(string + i * 2, "%.2X", bytes[length - i - 1]);
				printf("%s", string);
                CFRelease(ecid);
	    	}
            IOObjectRelease(service);
        }
    }
    return 0;
}