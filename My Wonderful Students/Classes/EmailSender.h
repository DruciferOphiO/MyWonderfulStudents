//
//  EmailSender.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/12/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface EmailSender : NSObject  <MFMailComposeViewControllerDelegate>{
	
}

@property (nonatomic, retain) UIViewController *theViewController;

+(EmailSender *)sharedInstance;

-(BOOL)sendEmailTo:(NSMutableArray *)recipients 
		   subject:(NSString *)subjectText 
		   message:(NSString *)messageText 
	withController:(UIViewController *)aController;
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
