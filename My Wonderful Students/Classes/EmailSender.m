//
//  EmailSender.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/12/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "EmailSender.h"
#import "TextSender.h"

static EmailSender *sharedInstance;

@implementation EmailSender

@synthesize theViewController;

#pragma mark -
#pragma mark Initialization

- (id)init {
	self = [super init];
	
	sharedInstance = self;
	return self;
}

+ (EmailSender *)sharedInstance {
	
	if (sharedInstance == nil) {
		sharedInstance = [[EmailSender alloc] init];
	}
	return sharedInstance;
}

-(BOOL)sendEmailTo:(NSMutableArray *)recipients 
		   subject:(NSString *)subjectText 
		   message:(NSString *)messageText 
	withController:(UIViewController *)aController{
	
	theViewController = aController;
	
	MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
	mailPicker.mailComposeDelegate = self; 
	[mailPicker setToRecipients:recipients];
	//NSString *theSubject =[NSString stringWithFormat:subjectText];
	[mailPicker setSubject:subjectText];
	[mailPicker setMessageBody:messageText isHTML:NO];
	mailPicker.navigationBar.barStyle = UIBarStyleBlack;
	[aController presentViewController:mailPicker animated:YES completion:NULL];
	return YES;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error"
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		}
			break;
	}
    [theViewController dismissViewControllerAnimated:YES completion:NULL];

}


@end
