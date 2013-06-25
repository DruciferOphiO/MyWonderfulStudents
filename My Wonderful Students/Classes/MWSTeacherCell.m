//
//  MWSTeacherCell.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MWSTeacherCell.h"
#import "MWSTeacher.h"

@implementation MWSTeacherCell
@synthesize teacherName;

#pragma mark -
#pragma mark  UI Helpers

static NSString *reuseIdentifier_ = @"MWSTeacherCell";

+ (NSString *)reuseIndentifier {
	return reuseIdentifier_;
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIndentifier];
}



@end
