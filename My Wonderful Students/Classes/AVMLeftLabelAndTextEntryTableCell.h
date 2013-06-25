//
//  AVMLeftLabelAndTextEntryTableCell.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/12/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AVMLeftLabelAndTextEntryTableCell : UITableViewCell {
	
	IBOutlet UILabel *leftLabel;
	IBOutlet UITextField *txtEntry;
	
}
@property (nonatomic, retain) IBOutlet UILabel *leftLabel;
@property (nonatomic, retain) IBOutlet UITextField *txtEntry;

+ (NSString *)reuseIndentifier;
@end
