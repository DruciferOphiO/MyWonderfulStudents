//
//  MWSStudentStatusTableCell.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentStatusTableCell.h"
#import "MWSStudent.h"

@implementation MWSStudentStatusTableCell
@synthesize studentName;
@synthesize attendanceIndicator;
@synthesize testsIndicator;
@synthesize conductIndicator;
@synthesize assignmentsIndicator;

#pragma mark -
#pragma mark  UI Helpers

static NSString *reuseIdentifier_ = @"MWSStudentStatusTableCell";

+ (NSString *)reuseIndentifier {
	return reuseIdentifier_;
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIndentifier];
}


@end

