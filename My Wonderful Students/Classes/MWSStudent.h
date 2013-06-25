//
//  MWSStudent.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSAttendance;
@class MWSClass;
@class MWSConduct;
@class MWSContact;
@class MWSStudentAssignment;
@class MWSStudentTest;

@interface MWSStudent :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * idNumber;
@property (nonatomic, retain) NSString * myClassName;
@property (nonatomic, retain) NSString * spclNeeds;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * principalNotify;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * healthAlert;
@property (nonatomic, retain) NSSet* assignments;
@property (nonatomic, retain) NSSet* tests;
@property (nonatomic, retain) MWSContact * firstContact;
@property (nonatomic, retain) MWSContact * secondContact;
@property (nonatomic, retain) MWSClass * myClass;
@property (nonatomic, retain) NSSet* conduct;
@property (nonatomic, retain) MWSContact * otherContact;
@property (nonatomic, retain) NSSet* attendance;

@end


@interface MWSStudent (CoreDataGeneratedAccessors)
- (void)addAssignmentsObject:(MWSStudentAssignment *)value;
- (void)removeAssignmentsObject:(MWSStudentAssignment *)value;
- (void)addAssignments:(NSSet *)value;
- (void)removeAssignments:(NSSet *)value;

- (void)addTestsObject:(MWSStudentTest *)value;
- (void)removeTestsObject:(MWSStudentTest *)value;
- (void)addTests:(NSSet *)value;
- (void)removeTests:(NSSet *)value;

- (void)addConductObject:(MWSConduct *)value;
- (void)removeConductObject:(MWSConduct *)value;
- (void)addConduct:(NSSet *)value;
- (void)removeConduct:(NSSet *)value;

- (void)addAttendanceObject:(MWSAttendance *)value;
- (void)removeAttendanceObject:(MWSAttendance *)value;
- (void)addAttendance:(NSSet *)value;
- (void)removeAttendance:(NSSet *)value;

@end

