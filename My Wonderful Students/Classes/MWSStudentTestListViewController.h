//
//  MWSStudentTestListViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/27/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSClass.h"
#import "MWSStudent.h"

#import "MWSTestEditViewController.h"
#import "MWSEnterTestGrades.h"

@interface MWSStudentTestListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	
}

@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableArray *testListArray;
@property (nonatomic, retain) MWSStudent *aStudent;
@property (nonatomic, assign) int helpIndex;

@property (nonatomic, retain) MWSTestEditViewController *testEditViewController;
@property (nonatomic, retain) MWSEnterTestGrades *enterTestGradesViewController;

-(id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *)theTabBarController  ;
-(void)loadTests;
-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer;
-(void)helpMe;

@end
