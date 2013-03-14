#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

#import <stdio.h>
void usage() {
	fprintf(stderr, "Usage: sbtoggle [-w] [-b] [-l] [-a] [-g] [-d]\n"
                    	"  -w: toggle Wi-Fi (on/off)\n"
                    	"  -b: toggle Bluetooth (on/off)\n"
                    	"  -l: toggle Location Services (on/off)\n"
                    	"  -a: toggle Airplane Mode (on/off)\n"
                    	"  -g: toggle 3G (on/off)\n"
                    	"  -d: toggle Data (on/off)\n"


                    	);
 }
int main(int argc, char **argv, char **envp) {
	if(!argv[1]){
		usage();
		return 1;

	}

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    	NSString *identifier = [[[NSString alloc] initWithUTF8String:argv[1]] autorelease];
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"options"];

		CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.innoying.sbserver"];	
    	NSDictionary *status = [messagingCenter sendMessageAndReceiveReplyName:@"sbtoggle" userInfo:userInfo];

    	int returnValue = [[status objectForKey:@"status"] intValue];
    
    	[pool release];

	if(returnValue == -1){
		fprintf(stderr, "There was an error. Please try again\n\n");

		usage();
	}
    	return returnValue;
		
}
