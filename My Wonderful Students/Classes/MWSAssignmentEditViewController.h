//
//  MWSAssignmentEditViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/25/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSClass.h"
#import "MWSAssignment.h"
#import "MWSStudentAssignment.h"

@interface MWSAssignmentEditViewController : UITableViewController  <UITextFieldDelegate,  UIActionSheetDelegate> {
	
}
@property (nonatomic, retain) UIToolbar *buttonContainer;
@property (nonatomic, retain) UIBarButtonItem *buttonItem;
@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) MWSAssignment *theAssignment;
@property (nonatomic, retain) UIDatePicker *theDatePicker;
@property (nonatomic, retain) MWSStudent *student;
@property (nonatomic, retain) MWSStudentAssignment *theStudentAssignment;
@property (nonatomic, assign) BOOL canSave;

-(id)initWithClass:(MWSClass *)aClass andAssignment:(MWSAssignment *)anAssignment forStudents:(NSArray *)studentList;
-(id)initWithStudent:(MWSStudent *)aStudent andStudentAssignment:(MWSStudentAssignment *)studentAssignment;

-(void)save;
-(void)findAndResignFirstResponder;
-(BOOL)assignmentIsValid;

@end
