//
//  TextSender.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/12/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "TextSender.h"

static TextSender *sharedInstance;


@implementation TextSender

@synthesize theViewController;

#pragma mark -
#pragma mark Initialization

- (id)init {
	self = [super init];
	
	sharedInstance = self;
	return self;
}

+ (TextSender *)sharedInstance {
	
	if (sharedInstance == nil) {
		sharedInstance = [[TextSender alloc] init];
	}
	return sharedInstance;
}

-(BOOL)sendTextTo:(NSMutableArray *)recipients message:(NSString *)messageText withController:(UIViewController *)aViewController {

	theViewController = aViewController;
	
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	if ([MFMessageComposeViewController canSendText]) 
	{
		picker.recipients = recipients;
		picker.body = messageText;
		picker.messageComposeDelegate = self;
        [aViewController presentViewController:picker animated:YES completion:NULL];
		
	}
	
	return YES;

}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Text" message:@"Unknown Error" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[alert show];
			
		}
			break;
		case MessageComposeResultSent:
			
			break;
			
		default:
			break;
	}
    [theViewController dismissViewControllerAnimated:YES completion:NULL];
	
}

@end
