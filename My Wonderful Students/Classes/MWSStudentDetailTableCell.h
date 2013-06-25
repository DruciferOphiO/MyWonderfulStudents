//
//  MWSStudentDetailTableCell.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/5/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MWSStudentDetailTableCell :  UITableViewCell {
	
	IBOutlet UILabel *labelOutlet1;
	IBOutlet UILabel *labelOutlet2;
	IBOutlet UILabel *labelOutlet3;
	IBOutlet UILabel *labelOutlet4;
	IBOutlet UILabel *labelOutlet5;
	IBOutlet UILabel *labelOutlet6;
	
}

@property (nonatomic, retain) IBOutlet UILabel *labelOutlet1;
@property (nonatomic, retain) IBOutlet UILabel *labelOutlet2;
@property (nonatomic, retain) IBOutlet UILabel *labelOutlet3;
@property (nonatomic, retain) IBOutlet UILabel *labelOutlet4;
@property (nonatomic, retain) IBOutlet UILabel *labelOutlet5;
@property (nonatomic, retain) IBOutlet UILabel *labelOutlet6;

+ (NSString *)reuseIndentifier;

@end
