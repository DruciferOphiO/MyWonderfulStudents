//
//  MWSStudentStatusTableCell.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MWSStudentStatusTableCell : UITableViewCell {
	
	IBOutlet UILabel *studentName;
	IBOutlet UILabel *attendanceIndicator;
	IBOutlet UILabel *testsIndicator;
	IBOutlet UILabel *conductIndicator;
	IBOutlet UILabel *assignmentsIndicator;

}
@property (nonatomic, retain) IBOutlet UILabel *studentName;
@property (nonatomic, retain) IBOutlet UILabel *attendanceIndicator;
@property (nonatomic, retain) IBOutlet UILabel *testsIndicator;
@property (nonatomic, retain) IBOutlet UILabel *conductIndicator;
@property (nonatomic, retain) IBOutlet UILabel *assignmentsIndicator;

+ (NSString *)reuseIndentifier;

@end
