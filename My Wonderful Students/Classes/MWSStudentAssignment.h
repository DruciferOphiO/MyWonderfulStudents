//
//  MWSStudentAssignment.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSAssignment;
@class MWSStudent;

@interface MWSStudentAssignment :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) MWSStudent * student;
@property (nonatomic, retain) MWSAssignment * assignment;

@end



