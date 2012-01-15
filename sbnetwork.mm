#import "Reachability/Reachability.h"
	
int main(int argc, char **argv, char **envp) { 
	//Create target from name
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithName(NULL, argv[1]);
	//Setup flags
	SCNetworkReachabilityFlags flags;
	//Get the flags
	SCNetworkReachabilityGetFlags(target, &flags);
	//If accessible
	if (flags & kSCNetworkReachabilityFlagsReachable){
		//If is from Carrier
		if( flags & kSCNetworkReachabilityFlagsIsWWAN ){
			printf("CARRIER\n");
		}else{
			printf("WIFI\n");
		}
	}else{
		printf("FAILED\n");
	}

    return 0;
}