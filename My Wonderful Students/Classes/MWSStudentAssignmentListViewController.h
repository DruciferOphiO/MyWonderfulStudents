//
//  MWSStudentAssignmentListViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/27/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSClass.h"
#import "MWSStudent.h"

#import "MWSStudentEditViewController.h"
#import "MWSAssignmentEditViewController.h"
#import	"MWSEnterAssignmentsDoneViewController.h"

@interface MWSStudentAssignmentListViewController : UITableViewController  <NSFetchedResultsControllerDelegate> {
}

@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) NSDateFormatter *df;
@property (nonatomic, retain) NSMutableArray *assignmentListArray;
@property (nonatomic, retain) NSMutableArray *studentListArray;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, assign) int helpIndex;

@property (nonatomic, retain) MWSEnterAssignmentsDoneViewController *enterAssignmentsDoneViewController;
@property (nonatomic, retain) MWSAssignmentEditViewController *assignmentEditViewController;

-(id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *) tabBarController forStudents:(NSArray *) studentList;
- (void)loadAssignments;
-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer;
-(void)newAssigment;
-(void)helpMe;

@end
