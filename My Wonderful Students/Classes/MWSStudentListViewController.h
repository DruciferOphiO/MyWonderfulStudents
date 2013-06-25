//
//  MWSStudentListViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSClass.h"
#import "MWSStudent.h"

#import "MWSStudentDetailViewController.h"
#import "MWSStudentEditViewController.h"

@interface MWSStudentListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

}

@property (nonatomic, strong) MWSClass *theClass;
@property (nonatomic, strong) NSMutableArray *studentListArray;
@property (nonatomic, strong) MWSStudent *aStudent;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, assign) int helpIndex;

@property (nonatomic, strong) MWSStudentDetailViewController *studentDetailViewController;
@property (nonatomic, strong) MWSStudentEditViewController *studentEditViewController;

-(id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *)tabBarController;
-(void)buildStudentListArray;
-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer;
-(void)addStudent;
-(void)helpMe;

@end
