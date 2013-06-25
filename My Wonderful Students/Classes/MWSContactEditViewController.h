//
//  MWSContactEditViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/19/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSContact.h"
#import "MWSStudent.h"

@interface MWSContactEditViewController : UITableViewController  <UITextFieldDelegate> {
	
}

@property (nonatomic, retain) MWSContact *contact; 
@property (nonatomic, retain) MWSStudent *student;

- (id)initWithContact:(MWSContact *)aContact forStudent:(MWSStudent *)aStudent;
- (BOOL)contactIsValid;
- (void)findAndResignFirstResponder;

@end
