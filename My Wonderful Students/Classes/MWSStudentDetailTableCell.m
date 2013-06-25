//
//  MWSStudentDetailTableCell.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/5/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentDetailTableCell.h"


@implementation MWSStudentDetailTableCell
@synthesize labelOutlet1, labelOutlet2, labelOutlet3, labelOutlet4, labelOutlet5, labelOutlet6;

#pragma mark -
#pragma mark  UI Helpers

static NSString *reuseIdentifier_ = @"MWSStudentDetailTableCell";

+ (NSString *)reuseIndentifier {
	return reuseIdentifier_;
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIndentifier];
}

@end

