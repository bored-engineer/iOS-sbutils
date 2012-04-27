#import <AppSupport/CPDistributedMessagingCenter.h>
/*
#import <SpringBoard/SBMediaController.h>
#import <SpringBoard/SBWiFiManager.h>
#import <SpringBoard/SBTelephonyManager.h>
#import <BluetoothManager/BluetoothManager.h> 
#import <CoreLocation/CLLocationManager.h> 
*/
#import "header.h"



%hook SpringBoard 
- (id)init {
	if ((self = %orig)) {
		CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.innoying.sbserver"];
		[messagingCenter runServerOnCurrentThread];
		[messagingCenter registerForMessageName:@"sbmedia" target:self selector:@selector(handleSbmediaCommand:withUserInfo:)];
		[messagingCenter registerForMessageName:@"sbtoggle" target:self selector:@selector(handleSbtoggleCommand:withUserInfo:)];

	}
	return self;
}

%new(@@:@@)
- (NSDictionary *)handleSbmediaCommand:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
	//Extract options
	NSString *options = [userInfo objectForKey:@"options"];

	if([options isEqualToString:@"-t"] == YES){
		[(SBMediaController *)[%c(SBMediaController) sharedInstance] togglePlayPause];
	}else if([options isEqualToString:@"-p"] == YES){
                [(SBMediaController *)[%c(SBMediaController) sharedInstance] changeTrack:-1];
        }else if([options isEqualToString:@"-n"] == YES){
                [(SBMediaController *)[%c(SBMediaController) sharedInstance] changeTrack:1];
        }else{
		return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:-1] forKey:@"status"];	
	}
	return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"];
}
%new(@@:@@)
- (NSDictionary *)handleSbtoggleCommand:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
	//Extract options
    NSLog(@"it's called!");
	NSString *options = [userInfo objectForKey:@"options"];
    
	if([options isEqualToString:@"-w"] == YES){
        if ([%c(SBWiFiManager) sharedInstance] == nil) {
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:-1] forKey:@"status"];
        }
		if ([[%c(SBWiFiManager) sharedInstance] wiFiEnabled]) {
			[[%c(SBWiFiManager) sharedInstance] setWiFiEnabled:NO];
		}
		else {
			[[%c(SBWiFiManager) sharedInstance] setWiFiEnabled:YES];
		}
	}else if([options isEqualToString:@"-a"] == YES){
        id sharedController = [%c(SBTelephonyManager) sharedTelephonyManager];

        if ([sharedController isInAirplaneMode]) {
            [sharedController setIsInAirplaneMode:NO];
            [sharedController updateAirplaneMode];
			[sharedController airplaneModeChanged];
        }
        else {
            [sharedController setIsInAirplaneMode:YES];
            [sharedController updateAirplaneMode];
			[sharedController airplaneModeChanged];
        }
        	return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"];

    }else if([options isEqualToString:@"-l"] == YES){
		Class CLLocationManager = %c(CLLocationManager);    	
    	if ([CLLocationManager locationServicesEnabled]) {
    		[CLLocationManager setLocationServicesEnabled:NO];
    		[CLLocationManager setStatusBarIconEnabled:NO forLocationEntityClass:1];
    	}
    	else {
    	    [CLLocationManager setLocationServicesEnabled:YES];
    	    [CLLocationManager setStatusBarIconEnabled:YES forLocationEntityClass:1];
	}

    }else if([options isEqualToString:@"-b"] == YES){
		id btoggleController = [objc_getClass("BluetoothManager") sharedInstance];
		[btoggleController setPowered:![btoggleController powered]];
    }else if([options isEqualToString:@"-g"] == YES){
    //To-do
    }else if([options isEqualToString:@"-d"] == YES){
    //To-do
    }else{
		return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:-1] forKey:@"status"];	
	}
	return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"];
}
%end