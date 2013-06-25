//
//  MWSEnterAssignmentsDoneViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSAssignment.h"
#import "MWSStudent.h"

@interface MWSEnterAssignmentsDoneViewController : UITableViewController {
	
}

@property (nonatomic, retain) MWSAssignment *theAssignment;
@property (nonatomic, retain) NSArray *theStudentAssignmentList;
@property (nonatomic, retain) UIToolbar *buttonContainer;
@property (nonatomic, retain) UIBarButtonItem *buttonItem;
@property (nonatomic, retain) NSMutableArray *savedTextRecipients;
@property (nonatomic, retain) NSString *savedMessage;

-(id)initForAssignment:(MWSAssignment *)anAssignment forStudents:(NSArray *)studentListArray inClass:(MWSClass *)theClass individualFlag:(BOOL)individual;
-(void)findAndResignFirstResponder;
-(void)helpMe;

@end
