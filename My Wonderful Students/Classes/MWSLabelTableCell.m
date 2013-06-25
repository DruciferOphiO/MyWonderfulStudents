//
//  MWSLabelTableCell.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/20/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSLabelTableCell.h"


@implementation MWSLabelTableCell
@synthesize cellLabel;

#pragma mark -
#pragma mark  UI Helpers

static NSString *reuseIdentifier_ = @"MWSLabelTableCell";

+ (NSString *)reuseIndentifier {
	return reuseIdentifier_;
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIndentifier];
}



@end
