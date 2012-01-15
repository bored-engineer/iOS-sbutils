#import <UIKit/UIKit.h>

void display_usage( char **argv ){
	fprintf(stderr, "Usage: %s [option]\n"
                    "  -n: device name\n"
                    "  -N: system name\n"
                    "  -V: system version\n"
                    "  -m: localized model\n"
                    "  -u: udid\n"
                    "  -o: orientation\n"
                    "  -s: battery level\n"
                    "  -s: battery state\n"
                    "  -p: proximity sensor\n"
                    "  -e: multitasking support\n"
                    "  -h: This help message\n"
                    , argv[0]);
}

int main(int argc, char **argv, char **envp) {

	//Setup autoreleasepool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	//Get Device
	UIDevice *aDevice = [UIDevice currentDevice];
	
	//If no args
	if(argc == 1){
		//Display the help
		display_usage(argv);
		//Clean
		goto clean;
	}
	
	//Setup c for getopt
	int ch;

	//While more options to parse
	while ((ch = getopt(argc, argv, "nNVmMuolspeh")) != -1){
		//switch based on option
		switch (ch){
			case 'n':
				//Device Name
				printf("%s\n", (char*)[[aDevice name] UTF8String]);
			break;
			case 'N':
				//System Name
				printf("%s\n", (char*)[[aDevice systemName] UTF8String]);
			break;
			case 'V':
				//System Version
				printf("%s\n", (char*)[[aDevice systemVersion] UTF8String]);
			break;
			case 'm':
				//localized model
				printf("%s\n", (char*)[[aDevice localizedModel] UTF8String]);
			break;
			case 'M':
				//model
				printf("%s\n", (char*)[[aDevice model] UTF8String]);
			break;
			case 'u':
				//UUID
				printf("%s\n", (char*)[[aDevice uniqueIdentifier] UTF8String]);
			break;
			case 'o':
				//Orientation
				//Start the accelerometer
				[aDevice beginGeneratingDeviceOrientationNotifications];
				//Print orientation
				switch([aDevice orientation]){
					case UIDeviceOrientationPortrait:
						printf("Portrait\n");
					break;
					case UIDeviceOrientationPortraitUpsideDown:
						printf("PortraitUpsideDown\n");
					break;
					case UIDeviceOrientationLandscapeLeft:
						printf("LandscapeLeft\n");
					break;
					case UIDeviceOrientationLandscapeRight:
						printf("LandscapeRight\n");
					break;
					case UIDeviceOrientationFaceUp:
						printf("FaceUp\n");
					break;
					case UIDeviceOrientationFaceDown:
						printf("FaceDown\n");
					break;
					case UIDeviceOrientationUnknown:
					default:
						printf("Unknown\n");
					break;
				}
				//Stop the accelerometer
				[aDevice endGeneratingDeviceOrientationNotifications];
			break;
			case 'l':
				//Battery Level
				//Start the battery monitor
				[aDevice setBatteryMonitoringEnabled:YES];
				//Print battery levels
				printf("%.4f\n", (float)[aDevice batteryLevel]);
				//Stop the battery monitor
				[aDevice setBatteryMonitoringEnabled:NO];
			break;
			case 's':
				//Battery State
				//Start the battery monitor
				[aDevice setBatteryMonitoringEnabled:YES];
				//Print battery State
				switch([aDevice batteryState]){
					case UIDeviceBatteryStateFull:
						printf("Full\n");
					break;
					case UIDeviceBatteryStateCharging:
						printf("Charging\n");
					break;
					case UIDeviceBatteryStateUnplugged:
						printf("Unplugged\n");
					break;
					case UIDeviceBatteryStateUnknown:
					default:
						printf("Unknown\n");
					break;
				}
				//Stop the battery monitor
				[aDevice setBatteryMonitoringEnabled:NO];
			break;
			case 'p':
				//Proximity
				//Start the proximity monitor
				aDevice.proximityMonitoringEnabled = YES;
				//Check if enabled
				if (aDevice.proximityMonitoringEnabled == YES){
					//Print battery State
					if([aDevice proximityState] == true){
						printf("YES\n");
					}else{
						printf("NO\n");
					}
					//Stop the proximity monitor
					aDevice.proximityMonitoringEnabled = NO;
				}else{
					printf("UNAVAILABLE\n");
				}
			break;
			case 'e':
				//Multitasking enabled
				if(aDevice.multitaskingSupported == YES){
					printf("YES\n");
				}else{
					printf("NO\n");
				}
			break;
			case 'h':
			default:
				//Display the help
				display_usage(argv);
				//Clean
				goto clean;
			break;
        }
	}
	clean:
	
	//Finish up
	argc -= optind;
	argv += optind;
	
	//Drain the pool
	[pool drain];

	return 0;
}

// vim:ft=objc
