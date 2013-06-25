//
//  AVMLeftLabelAndTextEntryTableCell.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/12/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "AVMLeftLabelAndTextEntryTableCell.h"


@implementation AVMLeftLabelAndTextEntryTableCell
@synthesize leftLabel;
@synthesize txtEntry;

#pragma mark -
#pragma mark  UI Helpers

static NSString *reuseIdentifier_ = @"AVMLeftLabelAndTextEntryTableCell";

+ (NSString *)reuseIndentifier {
	return reuseIdentifier_;
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIndentifier];
}

@end

