//
//  MWSContact.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MWSStudent;

@interface MWSContact :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * notifyForAssignments;
@property (nonatomic, retain) NSNumber * isChanged;
@property (nonatomic, retain) NSNumber * notifyForConduct;
@property (nonatomic, retain) NSString * textNumber;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * notifyForTests;
@property (nonatomic, retain) NSNumber * notifyByText;
@property (nonatomic, retain) NSNumber * notifyForAttendance;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * notifyByEmail;
@property (nonatomic, retain) MWSStudent * firstContact;
@property (nonatomic, retain) MWSStudent * secondContact;
@property (nonatomic, retain) MWSStudent * otherContact;

@end



