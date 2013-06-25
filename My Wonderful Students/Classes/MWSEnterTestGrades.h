//
//  MWSEnterTestGrades.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/20/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSTest.h"
#import "MWSClass.h"
#import "MWSStudent.h"
#import "MWSStudentTest.h"

@interface MWSEnterTestGrades : UITableViewController  <UITextFieldDelegate, NSFetchedResultsControllerDelegate> {

}

@property (nonatomic, retain) NSArray *studentList;
@property (nonatomic, retain) UIToolbar *buttonContainer;
@property (nonatomic, retain) UIBarButtonItem *buttonItem;
@property (nonatomic, retain) MWSTest *theTest;
@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) MWSStudent *theStudent;
@property (nonatomic, retain) MWSStudentTest *theStudentTest;
@property (nonatomic, retain) NSMutableArray *savedTextRecipients;
@property (nonatomic, retain) NSString *savedMessage;
@property (nonatomic, retain) MWSStudent *previousStudent;

-(id)initForTest:(MWSTest *)aTest inClass:(MWSClass *)aClass;
-(void)save;
-(void)findAndResignFirstResponder;

@end
