//
//  MWSAssignmentEditViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/25/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSAssignmentEditViewController.h"
#import "MWSCoreDataManager.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"
#import "MWSStudent.h"

@implementation MWSAssignmentEditViewController

@synthesize buttonContainer, buttonItem, theClass, theAssignment, theDatePicker, 
student, theStudentAssignment, canSave;

#pragma mark -
#pragma mark View lifecycle

-(id)initWithClass:(MWSClass *)aClass andAssignment:(MWSAssignment *)anAssignment forStudents:(NSArray *)studentList {
	if (self = [self initWithNibName:@"MWSAssignmentEditViewController" bundle:nil]) {
        theClass = aClass;
        
        if (anAssignment == nil) {
            theAssignment = [[MWSCoreDataManager sharedInstance] newAssignment];
            [theAssignment setTheClass:aClass];
            [theAssignment setAssignmentDate:[NSDate date]];
            [theAssignment setDueDate:[NSDate date]];
            [theAssignment setTheClass:aClass];
            [theAssignment setSendNotification:[NSNumber numberWithInt:0]];
        } else {
            theAssignment = anAssignment;
        }
        
        // create the toolbar to place buttons
        buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        
        // array to hold buttons
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
        
        // the new button
        buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
        [buttons addObject:buttonItem];
        
        // put the button on the toolbar
        [buttonContainer setItems:buttons animated:NO];
        
        // put the tool bar in the nav bar
        [[self navigationItem] setRightBarButtonItem:buttonItem];
        
        canSave = YES;
    }
	
	return self;
}

-(id)initWithStudent:(MWSStudent *)aStudent andStudentAssignment:(MWSStudentAssignment *)studentAssignment {
	if (self = [self initWithNibName:@"MWSAssignmentEditViewController" bundle:nil]) {
        student = aStudent;
        
        if (studentAssignment == nil) {
            theAssignment = [[MWSCoreDataManager sharedInstance] newAssignment];
            [theAssignment setTheClass:nil];
            [theAssignment setAssignmentDate:[NSDate date]];
            [theAssignment setDueDate:[NSDate date]];
            [theAssignment setSendNotification:[NSNumber numberWithInt:0]];
            theStudentAssignment = [[MWSCoreDataManager sharedInstance] newStudentAssignment];
            [theStudentAssignment setStudent:aStudent];
            [theStudentAssignment setAssignment:theAssignment];
            [theStudentAssignment setDone:[NSNumber numberWithInt:1]];
            // Add the student Assignment to each student
            int arraySize = [[aStudent assignments] count] + 1;
            NSMutableArray *workArray = [NSMutableArray arrayWithCapacity:arraySize];
            [workArray addObjectsFromArray:[NSArray arrayWithArray:[[aStudent assignments] allObjects]]];
            [workArray addObject:theStudentAssignment];
            [aStudent setAssignments:[NSSet setWithArray:workArray]];
            canSave = YES;
        } else {
            theAssignment = [studentAssignment assignment];
            theStudentAssignment = studentAssignment;
            canSave = NO;
        }
        
        // create the toolbar to place buttons
        buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        
        // array to hold buttons
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
        
        // the new button
        buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
        [buttons addObject:buttonItem];
        
        // put the button on the toolbar
        [buttonContainer setItems:buttons animated:NO];
        
        // put the tool bar in the nav bar
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
	if ([[MWSCoreDataManager sharedInstance] hasChanges]) {
		[[MWSCoreDataManager sharedInstance] abandonChanges];
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//return 6;
	return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Assignment",@"Assignment");
	} 
	return @"";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	static NSString *CellIdentifier = @"Cell";
	AVMLeftLabelAndTextEntryTableCell *aLeftLabelAndTextEntryTableCell;
	
	if ([indexPath row] == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"MM-dd-yyyy"];
		NSString *hdr = @"Assignment Date ";
		[[cell textLabel] setText:[hdr stringByAppendingString:[df stringFromDate:[theAssignment assignmentDate]]]];
        [cell textLabel].textAlignment = NSTextAlignmentCenter;
		return cell;
	}
	
	if ([indexPath row] == 1) {
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
		aLeftLabelAndTextEntryTableCell.txtEntry.text = [theAssignment subject];
		aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
		aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
		return aLeftLabelAndTextEntryTableCell;
	}
	
	if ([indexPath row] == 2) {
		aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
		if (aLeftLabelAndTextEntryTableCell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[UITableViewCell class]]) {
					aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
				}
			}
		}
		aLeftLabelAndTextEntryTableCell.leftLabel.text = NSLocalizedString(@"Description",@"Description");
		aLeftLabelAndTextEntryTableCell.txtEntry.text = [theAssignment assignmentText];
		aLeftLabelAndTextEntryTableCell.txtEntry.tag = [indexPath row] + 1;
		aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
		return aLeftLabelAndTextEntryTableCell;
	}
	
	if ([indexPath row] == 3) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"MM-dd-yyyy"];
		NSString *hdr = @"Due Date ";
		[[cell textLabel] setText:[hdr stringByAppendingString:[df stringFromDate:[theAssignment dueDate]]]];
        [cell textLabel].textAlignment = NSTextAlignmentCenter;
		return cell;
	}
	
	if ([indexPath row] == 4) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		[[cell textLabel]  setText:NSLocalizedString(@"Send Assigment Notification",@"Send Assigment Notification")];
		if ([[theAssignment sendNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		} else {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		return cell;
	}
	
	if ([indexPath row] == 5) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		[[cell textLabel]  setText:NSLocalizedString(@"Delete this assignment",@"Delete this assignment")];
		if ([[theAssignment deleted] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		} else {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		return cell;
	}
	
	return cell;
}
	
	- (void)textFieldDidEndEditing:(UITextField *)textField {
		switch ([textField tag]) {
			case 2:
				[theAssignment setSubject:[textField text]];
				break;
			case 3:
				[theAssignment setAssignmentText:[textField text]];
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
	if ([indexPath row] == 0) {
		NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
		theDatePicker = [[UIDatePicker alloc] init];
		theDatePicker.datePickerMode = UIDatePickerModeDate;
		[theDatePicker setFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
		
		[formatter1 setLenient:YES];
		[formatter1 setDateStyle:NSDateFormatterShortStyle];
		NSString *minDateString = @"01-01-2010";
		NSDate* minDate = [formatter1 dateFromString:minDateString];
		theDatePicker.minimumDate = minDate;
		
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Set Date" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
		[actionSheet bringSubviewToFront:theDatePicker];
		[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[actionSheet showInView:[self.view superview]];
		[actionSheet addSubview:theDatePicker];
		[actionSheet sendSubviewToBack:theDatePicker];
		[actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
		[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
		[actionSheet setTag:1];
		
		[self findAndResignFirstResponder];
	}
	if ([indexPath row] == 3) {
		NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
		theDatePicker = [[UIDatePicker alloc] init];
		theDatePicker.datePickerMode = UIDatePickerModeDate;
		[theDatePicker setFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
		
		[formatter1 setLenient:YES];
		[formatter1 setDateStyle:NSDateFormatterShortStyle];
		NSString *minDateString = @"01-01-2010";
		NSDate* minDate = [formatter1 dateFromString:minDateString];
		theDatePicker.minimumDate = minDate;
		
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Set Date" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
		[actionSheet bringSubviewToFront:theDatePicker];
		[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[actionSheet showInView:[self.view superview]];
		[actionSheet addSubview:theDatePicker];
		[actionSheet sendSubviewToBack:theDatePicker];
		[actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
		[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
		[actionSheet setTag:2];
		
		[self findAndResignFirstResponder];
	}
    if ([indexPath row] == 4) {
		if ([[theAssignment sendNotification] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theAssignment setSendNotification:[NSNumber numberWithInt:1]];
		} else {
			[theAssignment setSendNotification:[NSNumber numberWithInt:0]];
		}
		[self findAndResignFirstResponder];
	}
    if ([indexPath row] == 5) {
		if ([[theAssignment deleted] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			[theAssignment setDeleted:[NSNumber numberWithInt:1]];
		} else {
			[theAssignment setDeleted:[NSNumber numberWithInt:0]];
		}
		[self findAndResignFirstResponder];
	}
	
	[[self tableView] reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		if ([actionSheet tag] == 1) {
			NSDate *newDate = [theDatePicker date];
			[theAssignment setAssignmentDate:newDate];
			[[self tableView] reloadData];
		}
		if ([actionSheet tag] == 2) {
			NSDate *newDate = [theDatePicker date];
			[theAssignment setDueDate:newDate];
			[[self tableView] reloadData];
		}
	}
}

-(void)save {
	[self findAndResignFirstResponder];
	if (canSave) {
		if ([self assignmentIsValid]) {
			[[MWSCoreDataManager sharedInstance] saveContext];
			[self.navigationController popViewControllerAnimated:YES];
		}
	} //else {
	//	[[MWSCoreDataManager sharedInstance] abandonChanges];
	//	[self.navigationController popViewControllerAnimated:YES];
	//}

}
-(BOOL)assignmentIsValid {
	if (([theAssignment subject] == nil) || ([[theAssignment subject] length] == 0)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"No Assignment Short Name",@"No Assignment Short Name") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
	return YES;
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

