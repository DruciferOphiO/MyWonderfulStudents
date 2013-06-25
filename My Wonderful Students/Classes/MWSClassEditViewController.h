//
//  MWSClassEditViewController.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSTeacher.h"
#import "MWSClass.h"


@interface MWSClassEditViewController : UITableViewController  <UITextFieldDelegate> {
	
}

@property (nonatomic, retain) MWSTeacher *teacher;
@property (nonatomic, retain) MWSClass *theClass;

-(id)initClassWithTeacher:(MWSTeacher *)aTeacher forClassName:(NSString *)theClassName;
-(BOOL)classIsValid;
-(void)findAndResignFirstResponder;
-(void)helpMe;

@end
