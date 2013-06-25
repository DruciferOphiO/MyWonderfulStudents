//
//  MWSClassEditViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSClassEditViewController.h"
#import "MWSCoreDataManager.h"
#import "MWSClass.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"


static NSString *sortByFirstName = @"sortByFirstName";
static NSString *sortByLastName  = @"sortByLastName";
static NSString *sortById		 = @"sortById";

@implementation MWSClassEditViewController

@synthesize teacher, theClass;

#pragma mark -
#pragma mark init

- (id)initClassWithTeacher:(MWSTeacher *)aTeacher forClassName:(NSString *)theClassName  {
	if (self = [self initWithNibName:@"MWSClassEditViewController" bundle:nil]) {
		
		// save the teacher
		teacher = aTeacher;
		
		// if class is nil, create one
		theClass = nil;
		if (theClassName == nil) {
			theClass = [[MWSCoreDataManager sharedInstance] newClass];
			NSMutableSet *classesList = [NSMutableSet setWithArray:[[teacher classes] allObjects]];
			[classesList addObject:theClass];
			[teacher setClasses:[NSSet setWithArray:[classesList allObjects]]];
		} else {
			for (MWSClass *eachClass in [teacher classes]) {
				if ([[eachClass myClassName] compare:theClassName] == NSOrderedSame) {
					theClass = eachClass;
				}
			}
		}
		if (theClass == nil) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New initialization failed" message:@"New initialization failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
		}
		
		// set the classes's teacher
		[theClass setMyTeacher:teacher];
		
		// title
		if (([theClass myClassName] == nil) || ([[theClass myClassName] length] == 0)) {
			[self setTitle:NSLocalizedString(@"New Class",@"New Class")];
		} else {
			[self setTitle:[theClass myClassName]];
		}
		
		//            set the nav bar buttons
		// array to hold buttons
		// create the toolbar to place buttons
		UIToolbar *buttonContainer;
		NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
		// the help button
		if ([[teacher showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
			UIImage *image = [UIImage imageNamed:@"help-icon.png"];
			UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc] 
											   initWithImage:image 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(helpMe)];
			[buttons addObject:helpButtonItem];
		} else {
			buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
		}
		
		
		
		// put the tool bar in the nav bar
		UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
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

-(void)helpMe {
	UIAlertView *alertView;
	alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
										   message:NSLocalizedString(@"Touch a row to toggle sorting and settings!",@"Touch a row to toggle sorting and settings!") 
										  delegate:nil 
								 cancelButtonTitle:@"Got it" 
								 otherButtonTitles:nil];
	[alertView show];
}


#pragma mark -
#pragma mark View lifecycle
-(void)save {
	[self findAndResignFirstResponder];
	if ([self classIsValid]) {
		NSMutableArray *newClassList = [NSMutableArray arrayWithArray:[[teacher classes] allObjects]];
		[newClassList addObject:theClass];
		[teacher setClasses:[NSSet setWithArray:newClassList]];
		[[MWSCoreDataManager sharedInstance] saveContext];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Validation

- (BOOL)classIsValid {
	if (([theClass myClassName] == nil) || ([[theClass myClassName] length] == 0)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"No Class Name",@"No Class Name Entered") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
	return YES;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillDisappear:(BOOL)animated {
	teacher = nil;
	theClass = nil;
	if ([[MWSCoreDataManager sharedInstance] hasChanges]) {
		[[MWSCoreDataManager sharedInstance] abandonChanges];
	}
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];	
}

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
		return 3;
	} else if (section == 2) {
		//return 9;
		return 6;
	} else {
		NSLog(@"Somthing's wrong with class edit row number");
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Class",@"Class");
	}  else if (section == 1) {
		return NSLocalizedString(@"Sort student list by",@"Sort student list by");
	} else if (section == 2) {
		return NSLocalizedString(@"Settings",@"Settings");
	} else  {
		return @"Something's wrong with class section headers";
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	static NSString *CellIdentifier = @"Cell";
	AVMLeftLabelAndTextEntryTableCell *aLeftLabelAndTextEntryTableCell;
	
	if ([indexPath section] == 0) {  // section 1
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Class Name",@"The Class Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [theClass myClassName];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.autocapitalizationType = UITextAutocapitalizationTypeWords;
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Sort order",@"The Sort Order");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [NSString stringWithFormat:@"%@", [theClass sequence]];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			aLeftLabelAndTextEntryTableCell.txtEntry.keyboardType = UIKeyboardTypeNumberPad;
			return aLeftLabelAndTextEntryTableCell;
		}
	} else if ([indexPath section] == 1) {  // section 2
		if ([indexPath row] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"First name",@"First name")];
			if ([[theClass sortBy] compare:sortByFirstName] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return cell;
		} else if ([indexPath row] == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Last name",@"Last name")];
			if ([[theClass sortBy] compare:sortByLastName] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return cell;
		} else if ([indexPath row] == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Student id",@"Student id")];
			if ([[theClass sortBy] compare:sortById] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return cell;
		}
	} else {  // section 3
		if ([indexPath row] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Send Attendance Notification",@"Send Attendance Notification")];
			if ([[theClass sendAttendanceNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			return cell;
		} else if ([indexPath row] == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Send Test Notification",@"Send Test Notification")];
			if ([[theClass sendTestNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			return cell;
		} else if ([indexPath row] == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Send Assignment Notification",@"Send Assignment Notification")];
			if ([[theClass sendAssignmentNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			return cell;
		} else if ([indexPath row] == 3) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Send Conduct Notification",@"Send Conduct Notification")];
			if ([[theClass sendConductNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			return cell;
		} else if ([indexPath row] == 4) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Show deleted students",@"Show deleted students")];
			if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			return cell;
		//} else if ([indexPath row] == 5) {
//			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//			if (cell == nil) {
//				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//			}
//			[[cell textLabel]  setText:NSLocalizedString(@"Show deleted tests",@"Show deleted tests")];
//			if ([[theClass showDeletedTests] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
//				cell.accessoryType = UITableViewCellAccessoryNone;
//			} else {
//				cell.accessoryType = UITableViewCellAccessoryCheckmark;
//			}
//			return cell;
//		} else if ([indexPath row] == 6) {
//			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//			if (cell == nil) {
//				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//			}
//			[[cell textLabel]  setText:NSLocalizedString(@"Show deleted assignments",@"Show deleted assignments")];
//			if ([[theClass showDeletedAssignments] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
//				cell.accessoryType = UITableViewCellAccessoryNone;
//			} else {
//				cell.accessoryType = UITableViewCellAccessoryCheckmark;
//			}
//			return cell;
//		} else if ([indexPath row] == 7) {
//			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//			if (cell == nil) {
//				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//			}
//			[[cell textLabel]  setText:NSLocalizedString(@"Show deleted conducts",@"Show deleted conducts")];
//			if ([[theClass showDeletedConducts] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
//				cell.accessoryType = UITableViewCellAccessoryNone;
//			} else {
//				cell.accessoryType = UITableViewCellAccessoryCheckmark;
//			}
//			return cell;
//		} else if ([indexPath row] == 8) {
		} else if ([indexPath row] == 5) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Delete this class",@"Delete this class")];
			if ([[theClass deleted] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
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
	if (theClass == nil) {
		return;
	}
	switch ([textField tag]) {
		case 1:
			[theClass setMyClassName:[textField text]];
			break;
		case 2:
			[theClass setSequence:[NSNumber numberWithInt:[[textField text] intValue]]];
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// class list sort stuff
	if (([indexPath section] == 1) && ([indexPath row] == 0)) {
		[theClass setSortBy:sortByFirstName];
	}
	if (([indexPath section] == 1) && ([indexPath row] == 1)) {
		[theClass setSortBy:sortByLastName];
	}
	if (([indexPath section] == 1) && ([indexPath row] == 2)) {
		[theClass setSortBy:sortById];
	}
	
	// class settings
	if (([indexPath section] == 2) && ([indexPath row] == 0)) {
		if ([[theClass sendAttendanceNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setSendAttendanceNotification:[NSNumber numberWithInt:1]];
		} else {
			[theClass setSendAttendanceNotification:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 1)) {
		if ([[theClass sendTestNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setSendTestNotification:[NSNumber numberWithInt:1]];
		} else {
			[theClass setSendTestNotification:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 2)) {
		if ([[theClass sendAssignmentNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setSendAssignmentNotification:[NSNumber numberWithInt:1]];
		} else {
			[theClass setSendAssignmentNotification:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 3)) {
		if ([[theClass sendConductNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setSendConductNotification:[NSNumber numberWithInt:1]];
		} else {
			[theClass setSendConductNotification:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 4)) {
		if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setShowDeletedStudents:[NSNumber numberWithInt:1]];
		} else {
			[theClass setShowDeletedStudents:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 5)) {
		if ([[theClass showDeletedTests] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setShowDeletedTests:[NSNumber numberWithInt:1]];
		} else {
			[theClass setShowDeletedTests:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 6)) {
		if ([[theClass showDeletedAssignments] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setShowDeletedAssignments:[NSNumber numberWithInt:1]];
		} else {
			[theClass setShowDeletedAssignments:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 7)) {
		if ([[theClass showDeletedConducts] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setShowDeletedConducts:[NSNumber numberWithInt:1]];
		} else {
			[theClass setShowDeletedConducts:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 8)) {
		if ([[theClass deleted] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theClass setDeleted:[NSNumber numberWithInt:1]];
		} else {
			[theClass setDeleted:[NSNumber numberWithInt:0]];
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

