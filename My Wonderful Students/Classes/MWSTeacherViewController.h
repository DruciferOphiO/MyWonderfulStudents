//
//  MWSTeacherViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSTeacher.h"


@interface MWSTeacherViewController : UITableViewController <UITextFieldDelegate> {
	
}

@property (nonatomic, retain) UIToolbar *buttonContainer;
@property (nonatomic, retain) UIBarButtonItem *buttonItem;
@property (nonatomic, retain) MWSTeacher *teacher;
@property (nonatomic, assign) int helpIndex;

-(id)initWithTeacher:(MWSTeacher *)aTeacher;
-(void)findAndResignFirstResponder;
-(void)save;
-(BOOL)isValid;
-(void)helpMe;

@end
