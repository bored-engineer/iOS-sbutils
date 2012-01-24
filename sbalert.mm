#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFUserNotification.h>
#include <unistd.h>

void display_usage( char **argv ){
	fprintf(stderr, "Usage: %s [arguments...]\n"
                    "  -t: title/header text\n"
                    "  -m: message text\n"
                    "  -d: default button text\n"
                    "  -a: alternate button text\n"
                    "  -o: other button text\n"
                    "  -q: timeout in seconds\n"
                    "  -h: This help message\n"
                    "\n"
                    "  It will print the result of the notification:\n"
                    "     0: Default Button\n"
                    "     1: Alternate Button\n"
                    "     2: Other Button\n"
                    "     3: Timeout\n"
                    , argv[0]);
	exit(-1);
}

//Main
int main(int argc, char **argv, char **envp) {
	
	//getopt stuff
	extern char *optarg;
	extern int optind;

	//Setup the Timeout
	CFTimeInterval timeout = 0;
	
	//Setup the notification dictionary
	CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

	//If not enough options
	if (argc == 1) {
		//Display the usage and exit
		display_usage(argv);
	}
		
	//Setup c for getopt
	int ch;
	
	//While more options to parse
	while ((ch = getopt(argc, argv, "ht:m:d:a:o:pv:q:")) != -1){
		//switch based on option
		switch (ch){
        	case 't':
        		//Title/Header
				CFDictionaryAddValue( dict, kCFUserNotificationAlertHeaderKey, CFStringCreateWithCString(NULL, optarg, kCFStringEncodingUTF8) );
        	break;
        	case 'm':
        		//Message
				CFDictionaryAddValue( dict, kCFUserNotificationAlertMessageKey, CFStringCreateWithCString(NULL, optarg, kCFStringEncodingUTF8) );
        	break;
        	case 'd':
        		//Default Button
				CFDictionaryAddValue( dict, kCFUserNotificationDefaultButtonTitleKey, CFStringCreateWithCString(NULL, optarg, kCFStringEncodingUTF8) );
        	break;
        	case 'a':
        		//Alternate Button
				CFDictionaryAddValue( dict, kCFUserNotificationAlternateButtonTitleKey, CFStringCreateWithCString(NULL, optarg, kCFStringEncodingUTF8) );
        	break;
        	case 'o':
        		//Other Button
				CFDictionaryAddValue( dict, kCFUserNotificationOtherButtonTitleKey, CFStringCreateWithCString(NULL, optarg, kCFStringEncodingUTF8) );
        	break;
        	case 'p':
        		//Prompt
        		CFDictionaryAddValue( dict, kCFUserNotificationTextFieldTitlesKey, @"title" );
        	break;
        	case 'v':
				//Value
	        	CFDictionaryAddValue( dict, kCFUserNotificationTextFieldValuesKey, CFStringCreateWithCString(NULL, optarg, kCFStringEncodingUTF8) );
        	case 'q':
        		//Timeout
				timeout = atoi(optarg);
        	break;
        	case 'h':
        	default:
        		display_usage(argv);
        }
	}
	//Finish up
	argc -= optind;
	argv += optind;
	
	//Setup error value used later
	SInt32 error;	
	
	//Setup the flags
	CFOptionFlags flags = 0;
	
	//Normal alert level
	flags |= kCFUserNotificationPlainAlertLevel;
	
	//Make important
	CFDictionaryAddValue( dict, kCFUserNotificationAlertTopMostKey, kCFBooleanTrue );

	//Setup notification
	CFNotificationCenterPostNotificationWithOptions( CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("test"),  NULL, NULL, kCFNotificationDeliverImmediately );
	
	//Send it
	CFUserNotificationRef notif = CFUserNotificationCreate( NULL, timeout, flags, &error, dict );
	
	//Setup options
	CFOptionFlags options;
	
	//Get result and save to options
	CFUserNotificationReceiveResponse( notif, 0, &options );
	
	CFDictionaryRef result = CFUserNotificationGetResponseDictionary(notif);
	
	//Setup autoreleasepool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSDictionary * powerDic = (NSDictionary *) result;
	
	NSString * aValue = [powerDic objectForKey:@"TextFieldValues"];
	
	if( aValue.length > 0 ){
		printf( "%s\n", [aValue UTF8String] );
	}
	
	[pool drain];
	
	if((int) error == 0){
		exit((int) options);
	}else{
		exit(error);
	}
}

