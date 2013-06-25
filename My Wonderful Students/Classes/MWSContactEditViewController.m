//
//  MWSContactEditViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/19/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSContactEditViewController.h"
#import "MWSCoreDataManager.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"
#import "MWSClass.h"

@implementation MWSContactEditViewController

@synthesize contact, student;

#pragma mark -
#pragma mark init

- (id)initWithContact:(MWSContact *)aContact forStudent:(MWSStudent *)aStudent {
    if (self = [self initWithNibName:@"MWSContactEditViewController" bundle:nil]) {
        
        // save the student
        student = aStudent;
        
        // save the contact
        contact = aContact;
        
        if (contact == nil) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"New Contact initialization failed"
                                      message:@"New Contact initialization failed"
                                      delegate:nil
                                      cancelButtonTitle:@"Got it!"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        // title
        if (([student firstName] == nil) && ([student lastName] == nil)) {
            [self setTitle:@"Parent/Contact"];
        } else {
            [self setTitle:[NSString stringWithFormat:@"%@ %@",
                            ([student firstName] == nil ? @"" : [student firstName]),
                            ([student lastName] == nil ? @"" : [student lastName])]];
        }
        
        // the new button
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
        
        // put the tool bar in the nav bar
        [[self navigationItem] setRightBarButtonItem:buttonItem];
    }
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle

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
    if (section == 0) {
		return 2;
	} else if (section == 1) {
		return 4;
	} else if (section == 2) {
		return 4;
	}
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Contact Info",@"Contact Info");
	} else if (section == 1) {
		return NSLocalizedString(@"Contact Type",@"Contact Type");
	} else {
		return NSLocalizedString(@"Settings",@"Settings");
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	AVMLeftLabelAndTextEntryTableCell *aLeftLabelAndTextEntryTableCell;
	UITableViewCell *cell = nil;
	
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"First Name",@"The First Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [contact firstName];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.autocapitalizationType = UITextAutocapitalizationTypeWords;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([indexPath row] == 1) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Last Name",@"The Last Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [contact lastName];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.autocapitalizationType = UITextAutocapitalizationTypeWords;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		}
	}
	
	if ([indexPath section] == 1) {
		if ([indexPath row] == 0) {
			static NSString *CellIdentifier = @"Cell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:@"Notify by Email"];
			if (([contact notifyByEmail] == nil) || ([[contact notifyByEmail] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			
		} else if ([indexPath row] == 1) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Email address",@"Email address");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [contact email];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = 10;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			aLeftLabelAndTextEntryTableCell.txtEntry.keyboardType = UIKeyboardTypeEmailAddress;
			return aLeftLabelAndTextEntryTableCell;
			
		}else if ([indexPath row] == 2) {
			static NSString *CellIdentifier = @"Cell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:@"Notify by Text"];
			if (([contact notifyByText] == nil) || ([[contact notifyByText] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}else if ([indexPath row] == 3) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Text number",@"Text number");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [contact textNumber];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = 11;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			aLeftLabelAndTextEntryTableCell.txtEntry.keyboardType = UIKeyboardTypePhonePad;
			return aLeftLabelAndTextEntryTableCell;
		}
		
		return cell;
	}
	
	if ([indexPath section] == 2) {
		static NSString *CellIdentifier = @"Cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		if ([indexPath row] == 0) {
			[[cell textLabel]  setText:@"Notify on Attendance"];
			if (([contact notifyForAttendance] == nil) || ([[contact notifyForAttendance] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		} else if ([indexPath row] == 1) {
			[[cell textLabel]  setText:@"Notify on Tests"];
			if (([contact notifyForTests] == nil) || ([[contact notifyForTests] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		} else if ([indexPath row] == 2) {
			[[cell textLabel]  setText:@"Notify on Assignments"];
			if (([contact notifyForAssignments] == nil) || ([[contact notifyForAssignments] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		} else if ([indexPath row] == 3) {
			[[cell textLabel]  setText:@"Notify on Conduct"];
			if (([contact notifyForConduct] == nil) || ([[contact notifyForConduct] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
		return cell;
	}
	
	return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (contact == nil) {
		return;
	}
	switch ([textField tag]) {
		case 1:
			[contact setFirstName:[textField text]];
			break;
		case 2:
			[contact setLastName:[textField text]];
			break;
		case 10:
			[contact setEmail:[textField text]];
			break;
		case 11:
			[contact setTextNumber:[textField text]];
			break;
		default:
			break;
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

-(void)save {
	[self findAndResignFirstResponder];
	if ([self contactIsValid]) {
		[[MWSCoreDataManager sharedInstance] saveContext];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Validation

- (BOOL)contactIsValid {
	if (([contact firstName] == nil) || ([[contact firstName] length] == 0)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"No First Name",@"No First Name Entered") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
	return YES;
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
	
	if ([indexPath section] == 1) {
		switch ([indexPath row]) {
			case 0:
				// tapped the notify by email
				if ([[contact notifyByEmail] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[contact setNotifyByEmail:[NSNumber numberWithInt:1]];
				} else {
					[contact setNotifyByEmail:[NSNumber numberWithInt:0]];
				}
				break;
			case 2:
				// tapped the Notify by text
				if ([[contact notifyByText] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[contact setNotifyByText:[NSNumber numberWithInt:1]];
					if ([[[[student myClass] myTeacher] showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
						UIAlertView *alertView = [[UIAlertView alloc] 
												  initWithTitle:NSLocalizedString(@"Information!",@"Information!") 
												  message:@"Remember when sending texts this person will have your phone number."
												  delegate:nil 
												  cancelButtonTitle:@"Got it!" 
												  otherButtonTitles:nil];
						[alertView show];
					}
				} else {
					[contact setNotifyByText:[NSNumber numberWithInt:0]];
				}
				break;
			default:
				break;
		}
	}
	if ([indexPath section] == 2) {
		switch ([indexPath row]) {
			case 0:
				// tapped the Attendance row
				if ([[contact notifyForAttendance] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[contact setNotifyForAttendance:[NSNumber numberWithInt:1]];
				} else {
					[contact setNotifyForAttendance:[NSNumber numberWithInt:0]];
				}
				break;
			case 1:
				// tapped the Tests row
				if ([[contact notifyForTests] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[contact setNotifyForTests:[NSNumber numberWithInt:1]];
				} else {
					[contact setNotifyForTests:[NSNumber numberWithInt:0]];
				}
				break;
			case 2:
				// tapped the Tests row
				if ([[contact notifyForAssignments] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[contact setNotifyForAssignments:[NSNumber numberWithInt:1]];
				} else {
					[contact setNotifyForAssignments:[NSNumber numberWithInt:0]];
				}
				break;
			case 3:
				// tapped the Conduct row
				if ([[contact notifyForConduct] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
					[contact setNotifyForConduct:[NSNumber numberWithInt:1]];
				} else {
					[contact setNotifyForConduct:[NSNumber numberWithInt:0]];
				}
				break;
			default:
				break;
		}
	}
	[tableView reloadData];
    	
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

