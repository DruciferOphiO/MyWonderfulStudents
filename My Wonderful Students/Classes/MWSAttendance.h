//
//  MWSAttendance.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSStudent;

@interface MWSAttendance :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * notify;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isPresent;
@property (nonatomic, retain) NSNumber * isChanged;
@property (nonatomic, retain) NSNumber * notifySent;
@property (nonatomic, retain) MWSStudent * student;

@end



