//
//  MWSConductEditViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSConduct.h"
#import "MWSStudent.h"

@interface MWSConductEditViewController : UITableViewController  <UITextViewDelegate,  UIActionSheetDelegate>  {

}

@property (nonatomic, retain) MWSConduct *theConduct;
@property (nonatomic, retain) MWSStudent *theStudent;
@property (nonatomic, retain) UIDatePicker *theDatePicker;
@property (nonatomic, retain) NSMutableArray *savedTextRecipients;
@property (nonatomic, retain) NSString *savedMessage;

-(id)initWithConduct:(MWSConduct *)aConduct forStudent:(MWSStudent *)aStudent;
-(void)findAndResignFirstResponder;
-(void)save;
-(BOOL)conductIsValid;

@end
