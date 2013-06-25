//
//  MWSClass.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSAssignment;
@class MWSStudent;
@class MWSTeacher;
@class MWSTest;

@interface MWSClass :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * sendAssignmentNotification;
@property (nonatomic, retain) NSNumber * showDeletedTests;
@property (nonatomic, retain) NSString * myClassName;
@property (nonatomic, retain) NSNumber * sendConductNotification;
@property (nonatomic, retain) NSNumber * showDeletedAssignments;
@property (nonatomic, retain) NSNumber * sendTestNotification;
@property (nonatomic, retain) NSNumber * sendAttendanceNotification;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * sortBy;
@property (nonatomic, retain) NSNumber * showDeletedConducts;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSNumber * showDeletedStudents;
@property (nonatomic, retain) NSSet* students;
@property (nonatomic, retain) NSSet* tests;
@property (nonatomic, retain) MWSTeacher * myTeacher;
@property (nonatomic, retain) NSSet* assignments;

@end


@interface MWSClass (CoreDataGeneratedAccessors)
- (void)addStudentsObject:(MWSStudent *)value;
- (void)removeStudentsObject:(MWSStudent *)value;
- (void)addStudents:(NSSet *)value;
- (void)removeStudents:(NSSet *)value;

- (void)addTestsObject:(MWSTest *)value;
- (void)removeTestsObject:(MWSTest *)value;
- (void)addTests:(NSSet *)value;
- (void)removeTests:(NSSet *)value;

- (void)addAssignmentsObject:(MWSAssignment *)value;
- (void)removeAssignmentsObject:(MWSAssignment *)value;
- (void)addAssignments:(NSSet *)value;
- (void)removeAssignments:(NSSet *)value;

@end

