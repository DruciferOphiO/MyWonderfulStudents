//
//  MWSLabelTableCell.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/20/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MWSLabelTableCell : UITableViewCell {
	
	IBOutlet UILabel *cellLabel;
	
}
@property (nonatomic, retain) IBOutlet UILabel *cellLabel;

+ (NSString *)reuseIndentifier;

@end
