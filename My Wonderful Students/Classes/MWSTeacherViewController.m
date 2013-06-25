//
//  MWSTeacherViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MWSTeacherViewController.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"
#import "MWSCoreDataManager.h"

@implementation MWSTeacherViewController

@synthesize buttonContainer, buttonItem, teacher, helpIndex;

#pragma mark -
#pragma mark init

- (id)initWithTeacher:(MWSTeacher *)aTeacher  {
	if (self = [self initWithNibName:@"MWSTeacherViewController" bundle:nil]) {
		
		// save the teacher
		teacher = aTeacher;
		
		// title
		[self setTitle:NSLocalizedString(@"My Information",@"My Information")];
	}
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle
-(void)save {
	[self findAndResignFirstResponder];
	if ([self isValid]) {
		[[MWSCoreDataManager sharedInstance] saveContext];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

-(BOOL)isValid {
	if (([teacher lastName] == nil) || ([[teacher lastName] length] == 0)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") 
															message:NSLocalizedString(@"No Last Name",@"No teacher last name entered") 
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
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	
	//            set the nav bar buttons
	// array to hold buttons
	// create the toolbar to place buttons
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
	// the help button
	if ([[teacher showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
		UIImage *image = [UIImage imageNamed:@"help-icon.png"];
		UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc] 
										   initWithImage:image 
										   style:UIBarButtonItemStylePlain 
										   target:self 
										   action:@selector(helpMe)];
		//helpButtonItem.style = UIBarButtonItemStyleBordered;
		[buttons addObject:helpButtonItem];
	} else {
		buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
	}

	
	// the new button
	buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	[buttons addObject:buttonItem];
	
	if ([buttons count] > 0) {
		// put the buttons in the toolbar and release them
		[buttonContainer setItems:buttons animated:NO];
		// place the toolbar into the navigation bar
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
												  initWithCustomView:buttonContainer];
	}
}

-(void)helpMe {
	UIAlertView *alertView;
	alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
										   message:NSLocalizedString(@"Touch a row to toggle settings!",@"Touch a row to toggle settings!") 
										  delegate:nil 
								 cancelButtonTitle:@"Got it" 
								 otherButtonTitles:nil];
	[alertView show];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/


- (void)viewWillDisappear:(BOOL)animated {
    if ([[self teacher] hasChanges]) {
        [[[self teacher] managedObjectContext] rollback];
    }
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
		return 6;
	} else if (section == 1) {
		return 1;
	} else if (section == 2)  {
		return 3;
	}
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Personal",@"Personal");
	} else if (section == 1) {
		return NSLocalizedString(@"Other",@"Other");
	} else  {
		return NSLocalizedString(@"Settings",@"Settings");
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Title",@"Title");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [teacher title];
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"First Name",@"First Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [teacher firstName];
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Middle Name",@"Middle Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [teacher middleName];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.autocapitalizationType = UITextAutocapitalizationTypeWords;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([indexPath row] == 3) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Last Name",@"Last Name");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [teacher lastName];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.autocapitalizationType = UITextAutocapitalizationTypeWords;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([indexPath row] == 4) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Name Suffix",@"Name Suffix");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [teacher nameSuffix];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.autocapitalizationType = UITextAutocapitalizationTypeSentences;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([indexPath row] == 5) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Email",@"Email");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [teacher email];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			aLeftLabelAndTextEntryTableCell.txtEntry.keyboardType = UIKeyboardTypeEmailAddress;
			return aLeftLabelAndTextEntryTableCell;
		}
	} else if ([indexPath section] == 1) { // section 2
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
			aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Principal Email",@"Principal Email");
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [teacher principalEmail];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 11;
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			aLeftLabelAndTextEntryTableCell.txtEntry.keyboardType = UIKeyboardTypeEmailAddress;
			return aLeftLabelAndTextEntryTableCell;
		}

	} else {  // section 3
		if ([indexPath row] == 0) {
			static NSString *CellIdentifier = @"Cell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Copy me on Emails",@"Copy me on Emails")];
			if ([[teacher copyMeOnEmails] compare:[NSNumber numberWithInt: 1]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return cell;
		} else if ([indexPath row] == 1) {
			static NSString *CellIdentifier = @"Cell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel] setText:NSLocalizedString(@"Show deleted classes",@"Show deleted classes")];
			if ([[teacher showDeletedClasses] compare:[NSNumber numberWithInt: 1]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return cell;
		}else if ([indexPath row] == 2) {
			static NSString *CellIdentifier = @"Cell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			[[cell textLabel]  setText:NSLocalizedString(@"Show help",@"Show help")];
			if ([[teacher showHelp] compare:[NSNumber numberWithInt: 1]] == NSOrderedSame) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return cell;
		}


	}
	
	return nil;
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
    
	if (([indexPath section] == 2) && ([indexPath row] == 0)) {
		if ([[teacher copyMeOnEmails] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			if ([[[teacher email]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
				[teacher setCopyMeOnEmails:[NSNumber numberWithInt:1]];
			} else {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") 
																	message:NSLocalizedString(@"No Email Addr",@"No Email Addr") 
																   delegate:nil 
														  cancelButtonTitle:@"OK" 
														  otherButtonTitles:nil];
				[alertView show];
			}
		} else {
			[teacher setCopyMeOnEmails:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 1)) {
		if ([[teacher showDeletedClasses] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[teacher setShowDeletedClasses:[NSNumber numberWithInt:1]];
		} else {
			[teacher setShowDeletedClasses:[NSNumber numberWithInt:0]];
		}
	}
	if (([indexPath section] == 2) && ([indexPath row] == 2)) {
		if ([[teacher showHelp] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[teacher setShowHelp:[NSNumber numberWithInt:1]];
		} else {
			[teacher setShowHelp:[NSNumber numberWithInt:0]];
		}
	}
	[tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	switch ([textField tag]) {
		case 1:
			[teacher setTitle:[textField text]];
			break;
		case 2:
			[teacher setFirstName:[textField text]];
			break;
		case 3:
			[teacher setMiddleName:[textField text]];
			break;
		case 4:
			[teacher setLastName:[textField text]];
			break;
		case 5:
			[teacher setNameSuffix:[textField text]];
			break;
		case 6:
			[teacher setEmail:[textField text]];
			break;
		case 11:
			[teacher setPrincipalEmail:[textField text]];
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

