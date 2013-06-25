//
//  MWSConduct.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSStudent;

@interface MWSConduct :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * conductText;
@property (nonatomic, retain) NSNumber * sendNotification;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) MWSStudent * student;

@end



