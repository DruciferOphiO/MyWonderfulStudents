//
//  MWSAssignment.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSClass;
@class MWSStudentAssignment;
@class MWSTeacher;

@interface MWSAssignment :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * sendNotification;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * assignmentText;
@property (nonatomic, retain) NSDate * assignmentDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) MWSClass * theClass;
@property (nonatomic, retain) NSSet* studentAssignments;
@property (nonatomic, retain) MWSTeacher * teacher;

@end


@interface MWSAssignment (CoreDataGeneratedAccessors)
- (void)addStudentAssignmentsObject:(MWSStudentAssignment *)value;
- (void)removeStudentAssignmentsObject:(MWSStudentAssignment *)value;
- (void)addStudentAssignments:(NSSet *)value;
- (void)removeStudentAssignments:(NSSet *)value;

@end

