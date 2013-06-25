//
//  MWSTestEditViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/17/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSTestEditViewController.h"
#import "MWSCoreDataManager.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"

@implementation MWSTestEditViewController

@synthesize theTest, theClass, theDatePicker, helpIndex;

#pragma mark -
#pragma mark View lifecycle

-(id)initForTest:(MWSTest *)aTest inClass:(MWSClass *)aClass {
	if (self = [self initWithNibName:@"MWSTestEditViewController" bundle:nil]) {
        if (aTest == nil) {
            theTest = [[MWSCoreDataManager sharedInstance] newTest];
            [theTest setMyClass:aClass];
            [theTest setDate:[NSDate date]];
        } else {
            theTest = aTest;
        }
        
        theClass = aClass;
        
        [self setTitle:[aClass myClassName]];
        
        //            set the nav bar buttons
        // array to hold buttons
        // create the toolbar to place buttons
        UIToolbar *buttonContainer;
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
        // the help button
        if ([[[theClass myTeacher] showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
            buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
            UIImage *image = [UIImage imageNamed:@"help-icon.png"];
            UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc]
                                               initWithImage:image
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(helpMe)];
            [buttons addObject:helpButtonItem];
            // create a spacer between the buttons
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
            [buttons addObject:spacer];
        } else {
            buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
        }
        
        // put the tool bar in the nav bar
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                    target:self 
                                                                                    action:@selector(save)];
        [buttons addObject:buttonItem];
        
        if ([buttons count] > 0) {
            // put the buttons in the toolbar and release them
            [buttonContainer setItems:buttons animated:NO];
            // place the toolbar into the navigation bar
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithCustomView:buttonContainer];
        }
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)helpMe {
	UIAlertView *alertView;
	if (helpIndex > 2) helpIndex = 0;
	switch (helpIndex) {
		case 0:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch SAVE button to save test!",@"Touch SAVE button to save test!") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 1:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch test date to pick new date!",@"Touch test date to pick new date!") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 2:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch Test Type or Delete rows to toggle setting!",@"Touch Test Type or Delete rows to toggle setting!") 
												  delegate:nil  
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		default:
			break;
	}
	
	[alertView show];
}

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
    //return 3;
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return 3;
	} else if (section == 1) {
		return 3;
	} else if (section == 2) {
		return 1;
	}
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Test Info",@"Test Info");
	} else if (section == 1) {
		return NSLocalizedString(@"Test Type",@"Test Type");
	} else if (section == 2) {
		return @"Delete Test";
	}
	return @"";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AVMLeftLabelAndTextEntryTableCell *aLeftLabelAndTextEntryTableCell;
	UITableViewCell *cell = nil;
	static NSString *CellIdentifier = @"Cell";
	
	if ([indexPath section] == 0) {
		if ([indexPath row] == 0) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Test Name",@"The Test Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [theTest name];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([indexPath row] == 1) {			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"MM-dd-yyyy"];
			NSString *testDate = NSLocalizedString(@"Test date ",@"Test date ");
			[[cell textLabel] setText:[testDate stringByAppendingString:[df stringFromDate:[theTest date]]]];
            [cell textLabel].textAlignment = NSTextAlignmentCenter;
			return cell;
		} else if ([indexPath row] == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Send Notification",@"Send Notification")];
			if ([[theTest sendNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
	} else if ([indexPath section] == 1) {
		if ([indexPath row] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Numeric Grade",@"A Numberic Grade")];
			if ([[theTest numericGrade] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		} else if ([indexPath row] == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Letter Grade",@"A Letter Grade")];
			if ([[theTest letterGrade] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		} else if ([indexPath row] == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Pass/Fail",@"Either Pass/Fail")];
			if ([[theTest passFail] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
	} else if ([indexPath section] == 2) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		[[cell textLabel] setText:NSLocalizedString(@"Delete This Test",@"Delete This Test")];
		if ([[theTest deleted] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		} else {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	}
		
	return cell;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		
		NSDate *newDate = [theDatePicker date];
		[theTest setDate:newDate];
		[[self tableView] reloadData];
	}
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
	if ([indexPath section] == 0) {
		if ([indexPath row] == 1) {
			
			NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
			theDatePicker = [[UIDatePicker alloc] init];
			theDatePicker.datePickerMode = UIDatePickerModeDate;
			[theDatePicker setFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
			
			[formatter1 setLenient:YES];
			[formatter1 setDateStyle:NSDateFormatterShortStyle];
			
			NSString *maxDateString = @"11-01-2012";
			NSString *minDateString = @"01-01-2010";
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
			
			
			[self findAndResignFirstResponder];
		}
		if ([indexPath row] == 2) {
			if ([[theTest sendNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				[theTest setSendNotification:[NSNumber numberWithInt:1]];
			} else {
				[theTest setSendNotification:[NSNumber numberWithInt:0]];
			}
			[[self tableView] reloadData];
			return;
		}
	} else if ([indexPath section] == 1) {
		if ([indexPath row] == 0) {
			[theTest setNumericGrade:[NSNumber numberWithInt:1]];
			[theTest setLetterGrade:[NSNumber numberWithInt:0]];
			[theTest setPassFail:[NSNumber numberWithInt:0]];
		} else if ([indexPath row] == 1) {
			[theTest setNumericGrade:[NSNumber numberWithInt:0]];
			[theTest setLetterGrade:[NSNumber numberWithInt:1]];
			[theTest setPassFail:[NSNumber numberWithInt:0]];
		} else if ([indexPath row] == 2) {
			[theTest setNumericGrade:[NSNumber numberWithInt:0]];
			[theTest setLetterGrade:[NSNumber numberWithInt:0]];
			[theTest setPassFail:[NSNumber numberWithInt:1]];
		}
	} else if ([indexPath section] == 2) {
		if ([[theTest deleted] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theTest setDeleted:[NSNumber numberWithInt:1]];
		} else {
			[theTest setDeleted:[NSNumber numberWithInt:0]];
		}
		[[self tableView] reloadData];
		return;
	}
	[[self tableView] reloadData];
}

-(void)save {
	[self findAndResignFirstResponder];
	if ([self testIsValid]) {
		[[MWSCoreDataManager sharedInstance] saveContext];
		[self.navigationController popViewControllerAnimated:YES];
	}
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

-(BOOL)testIsValid {
	if (([theTest name] == nil) || ([[theTest name] length] == 0)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"No Test Name",@"No First Name Entered") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
	if ((([[theTest numericGrade] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) &&
		([[theTest letterGrade] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) && 
		([[theTest passFail] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"No Test type",@"No First Name Entered") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
	
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	switch ([textField tag]) {
		case 1:
			[theTest setName:[textField text]];
			break;
		case 2:
			//[theTest setDate:[textField text]];
			break;
		default:
			break;
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

