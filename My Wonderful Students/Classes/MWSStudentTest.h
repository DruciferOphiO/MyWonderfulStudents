//
//  MWSStudentTest.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSStudent;
@class MWSTest;

@interface MWSStudentTest :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * grade;
@property (nonatomic, retain) MWSStudent * student;
@property (nonatomic, retain) MWSTest * test;

@end



