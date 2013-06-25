//
//  MWSStudentEditViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSStudent.h"
#import "MWSClass.h"
#import	"MWSStudentSearchViewController.h"

@interface MWSStudentEditViewController : UITableViewController  <UITextFieldDelegate> {
	
}

@property (nonatomic, retain) UIToolbar *buttonContainer;
@property (nonatomic, retain) UIBarButtonItem *buttonItem;
@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) MWSStudent *student;
@property (nonatomic, assign) BOOL abandonUpdates;
@property (nonatomic, assign) int helpIndex;

- (id)initStudent:student forClassName:theClass;
- (BOOL)studentIsValid;
- (void)findAndResignFirstResponder;
- (void)resetTheStudent:(MWSStudent *)searchStudent;
-(void)helpMe;

@end
