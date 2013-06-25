//
//  MWSTestEditViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/17/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSTest.h"
#import "MWSClass.h"


@interface MWSTestEditViewController : UITableViewController  <UITextFieldDelegate,  UIActionSheetDelegate> {
	
}

@property (nonatomic, retain) MWSTest *theTest;
@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) UIDatePicker *theDatePicker;
@property (nonatomic, assign) int helpIndex;

-(id)initForTest:(MWSTest *)aTest inClass:(MWSClass *)aClass;
-(void)save;
-(void)findAndResignFirstResponder;
-(BOOL)testIsValid;
-(void)helpMe;

@end
