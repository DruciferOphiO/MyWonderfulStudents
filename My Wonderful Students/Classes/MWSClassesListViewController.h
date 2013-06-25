//
//  MWSClassesListViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSTeacher.h"

#import "MWSClassEditViewController.h"
#import "MWSTeacherViewController.h"
#import "MWSStudentListViewController.h"
#import "MWSStudentAttendanceViewController.h"
#import "MWSStudentTestListViewController.h"
#import "MWSStudentAssignmentListViewController.h"

@interface MWSClassesListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) MWSTeacher *teacher;
@property (nonatomic, assign) int helpIndex;

@property (nonatomic, retain) MWSClassEditViewController *classEditViewController;
@property (nonatomic, retain) MWSTeacherViewController *detailViewController;
@property (nonatomic, retain) MWSStudentListViewController *studentListViewController;
@property (nonatomic, retain) MWSStudentAttendanceViewController *studentAttendance;
@property (nonatomic, retain) MWSStudentTestListViewController *studentTestList;
@property (nonatomic, retain) MWSStudentAssignmentListViewController *studentAssignmentList;

-(void)editDone;
-(void)reloadFetchedResults;
-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer;
-(void)helpMe;

@end
