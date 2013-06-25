//
//  MWSTeacherCell.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSTeacher.h"
#import "MWSClassesListViewController.h"

@class MWSTeacher;

@interface MWSTeacherCell : UITableViewCell {
	
	IBOutlet UILabel *teacherName;

}
@property (nonatomic, retain) IBOutlet UILabel *teacherName;

+ (NSString *)reuseIndentifier;

@end
