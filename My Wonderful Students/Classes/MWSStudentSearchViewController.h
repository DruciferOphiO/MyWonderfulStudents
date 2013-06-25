//
//  MWSStudentSearchViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/16/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSClass.h"
#import "MWSStudent.h"
#import "MWSStudentEditViewController.h"

@protocol MWSStudentSearchProtocol <NSObject>

@required
- (void)resetTheStudent:(MWSStudent *)searchStudent;
@end

@interface MWSStudentSearchViewController  : UITableViewController <NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) MWSClass *theClass;
@property (nonatomic, retain) id <MWSStudentSearchProtocol> delegate;

-(id)initForClass:(MWSClass *)aClass withDelegate:(id)theDelegate;
-(void)reloadFetchedResults;
-(MWSStudent *)copyStudent:(MWSStudent *)student;
-(MWSContact *)copyContact:(MWSContact *)contact;

@end
