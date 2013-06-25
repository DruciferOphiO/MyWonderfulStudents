//
//  MWSCoreDataManager.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MWSTeacher.h"
#import "MWSStudent.h"
#import "MWSContact.h"
#import "MWSAttendance.h"
#import "MWSTest.h"
#import "MWSAssignment.h"
#import "MWSStudentTest.h"
#import "MWSStudentAssignment.h"
#import "MWSConduct.h"

@interface MWSCoreDataManager : NSObject <NSFetchedResultsControllerDelegate> {
	
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;

}

@property (weak, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (weak, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (MWSCoreDataManager *)sharedInstance;
+ (NSString *)applicationDocumentsDictionary;

-(NSFetchedResultsController *)getFetchedResultsControllerForClassesForTeacher:(MWSTeacher *)teacher;
-(NSFetchedResultsController *)getFetchedResultsControllerForStudentsInClass:(MWSClass *)aClass forTeacher:(MWSTeacher *)teacher;
-(NSFetchedResultsController *)getFetchedResultsControllerForTestsInClass:(MWSClass *)aClass;
-(MWSTeacher *)getTeacher;
-(MWSClass *)newClass;
-(NSArray *)getClasses;
-(MWSStudent *)newStudent;
-(MWSContact *)newContact;
-(MWSAttendance *)getNewAttendance;
-(BOOL)hasChanges;
-(void)saveContext;
-(void)abandonChanges;
-(void)deleteTest:(MWSTest *)testToDelete;
-(NSFetchedResultsController *)getFetchedResultsControllerForStudentsNotInClass:(MWSClass *)aClass;
-(MWSTest *)newTest;
-(NSFetchedResultsController *)getFetchedResultsControllerForAssignmentsInClass:theClass;
-(MWSAssignment *)newAssignment;
-(MWSStudentTest *)newStudentTest;
-(MWSStudentAssignment *)newStudentAssignment;
-(MWSConduct *)newConduct;

@end
