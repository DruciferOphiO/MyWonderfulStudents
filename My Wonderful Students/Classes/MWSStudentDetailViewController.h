//
//  MWSStudentDetailViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/5/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSStudent.h"
#import "MWSClass.h"

#import "MWSAssignmentEditViewController.h"
#import "MWSConductEditViewController.h"
#import "MWSEnterAssignmentsDoneViewController.h"

@interface MWSStudentDetailViewController : UITableViewController {
	
}

@property (nonatomic, retain) MWSStudent *student;
@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) NSMutableArray *sortedConductArray;
@property (nonatomic, retain) NSMutableArray *sortedAttendanceAbsentArray;
@property (nonatomic, retain) NSDateFormatter *df;
@property (nonatomic, retain) NSArray *sortedStudentTests;
@property (nonatomic, retain) NSArray *sortedStudentAssignments;
@property (nonatomic, assign) int helpIndex;

@property (nonatomic, retain) MWSAssignmentEditViewController *assignmentEditViewController;
@property (nonatomic, retain) MWSEnterAssignmentsDoneViewController *enterAssignmentsDoneViewController;

- (id)initStudent:(MWSStudent *)aStudent forClassName:(MWSClass *)aClass;

-(UITableViewCell *)section0CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *)section1CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *)section2CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *)section3CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
-(void)findAndResignFirstResponder;
-(void)helpMe;
-(void)sendStudentReport;

@end
