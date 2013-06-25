//
//  TextSender.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/12/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface TextSender : NSObject <MFMessageComposeViewControllerDelegate> {

}

@property (nonatomic, retain) UIViewController *theViewController;

+(TextSender *)sharedInstance;
-(BOOL)sendTextTo:(NSMutableArray *)recipients message:(NSString *)messageText withController:(UIViewController *)aViewController;



@end
