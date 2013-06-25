//
//  MWSStudentAttendance.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/27/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSTeacher.h"
#import "MWSClass.h"
#import "MWSStudent.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface MWSStudentAttendanceViewController : UITableViewController <NSFetchedResultsControllerDelegate,  UIActionSheetDelegate, UINavigationControllerDelegate> {
    
}

@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) MWSTeacher *theTeacher;
@property (nonatomic, retain) NSMutableArray *studentListArray;
@property (nonatomic, retain) NSMutableArray *attendanceArray;
@property (nonatomic, retain) MWSStudent *aStudent;
@property (nonatomic, retain) NSDate *theDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *theDatePicker;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UIBarButtonItem *buttonItem;
@property (nonatomic, retain) NSMutableArray *savedTextRecipients;
@property (nonatomic, retain) NSString *savedMessage;
@property (nonatomic, assign) int helpIndex;

-(id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *) tabBarController;
-(void)buildStudentListArray;
-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer;
-(void)findAndResignFirstResponder;
-(void)buildAttendanceArrayForDate:(NSDate *)aDate;
-(void)save;
-(void)helpMe;

@end
