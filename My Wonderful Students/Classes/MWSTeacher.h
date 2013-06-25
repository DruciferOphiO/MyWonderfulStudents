//
//  MWSTeacher.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSAssignment;
@class MWSClass;

@interface MWSTeacher :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * copyMeOnEmails;
@property (nonatomic, retain) NSNumber * showDeletedClasses;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSNumber * showHelp;
@property (nonatomic, retain) NSString * nameSuffix;
@property (nonatomic, retain) NSString * principalEmail;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * showDeletedStudents;
@property (nonatomic, retain) NSSet* classes;
@property (nonatomic, retain) NSSet* assignments;

@end


@interface MWSTeacher (CoreDataGeneratedAccessors)
- (void)addClassesObject:(MWSClass *)value;
- (void)removeClassesObject:(MWSClass *)value;
- (void)addClasses:(NSSet *)value;
- (void)removeClasses:(NSSet *)value;

- (void)addAssignmentsObject:(MWSAssignment *)value;
- (void)removeAssignmentsObject:(MWSAssignment *)value;
- (void)addAssignments:(NSSet *)value;
- (void)removeAssignments:(NSSet *)value;

@end

