//
//  MWSTest.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSClass;
@class MWSStudentTest;

@interface MWSTest :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * sendNotification;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * letterGrade;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * passFail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numericGrade;
@property (nonatomic, retain) NSSet* studentTests;
@property (nonatomic, retain) MWSClass * myClass;

@end


@interface MWSTest (CoreDataGeneratedAccessors)
- (void)addStudentTestsObject:(MWSStudentTest *)value;
- (void)removeStudentTestsObject:(MWSStudentTest *)value;
- (void)addStudentTests:(NSSet *)value;
- (void)removeStudentTests:(NSSet *)value;

@end

