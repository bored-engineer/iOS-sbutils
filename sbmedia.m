#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

#import <stdio.h>

int main(int argc, char **argv, char **envp) {
	if(!argv[1]){
		goto usage;
	}

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    	NSString *identifier = [[NSString alloc] initWithUTF8String:argv[1]];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"options"];

	CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.innoying.sbserver"];	
    	NSDictionary *status = [messagingCenter sendMessageAndReceiveReplyName:@"sbmedia" userInfo:userInfo];

    	int returnValue = [[status objectForKey:@"status"] intValue];
    
    	[pool release];

	if(returnValue == -1){
		goto usage;
	}
    	return returnValue;

	usage:
		fprintf(stderr, "Usage: sbmedia [-t] [-n] [-p]\n"
                    	"  -t: toggle music (play/pause)\n"
                    	"  -n: go to next song\n"
                    	"  -p: go to previous song\n"
                    	);
		return 1;
}
