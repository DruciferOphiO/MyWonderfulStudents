//
//  MWSCoreDataManager.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSCoreDataManager.h"
#import "My_Wonderful_StudentsAppDelegate.h"
#import "MWSTeacher.h"
#import "MWSStudent.h"
#import "MWSClass.h"
#import "MWSTest.h"

static MWSCoreDataManager *sharedInstance;

// any changes here need to be made in MWSClassEditViewContoller
static NSString *sortByFirstName = @"sortByFirstName";
static NSString *sortByLastName  = @"sortByLastName";
static NSString *sortById		 = @"sortById";

@implementation MWSCoreDataManager

#pragma mark -
#pragma mark Initialization

- (id)init {
	self = [super init];
	
	// set up the data store
	managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	NSString *dbFilePath = [[MWSCoreDataManager applicationDocumentsDictionary] stringByAppendingPathComponent:@"MWSDB2012"];
	NSURL *storeUrl = [NSURL fileURLWithPath:dbFilePath];
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Couldn't create the DB");
	}
	managedObjectContext = [[NSManagedObjectContext alloc] init];
	[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
	
	sharedInstance = self;
	return self;
}

+ (MWSCoreDataManager *)sharedInstance {
	
	if (sharedInstance == nil) {
		NSLog(@"Creating a core data manager");
		sharedInstance = [[MWSCoreDataManager alloc] init];
	}
	return sharedInstance;
}

+ (NSString *)applicationDocumentsDictionary {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark CRUD

- (NSManagedObjectContext *)managedObjectContext {
	return [self managedObjectContext];
}
- (NSManagedObjectModel *)managedObjectModel {
	return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	return persistentStoreCoordinator;
}

-(NSFetchedResultsController *)getFetchedResultsControllerForClassesForTeacher:(MWSTeacher *)teacher {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MWSClass"
														 inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setFetchBatchSize:20];
	
	// filter the results for deleted
	NSPredicate *filterPredicate;
	if ([[teacher showDeletedClasses] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
		filterPredicate = [NSPredicate predicateWithFormat:@"(deleted = 0)"];
		[fetchRequest setPredicate:filterPredicate];
	}
	
	// set up sort
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
	[sortDescriptors addObject:sortDescriptor1];
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"myClassName" ascending:YES];
	[sortDescriptors addObject:sortDescriptor2];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *ftc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																		  managedObjectContext:managedObjectContext
																			sectionNameKeyPath:nil 
																					 cacheName:nil];
	return ftc;
}

-(NSFetchedResultsController *)getFetchedResultsControllerForStudentsInClass:(MWSClass *)aClass forTeacher:(MWSTeacher *)teacher {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MWSStudent"
														 inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setFetchBatchSize:20];
	
	// filter the results for deleted
	NSPredicate *filterPredicate;
	if ([[teacher showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
		filterPredicate = [NSPredicate predicateWithFormat:@"(myClass = %@) and (deleted = 0)", aClass];
		[fetchRequest setPredicate:filterPredicate];
	} else {
		filterPredicate = [NSPredicate predicateWithFormat:@"(myClass = %@)", aClass];
		[fetchRequest setPredicate:filterPredicate];
	}

	
	// set up sort 
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor1;
	if ([[aClass sortBy] compare:sortByFirstName] == NSOrderedSame) {
		sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
		[sortDescriptors addObject:sortDescriptor1];
	}else if ([[aClass sortBy] compare:sortByLastName] == NSOrderedSame) {
		sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
		[sortDescriptors addObject:sortDescriptor1];
	} else if ([[aClass sortBy] compare:sortById] == NSOrderedSame) {
		sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"idNumber" ascending:YES];
		[sortDescriptors addObject:sortDescriptor1];
	}
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *ftc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																		  managedObjectContext:managedObjectContext
																			sectionNameKeyPath:nil 
																					 cacheName:nil];
	
	return ftc;
}

-(NSFetchedResultsController *)getFetchedResultsControllerForTestsInClass:(MWSClass *)aClass {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MWSTest"
														 inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setFetchBatchSize:20];
	
	// filter the results for deleted
	NSPredicate *filterPredicate;
	filterPredicate = [NSPredicate predicateWithFormat:@"(myClass = %@) and (deleted = 0)", aClass];
	[fetchRequest setPredicate:filterPredicate];
	
	
	// set up sort 
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	[sortDescriptors addObject:sortDescriptor];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *ftc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																		  managedObjectContext:managedObjectContext
																			sectionNameKeyPath:nil 
																					 cacheName:nil];
	
	return ftc;
	
}

-(MWSTeacher *)getTeacher {
	NSManagedObjectContext *moc = managedObjectContext;
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MWSTeacher" inManagedObjectContext:moc];	
	[fetch setEntity:entity];
	NSError *error;
	NSArray *result = [moc executeFetchRequest:fetch error:&error];
	if (!result) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Teacher fetch failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return nil;
	}
	if ([result count] == 0) {
		MWSTeacher *newTeacher = [NSEntityDescription insertNewObjectForEntityForName:@"MWSTeacher" inManagedObjectContext:moc];
		if (!result) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New teacher create failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			return nil;
		}
		//[newTeacher setClasses:[NSSet [self getClasses]
		return newTeacher;
	}
	return [result objectAtIndex:0];
}

-(NSArray *)getClasses {
	NSManagedObjectContext *moc = managedObjectContext;
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MWSClasses" inManagedObjectContext:moc];	
	[fetch setEntity:entity];
	NSError *error;
	NSArray *result = [moc executeFetchRequest:fetch error:&error];
	if (!result) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Teacher fetch failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return nil;
	}
	return result;
}

-(MWSClass *)newClass {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSClass *newClass = [NSEntityDescription insertNewObjectForEntityForName:@"MWSClass" inManagedObjectContext:moc];	
	if (newClass == nil) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New class create failed" message:@"New class create failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return nil;
	}
	return newClass;
}

-(MWSStudent *)newStudent {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSStudent *newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"MWSStudent" inManagedObjectContext:moc];	
	if (newStudent == nil) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New student create failed" message:@"New student create failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return nil;
	}
	return newStudent;
}

-(MWSContact *)newContact {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSContact *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"MWSContact" inManagedObjectContext:moc];	
	if (newContact == nil) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New contact create failed" message:@"New contact create failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return nil;
	}
	return newContact;
}

-(MWSAttendance *)getNewAttendance {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSAttendance *newAttendance = [NSEntityDescription insertNewObjectForEntityForName:@"MWSAttendance" inManagedObjectContext:moc];
	return newAttendance;
}


-(MWSTest *)newTest {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSTest *aNewTest = [NSEntityDescription insertNewObjectForEntityForName:@"MWSTest" inManagedObjectContext:moc];
	return aNewTest;
}

-(MWSAssignment *)newAssignment {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSAssignment *aNewAssignment = [NSEntityDescription insertNewObjectForEntityForName:@"MWSAssignment" inManagedObjectContext:moc];
	return aNewAssignment;
}

-(MWSStudentTest *)newStudentTest {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSStudentTest *aNewStudentTest = [NSEntityDescription insertNewObjectForEntityForName:@"MWSStudentTest" inManagedObjectContext:moc];
	return aNewStudentTest;
}

-(MWSConduct *)newConduct {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSConduct *aNewConduct = [NSEntityDescription insertNewObjectForEntityForName:@"MWSConduct" inManagedObjectContext:moc];
	return aNewConduct;
}

-(MWSStudentAssignment *)newStudentAssignment {
	NSManagedObjectContext *moc = managedObjectContext;
	MWSStudentAssignment *aNewStudentAssignment = [NSEntityDescription insertNewObjectForEntityForName:@"MWSStudentAssignment" inManagedObjectContext:moc];
	return aNewStudentAssignment;
}

-(NSFetchedResultsController *)getFetchedResultsControllerForStudentsNotInClass:(MWSClass *)aClass {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MWSStudent"
														 inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setFetchBatchSize:20];
	
	// filter the results for deleted
	NSPredicate *filterPredicate;
	filterPredicate = [NSPredicate predicateWithFormat:@"(myClass != %@) and (deleted = 0)", aClass];
	[fetchRequest setPredicate:filterPredicate];
	
	
	// set up sort 
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor1;
	sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
	[sortDescriptors addObject:sortDescriptor1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *ftc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																		  managedObjectContext:managedObjectContext
																			sectionNameKeyPath:nil 
																					 cacheName:nil];
	
	return ftc;
}

-(NSFetchedResultsController *)getFetchedResultsControllerForAssignmentsInClass:theClass {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MWSAssignment"
														 inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setFetchBatchSize:20];
	
	// filter the results for deleted
	NSPredicate *filterPredicate;
	//filterPredicate = [NSPredicate predicateWithFormat:@"(myClass != %@) and (deleted = 0)", theClass];
	filterPredicate = [NSPredicate predicateWithFormat:@"theClass = %@", theClass];
	[fetchRequest setPredicate:filterPredicate];
	
	
	// set up sort 
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor1;
	sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"assignmentDate" ascending:NO];
	[sortDescriptors addObject:sortDescriptor1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *ftc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																		  managedObjectContext:managedObjectContext
																			sectionNameKeyPath:nil 
																					 cacheName:nil];
	
	return ftc;
}

-(BOOL)hasChanges {
	if ([managedObjectContext hasChanges]) {
		return YES;
	} else {
		return NO;
	}

}

-(void)saveContext {
	NSManagedObjectContext *moc = managedObjectContext;
	NSError *error;
	[moc save:&error];
	if (! [moc save:&error]) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save context failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
	}
}

-(void)abandonChanges {
	NSManagedObjectContext *moc = managedObjectContext;
	[moc rollback];
}

-(void)deleteTest:(MWSTest *)testToDelete {
	NSManagedObjectContext *moc = managedObjectContext;
	[moc deleteObject:testToDelete];
	[self saveContext];
}

@end
