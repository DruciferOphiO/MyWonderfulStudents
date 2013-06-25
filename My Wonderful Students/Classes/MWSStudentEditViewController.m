//
//  MWSStudentEditViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentEditViewController.h"
#import "MWSCoreDataManager.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"
#import "MWSContactEditViewController.h"

@implementation MWSStudentEditViewController
@synthesize buttonContainer, buttonItem, theClass, student, abandonUpdates, helpIndex;

#pragma mark -
#pragma mark init

- (id)initStudent:aStudent forClassName:aClass  {
	
	if (self = [self initWithNibName:@"MWSStudentEditViewController" bundle:nil]) {
		
		// save the class
		theClass = aClass;
		
		// if Student is nil, create one
		student = nil;
		if (aStudent == nil) {
			[self setStudent:[[MWSCoreDataManager sharedInstance] newStudent]];
			[[self student] setMyClass:theClass];
			[[self student] setMyClassName:[theClass myClassName]];
		} else {
			[self setStudent:aStudent];
		}
		
		// title
		[self setTitle:[theClass myClassName]];
		
		abandonUpdates = YES;
		
		// array to hold buttons
		NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
		
		if ([[[theClass myTeacher] showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 150, 45)];
			UIImage *image = [UIImage imageNamed:@"help-icon.png"];
			UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc] 
											   initWithImage:image 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(helpMe)];
			[buttons addObject:helpButtonItem];
		} else {
			buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
		}
		
		// the search button
		UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
										 initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
										 target:self
										 action:@selector(search)];
		searchButton.style = UIBarButtonItemStyleBordered;
		[buttons addObject:searchButton];
		
		// the save button
		buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
		[buttons addObject:buttonItem];
		
		// put the buttons in the toolbar and release them
		[buttonContainer setItems:buttons animated:NO];
		
		// place the toolbar into the navigation bar
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
												  initWithCustomView:buttonContainer];
		
	}
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle
-(void)save {
	[self findAndResignFirstResponder];
	if ([self studentIsValid]) {
		NSMutableArray *newStudentsList = [NSMutableArray arrayWithArray:[[theClass	students] allObjects]];
		[newStudentsList addObject:student];
		[student setMyClass:theClass];
		[theClass setStudents:[NSSet setWithArray:newStudentsList]];
		[[MWSCoreDataManager sharedInstance] saveContext];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void)search {
	MWSStudentSearchViewController *searchView = [[MWSStudentSearchViewController alloc] initForClass:theClass withDelegate:self];
	[self.navigationController pushViewController:searchView animated:YES];
}


#pragma mark -
#pragma mark Validation

- (BOOL)studentIsValid {
	if (([student lastName] == nil) || ([[student lastName] length] == 0)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"",@"Validation Message") message:NSLocalizedString(@"No Student Last Name",@"No Student Name Entered") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
	return YES;
}


#pragma mark -
#pragma mark View lifecycle

-(void)helpMe {
	UIAlertView *alertView;
	if (helpIndex > 2) helpIndex = 0;
	switch (helpIndex) {
		case 0:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch SAVE button to save student info.!",@"Touch SAVE button to save student info.!") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 1:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch hour glass to get student from another class.",@"Touch hour glass to get student from another class.") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 2:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch Contacts to add or edit contact info.",@"Touch Contacts to add or edit contact info.") 
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
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[[self tableView] reloadData];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	
	if (abandonUpdates) {
		if ([[MWSCoreDataManager sharedInstance] hasChanges]) {
			[[MWSCoreDataManager sharedInstance] abandonChanges];
		}
	} else {
		abandonUpdates = YES;
	}
	//student = nil;
	//theClass = nil;
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
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return 4;
	} else if (section == 1) {
		return 4;
	} else if (section == 2) {
		return 2;
	} else {
		return 1;
	}

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Student Info",@"Student Info");
	} else if (section == 1) {
		return NSLocalizedString(@"Contacts",@"Contacts");
	} else if (section == 2) {
		return NSLocalizedString(@"Other Info",@"Other Info");
	} else {
		return NSLocalizedString(@"Settings",@"Settings");
	}
	
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	AVMLeftLabelAndTextEntryTableCell *aLeftLabelAndTextEntryTableCell;
	UITableViewCell *cell;
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"First Name",@"The First Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [student firstName];
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
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [student lastName];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.autocapitalizationType = UITextAutocapitalizationTypeWords;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([indexPath row] == 2) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"ID",@"The ID Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [student idNumber];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Student Email",@"Student Email");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [student email];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			aLeftLabelAndTextEntryTableCell.txtEntry.keyboardType = UIKeyboardTypeEmailAddress;
			return aLeftLabelAndTextEntryTableCell;
		}

	} else if ([indexPath section] == 1) {
		if ([indexPath row] != 3) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			if ([indexPath row] == 0) {
				if ([student firstContact] == nil) {
					[[cell textLabel] setText:@"Parent 1"];
				} else {
					if (([[student firstContact] firstName]) && ([[student firstContact] lastName])) {
						[[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",
												   [[student firstContact] firstName],
												   [[student firstContact] lastName]]];
					} else {
						[[cell textLabel] setText:@"Parent 1"];
					}
				}
			} else if ([indexPath row] == 1) {
				if ([student secondContact] == nil) {
					[[cell textLabel] setText:@"Parent 2"];
				} else {
					if (([[student secondContact] firstName]) && ([[student secondContact] lastName])) {
						[[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",
												   [[student secondContact] firstName],
												   [[student secondContact] lastName]]];
					} else {
						[[cell textLabel] setText:@"Parent 2"];
					}
				}
			} else if ([indexPath row] == 2) {
				if ([student otherContact] == nil) {
					[[cell textLabel] setText:@"Other Contact"];
				} else {
					if (([[student otherContact] firstName]) && ([[student otherContact] lastName])) {
						[[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",
												   [[student otherContact] firstName],
												   [[student otherContact] lastName]]];
					} else {
						[[cell textLabel] setText:@"Other Contact"];
					}
				}
			}
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return cell;
		} else {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Notify Principal",@"Notify Principal")];
			if ([[student principalNotify] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			return cell;
		}

	} else if ([indexPath section] == 2) {
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Health Alert",@"Health Alert");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [student healthAlert];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 21;
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Special Needs",@"Special Needs");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [student spclNeeds];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 21;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		}
	} else if ([indexPath section] == 3) {
		if ([indexPath row] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Delete this student.",@"Delete this student.")];
			if ([[student deleted] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			return cell;
		}
	}

	return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([self student] == nil) {
		return;
	}
	switch ([textField tag]) {
		case 1:
			[student setFirstName:[textField text]];
			break;
		case 2:
			[student setLastName:[textField text]];
			break;
		case 3:
			[student setIdNumber:[textField text]];
			break;
		case 4:
			[student setEmail:[textField text]];
			break;
		case 21:
			[student setHealthAlert:[textField text]]; 
			break;
		case 22:
			[student setSpclNeeds:[textField text]]; 
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
    
	MWSContact *theContact;
	if ([indexPath section] == 1) {
		if ([self studentIsValid]) {
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else {
			[self findAndResignFirstResponder];
		}
		if ([indexPath row] == 0) {
			if ([student firstContact] == nil) {
				theContact = [[MWSCoreDataManager sharedInstance] newContact];
				[student setFirstContact:theContact];
				abandonUpdates = NO;
			} else {
				theContact = [student firstContact];
			}
		} else if ([indexPath row] == 1) {
			if ([student secondContact] == nil) {
				theContact = [[MWSCoreDataManager sharedInstance] newContact];
				[student setSecondContact:theContact];
				abandonUpdates = NO;
			} else {
				theContact = [student secondContact];
			}
		} else if ([indexPath row] == 2) {
			if ([student otherContact] == nil) {
				theContact = [[MWSCoreDataManager sharedInstance] newContact];
				[student setOtherContact:theContact];
				abandonUpdates = NO;
			} else {
				theContact = [student otherContact];
			}
		} else if ([indexPath row] == 3) {
			if ([[student principalNotify] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				[student setPrincipalNotify:[NSNumber numberWithInt:1]];
			} else {
				[student setPrincipalNotify:[NSNumber numberWithInt:0]];
			}
			[tableView reloadData];
			return;
		}
		// go to contact view controller
		MWSContactEditViewController *contactEditViewController = [[MWSContactEditViewController alloc] initWithContact:theContact forStudent:student];
		[self.navigationController pushViewController:contactEditViewController animated:YES];
	} else if ([indexPath section] == 2) {
		// do nothing cause there are just text fields in this section
	} else if ([indexPath section] == 3) {
		if ([indexPath row] == 0) {
			if ([[student deleted] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				[student setDeleted:[NSNumber numberWithInt:1]];
			} else {
				[student setDeleted:[NSNumber numberWithInt:0]];
			}
		}
	}
	[tableView reloadData];
	[self findAndResignFirstResponder];
}

- (void)resetTheStudent:(MWSStudent *)searchStudent {
	[searchStudent setMyClassName:[student myClassName]];
	[searchStudent setMyClass:theClass];
	[self setStudent:searchStudent];
	[[self tableView] reloadData];
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

