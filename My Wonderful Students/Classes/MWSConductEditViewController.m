//
//  MWSConductEditViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSConductEditViewController.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"
#import "MWSCoreDataManager.h"
#import "EmailSender.h"
#import "TextSender.h"
#import "MWSClass.h"
#import "MWSTeacher.h"

@implementation MWSConductEditViewController
@synthesize theConduct, theStudent, theDatePicker, savedTextRecipients, savedMessage;

#pragma mark -
#pragma mark View lifecycle

-(id)initWithConduct:(MWSConduct *)aConduct forStudent:(MWSStudent *)aStudent {
    
    if (self = [self initWithNibName:@"MWSConductEditViewController" bundle:nil]) {
        
        if (aConduct == nil) {
            MWSConduct *cndct = [[MWSCoreDataManager sharedInstance] newConduct];
            [cndct setDate:[NSDate date]];
            [cndct setDeleted:[NSNumber numberWithInt:0]];
            [cndct setSendNotification:[NSNumber numberWithInt:0]];
            [cndct setRate:[NSNumber numberWithInt:2]];
            [cndct setStudent:aStudent];
            NSMutableArray *workArray = [NSMutableArray arrayWithCapacity:[[aStudent conduct] count] + 1];
            [workArray addObjectsFromArray:[NSArray arrayWithArray:[[aStudent conduct] allObjects]]];
            [workArray addObject:cndct];
            [aStudent setConduct:[NSSet setWithArray:workArray]];
            [self setTheConduct:cndct];
        } else {
            [self setTheConduct:aConduct];
        }
        
        [self setTheStudent:aStudent];
        
        // put the tool bar in the nav bar
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
        [[self navigationItem] setRightBarButtonItem:buttonItem];
    }
	
	return self;
	
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
- (void)viewWillDisappear:(BOOL)animated {
	[[MWSCoreDataManager sharedInstance] abandonChanges];
    [super viewWillDisappear:animated];
}
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
		case 0:
			return 2;
			break;
		case 1:
			return 3;
			break;
		case 2:
			//return 2;
			return 1;
			break;
		default:
			return 0;
			break;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Conduct",@"Conduct");
	} else if (section == 1) {
		return NSLocalizedString(@"Rate conduct",@"Rate conduct");
	} else {
		return NSLocalizedString(@"Conduct settings",@"Conduct settings");
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath section]) {
		case 0:
			if ([indexPath row] == 0) {
				return 44;
			} else {
				return 132;
			}
			break;
		default:
			return 44;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;

    if ([indexPath section] == 0) {
		if ([indexPath row] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"MM-dd-yyyy"];
			NSString *hdr = @"Conduct Date ";
			[[cell textLabel] setText:[hdr stringByAppendingString:[df stringFromDate:[theConduct date]]]];
			return cell;
		} else if ([indexPath row] == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			
			UITextView *conductTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 132)];
			conductTextView.textColor = [UIColor blackColor];
            conductTextView.keyboardType = UIKeyboardTypeDefault;
            conductTextView.returnKeyType = UIReturnKeyDone;
			conductTextView.backgroundColor = [UIColor whiteColor];
			conductTextView.autocorrectionType = UITextAutocorrectionTypeNo;
			conductTextView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            [cell textLabel].textAlignment = NSTextAlignmentCenter;
			[conductTextView setDelegate:self];
			[conductTextView setTag:10];
			[conductTextView setText:[theConduct conductText]];
			[cell addSubview:conductTextView];
			
			return cell;
		}
	}
    
    if ([indexPath section] == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		if ([indexPath row] == 0) {
			[[cell textLabel]  setText:NSLocalizedString(@"Good",@"Good")];
			if ([[theConduct rate] compare:[NSNumber numberWithInt:3]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		} else if ([indexPath row] == 1) {
			[[cell textLabel]  setText:NSLocalizedString(@"Neutral",@"Niether")];
			if ([[theConduct rate] compare:[NSNumber numberWithInt:2]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		} else if ([indexPath row] == 2) {
			[[cell textLabel]  setText:NSLocalizedString(@"Bad",@"Bad")];
			if ([[theConduct rate] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	}
	
    if ([indexPath section] == 2) 
	{ 
		if ([indexPath row] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Send notification(s) now!",@"Send notification(s) now!")];
			if ([[theConduct sendNotification] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		} else if ([indexPath row] == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Delete conduct",@"Delete conduct")];
			if ([[theConduct deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	}
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (savedTextRecipients) {
		[[TextSender sharedInstance] sendTextTo:savedTextRecipients 
										message:savedMessage 
								 withController:self];
		savedMessage = nil;
		savedTextRecipients = nil;
		[self findAndResignFirstResponder];
		[[self tableView] reloadData];
		return;
	}
	
	if (([indexPath section] == 0) && ([indexPath row] == 0)) {
			NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
			theDatePicker = [[UIDatePicker alloc] init];
			theDatePicker.datePickerMode = UIDatePickerModeDate;
			[theDatePicker setFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
			
			[formatter1 setLenient:YES];
			[formatter1 setDateStyle:NSDateFormatterShortStyle];
			
			NSString *maxDateString = @"05-05-2015";
			NSString *minDateString = @"01-01-1999";
			NSDate* maxDate = [formatter1 dateFromString:maxDateString];
			NSDate* minDate = [formatter1 dateFromString:minDateString];
			theDatePicker.minimumDate = minDate;
			theDatePicker.maximumDate = maxDate;
			
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Set Date" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
			[actionSheet bringSubviewToFront:theDatePicker];
			[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
			[actionSheet showInView:[self.view superview]];
			[actionSheet addSubview:theDatePicker];
			[actionSheet sendSubviewToBack:theDatePicker];
			[actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
			[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
			[actionSheet setTag:11];
		}
		
		if ([indexPath section] == 1) {
			if ([indexPath row] == 0) {
				[theConduct setRate:[NSNumber numberWithInt:3]];
			}
			if ([indexPath row] == 1) {
				[theConduct setRate:[NSNumber numberWithInt:2]];
			}
			if ([indexPath row] == 2) {
				[theConduct setRate:[NSNumber numberWithInt:1]];
			}
			
		}
		
		if ([indexPath section] == 2) {
			if ([indexPath row] == 0) {
				if (! [self conductIsValid]) {
					[self resignFirstResponder];
					[[self tableView] reloadData];
					return;
				}
				if ([[theConduct sendNotification] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[theConduct setSendNotification:[NSNumber numberWithInt:1]];
					[[MWSCoreDataManager sharedInstance] saveContext];
					
					// send notifications
					MWSClass *theClass = [theStudent myClass];
					if ([[theClass sendConductNotification] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
						NSMutableArray *emailRecipients = [[NSMutableArray alloc] init];
						savedTextRecipients = [[NSMutableArray alloc] init];
						
						if ([theStudent firstContact]) {
							if ([[[theStudent firstContact] notifyForConduct] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
								if (([[[theStudent firstContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
									&& ([[theStudent firstContact] email])) {
									[emailRecipients addObject:[[theStudent firstContact] email]];
								}
								if (([[[theStudent firstContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
									&& ([[theStudent firstContact] textNumber])) {
									[savedTextRecipients addObject:[[theStudent firstContact] textNumber]];
								}
							}
						}
						if ([theStudent secondContact]) {
							if ([[[theStudent secondContact] notifyForConduct] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
								if (([[[theStudent secondContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
									&& ([[theStudent secondContact] email])) {
									[emailRecipients addObject:[[theStudent secondContact] email]];
								}
								if (([[[theStudent secondContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
									&& ([[theStudent secondContact] textNumber])) {
									[savedTextRecipients addObject:[[theStudent secondContact] textNumber]];
								}
							}
						}
						if ([theStudent otherContact]) {
							if ([[[theStudent otherContact] notifyForConduct] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
								if (([[[theStudent otherContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
									&& ([[theStudent otherContact] email])) {
									[emailRecipients addObject:[[theStudent otherContact] email]];
								}
								if (([[[theStudent otherContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
									&& ([[theStudent otherContact] textNumber])) {
									[savedTextRecipients addObject:[[theStudent otherContact] textNumber]];
								}
							}
						}
						if ([[theStudent principalNotify] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
							if ([[theClass myTeacher] principalEmail]) {
								[emailRecipients addObject:[[theClass myTeacher] principalEmail]];
							}
						}
						NSString *message = [NSString stringWithFormat:@"%@ %@ conduct: %@ in %@ class.", 
											 [theStudent firstName], 
											 [theStudent lastName],
											 [theConduct conductText], 
											 [theClass myClassName]];
						savedMessage = message;
						
						if ([emailRecipients count] > 0) {
							// got emails to send and no text messages to send
							[[EmailSender sharedInstance] sendEmailTo:emailRecipients 
															  subject:@"Conduct Notification" 
															  message:message 
													   withController:self];
						} 
						
						if ([savedTextRecipients count] == 0) {
							savedTextRecipients = nil;
						} else {
							UIAlertView *alertView = [[UIAlertView alloc] 
													  initWithTitle:NSLocalizedString(@"Information!",@"Information!") 
													  message:@"Touch send notification again to send text message(s)."
													  delegate:nil 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
							[alertView show];
							savedMessage = message;
						}
					}
				} else {
					[theConduct setSendNotification:[NSNumber numberWithInt:0]];
				}
			}
			if ([indexPath row] == 1) {
				if ([[theConduct deleted] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[theConduct setDeleted:[NSNumber numberWithInt:1]];
				} else {
					[theConduct setDeleted:[NSNumber numberWithInt:0]];
				}
			}
	}
	
	[self findAndResignFirstResponder];
	[[self tableView] reloadData];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
	
	if (savedTextRecipients) {
		[[TextSender sharedInstance] sendTextTo:savedTextRecipients 
										message:savedMessage 
								 withController:self];
		savedMessage = nil;
		savedTextRecipients = nil;
		[self findAndResignFirstResponder];	
	}
}


-(void)textViewDidEndEditing:(UITextView *)textView {
	switch ([textView tag]) {
		case 10:
			[theConduct setConductText:[textView text]];
			break;
		default:
			break;
	}
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	[textView resignFirstResponder];
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ( [text isEqualToString:@"\n"] ) {
        [textView resignFirstResponder];
    }
	
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		if ([actionSheet tag] == 11) {
			NSDate *newDate = [theDatePicker date];
			[theConduct setDate:newDate];
			[[self tableView] reloadData];
		}
	}
}

-(void)save {
	if ([self conductIsValid]) {
		if (savedTextRecipients) {
			[[TextSender sharedInstance] sendTextTo:savedTextRecipients 
											message:savedMessage 
									 withController:self];
			savedMessage = nil;
			savedTextRecipients = nil;
			[self findAndResignFirstResponder];	
		}
		
		[[MWSCoreDataManager sharedInstance] saveContext];
	}
}

-(BOOL)conductIsValid {
	if (([theConduct conductText] == nil) || ([[theConduct conductText] length] == 0)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") 
															message:NSLocalizedString(@"No Conduct Text",@"No Conduct Text") 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
	return YES;
}

-(void)findAndResignFirstResponder {
	NSArray *subviews = [self.tableView subviews];
	
	for (id cell in subviews ) 
	{
		if ([cell isKindOfClass:[UITableViewCell class]]) 
		{
			UITableViewCell *aCell = cell;
			NSArray *cellContentViews = [[aCell contentView] subviews];
			for (id textField in cellContentViews) 
			{
				if ([textField isKindOfClass:[UITextField class]]) 
				{
					UITextField *theTextField = textField;
					if ([theTextField isFirstResponder]) {
						[theTextField resignFirstResponder];
					}
					
				}
			}
		}
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

