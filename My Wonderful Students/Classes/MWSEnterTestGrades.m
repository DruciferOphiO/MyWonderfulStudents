//
//  MWSEnterTestGrades.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/20/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSEnterTestGrades.h"
#import "AVMLeftLabelAndTextEntryTableCell.h"
#import "MWSCoreDataManager.h"
#import "EmailSender.h"
#import "TextSender.h"
#import "MWSClass.h"

static NSString *sortByFirstName = @"sortByFirstName";
static NSString *sortByLastName  = @"sortByLastName";
static NSString *sortById		 = @"sortById";

@implementation MWSEnterTestGrades
@synthesize studentList, buttonContainer, buttonItem, theTest, theClass, theStudent, theStudentTest, savedTextRecipients, savedMessage, previousStudent;

#pragma mark -
#pragma mark View lifecycle

-(id)initForTest:(MWSTest *)aTest inClass:(MWSClass *)aClass {
	if (self = [self initWithNibName:@"MWSEnterTestGrades" bundle:nil]) {
        theClass = aClass;
        
        if (aTest == nil) {
            theTest = [[MWSCoreDataManager sharedInstance] newTest];
            [theTest setMyClass:aClass];
            [theTest setDate:[NSDate date]];
            NSMutableArray *newTestArray = [[NSMutableArray alloc] init];
            [newTestArray addObjectsFromArray:[[theClass tests] allObjects]];
            [newTestArray addObject:theTest];
            [theClass setTests:[NSSet setWithArray:[NSArray arrayWithArray:newTestArray]]];
        } else {
            theTest = aTest;
        }
        
        [self setTitle:[aTest name]];
        
        // sort the array
        NSSortDescriptor *sortDescriptor;
        if ([[theClass sortBy] compare:sortByFirstName] == NSOrderedSame) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                                         ascending:YES];
        } else if ([[theClass sortBy] compare:sortByLastName] == NSOrderedSame) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName"
                                                         ascending:YES];
        } else if ([[theClass sortBy] compare:sortById] == NSOrderedSame) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idNumber"
                                                         ascending:YES];
        }
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSMutableArray *sortedStudentList = [[NSMutableArray alloc] init];
        [sortedStudentList addObjectsFromArray:[[[aClass students] allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
        NSMutableArray *workArray = [NSMutableArray arrayWithCapacity:[sortedStudentList count]];
        [workArray addObjectsFromArray:sortedStudentList];
        if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt:0]]== NSOrderedSame) {
            for (MWSStudent *eachStudent in workArray) {
                if ([[eachStudent deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                    [sortedStudentList removeObject:eachStudent];
                }
            }
        }
        
        // load the student list
        if ([[aTest studentTests] count] == 0) {
            NSMutableArray *buildList = [[NSMutableArray alloc] init];
            for (MWSStudent *eachStudent in sortedStudentList) {
                MWSStudentTest *aStudentTest = [[MWSCoreDataManager sharedInstance] newStudentTest];
                [aStudentTest setStudent:eachStudent];
                [aStudentTest setTest:aTest];
                if ([[theTest passFail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                    [aStudentTest setGrade:@"Pass"];
                } else if ([[theTest letterGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                    [aStudentTest setGrade:@"C"];
                } else if ([[theTest numericGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                    [aStudentTest setGrade:@"70"];
                }
                [buildList addObject:aStudentTest];
                int arraySize = [[eachStudent tests] count] + 1;
                NSMutableArray *workArray = [NSMutableArray arrayWithCapacity:arraySize];
                [workArray addObjectsFromArray:[NSArray arrayWithArray:[[eachStudent tests] allObjects]]];
                [workArray addObject:aStudentTest];
                [eachStudent setTests:[NSSet setWithArray:workArray]];
            }
            [aTest setStudentTests:[NSSet setWithArray:buildList]];
            [self setStudentList:[NSArray arrayWithArray:buildList]];
        } else {
            if ([[theClass sortBy] compare:sortByFirstName] == NSOrderedSame) {
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"student.firstName"
                                                             ascending:YES];
            } else if ([[theClass sortBy] compare:sortByLastName] == NSOrderedSame) {
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"student.lastName"
                                                             ascending:YES];
            } else if ([[theClass sortBy] compare:sortById] == NSOrderedSame) {
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"student.idNumber"
                                                             ascending:YES];
            }
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSMutableArray *anotherDamnArray = [NSMutableArray arrayWithArray:[[[aTest studentTests] allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
            workArray = [NSMutableArray arrayWithCapacity:[sortedStudentList count]];
            [workArray addObjectsFromArray:anotherDamnArray];
            if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt:0]]== NSOrderedSame) {
                for (MWSStudentTest *eachStudent in workArray) {
                    if ([[[eachStudent student] deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                        [anotherDamnArray removeObject:eachStudent];
                    }
                }
            }
            [self setStudentList:anotherDamnArray];
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
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
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
	return [[self studentList] count] + 1;

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AVMLeftLabelAndTextEntryTableCell *aLeftLabelAndTextEntryTableCell;
	UITableViewCell *cell = nil;
	static NSString *CellIdentifier = @"Cell";
	NSIndexPath *oneRowBack = [NSIndexPath indexPathForRow:[indexPath row] - 1 inSection:[indexPath section]];
	MWSStudent *selectedStudent;
	MWSStudentTest *selectedStudentTest;
	NSString *studentName;
	
	if ([indexPath row] == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		if ([[theTest passFail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			[[cell textLabel] setText:NSLocalizedString(@"Enter Pass or Fail or P or F",@"Enter Pass or Fail or P or F")];
		} else if ([[theTest letterGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			[[cell textLabel] setText:NSLocalizedString(@"Enter A,B,C,D or F",@"Enter A,B,C,D or F")];
		} else if ([[theTest numericGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			[[cell textLabel] setText:NSLocalizedString(@"Enter Percentage Grade",@"Enter Percentage Grade")];
		}
		return cell;
	} else {
		selectedStudent = [[[self studentList] objectAtIndex:[oneRowBack row]] student];
		selectedStudentTest = [[self studentList] objectAtIndex:[oneRowBack row]];
		studentName = [NSString stringWithFormat:@"%@ %@", [selectedStudent firstName], [selectedStudent lastName]];
		if ([[theTest passFail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = studentName;
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [selectedStudentTest grade];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [oneRowBack row];
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([theTest letterGrade]) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = studentName;
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [selectedStudentTest grade];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [oneRowBack row];
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			return aLeftLabelAndTextEntryTableCell;
		} else if ([[theTest numericGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *) [tableView dequeueReusableCellWithIdentifier:[AVMLeftLabelAndTextEntryTableCell reuseIndentifier]];
			if (aLeftLabelAndTextEntryTableCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AVMLeftLabelAndTextEntryTableCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						aLeftLabelAndTextEntryTableCell = (AVMLeftLabelAndTextEntryTableCell *)currentObject;
					}
				}
			}
			aLeftLabelAndTextEntryTableCell.leftLabel.text = studentName;
			aLeftLabelAndTextEntryTableCell.txtEntry.text = [selectedStudentTest grade];
			aLeftLabelAndTextEntryTableCell.txtEntry.tag = [oneRowBack row];
			aLeftLabelAndTextEntryTableCell.txtEntry.delegate = self;
			aLeftLabelAndTextEntryTableCell.txtEntry.keyboardType = UIKeyboardTypeNumberPad;
			return aLeftLabelAndTextEntryTableCell;
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
		previousStudent = nil;
		[[self tableView] reloadData];
		[self findAndResignFirstResponder];
		return;
	}
	[[self tableView] reloadData];
    [self findAndResignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (savedTextRecipients) {
		[[self tableView] reloadData];
		[self findAndResignFirstResponder];
		return NO;
	} else {
		return YES;
	}

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	MWSStudentTest *aStudentTest = [[self studentList] objectAtIndex:[textField tag]];
	
	if (savedTextRecipients) {
		[[TextSender sharedInstance] sendTextTo:savedTextRecipients 
										message:savedMessage 
								 withController:self];
		savedMessage = nil;
		savedTextRecipients = nil;
		previousStudent = nil;
		[self findAndResignFirstResponder];
		[[self tableView] reloadData];
		return;
	}
	
	if ([[theTest passFail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		if (([[textField text] caseInsensitiveCompare:@"Pass"] == NSOrderedSame) ||
			([[textField text] caseInsensitiveCompare:@"P"] == NSOrderedSame)) {
			[aStudentTest setGrade:@"Pass"];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else if (([[textField text] caseInsensitiveCompare:@"Fail"] == NSOrderedSame) || 
				   [[textField text] caseInsensitiveCompare:@"F"] == NSOrderedSame) {
			[aStudentTest setGrade:@"Fail"];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"Enter Pass or Fail or P or F",@"Enter Pass or Fail or P or F") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			return;
		}
	} else if ([[theTest letterGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		if ([[textField text] caseInsensitiveCompare:@"A"] == NSOrderedSame) {
			[aStudentTest setGrade:@"A"];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else if ([[textField text] caseInsensitiveCompare:@"B"] == NSOrderedSame) {
			[aStudentTest setGrade:@"B"];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else if ([[textField text] caseInsensitiveCompare:@"C"] == NSOrderedSame) {
			[aStudentTest setGrade:@"C"];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else if ([[textField text] caseInsensitiveCompare:@"D"] == NSOrderedSame) {
			[aStudentTest setGrade:@"D"];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else if ([[textField text] caseInsensitiveCompare:@"F"] == NSOrderedSame) {
			[aStudentTest setGrade:@"F"];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"Enter A,B,C,D or F",@"Enter A,B,C,D or F") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			return;
		}
	} else if ([[theTest numericGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * myNumber = [f numberFromString:[textField text]];
		if (([myNumber intValue] >= 0) && ([myNumber intValue] <= 100)) {
			[aStudentTest setGrade:[textField text]];
			[[MWSCoreDataManager sharedInstance] saveContext];
		} else {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error",@"Validation Message") message:NSLocalizedString(@"Enter a number from 0-100",@"Enter a number from 0-100") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			return;
		}
	}
	
	// send notifications
	//if ((haveCapturedGrades) && ([[theClass sendTestNotification] compare:[NSNumber numberWithInt:1]] == NSOrderedSame)) {
	if ([[theClass sendTestNotification] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		
		NSMutableArray *emailRecipients = [[NSMutableArray alloc] init];
		savedTextRecipients = [[NSMutableArray alloc] init];
		
		// check for connectivity and only do if have connectitivy
		if ([[aStudentTest student] firstContact]) {
			if ([[[[aStudentTest student] firstContact] notifyForTests] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				if (([[[[aStudentTest student] firstContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
					&& ([[[aStudentTest student] firstContact] email])) {
					[emailRecipients addObject:[[[aStudentTest student] firstContact] email]];
				}
				if ([[[[aStudentTest student] firstContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[[aStudentTest student] firstContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[aStudentTest student] firstContact] textNumber])) {
						[savedTextRecipients addObject:[[[aStudentTest student] firstContact] textNumber]];
					}
				}
			}
		}
		if ([[aStudentTest student] secondContact]) {
			if ([[[[aStudentTest student] secondContact] notifyForTests] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				if (([[[[aStudentTest student] secondContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
					&& ([[[aStudentTest student] secondContact] email])) {
					[emailRecipients addObject:[[[aStudentTest student] secondContact] email]];
				}
				if ([[[[aStudentTest student] secondContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[[aStudentTest student] secondContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[aStudentTest student] secondContact] textNumber])) {
						[savedTextRecipients addObject:[[[aStudentTest student] secondContact] textNumber]];
					}
				}
			}
		}
		if ([[aStudentTest student] otherContact]) {
			if ([[[[aStudentTest student] otherContact] notifyForTests] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				if (([[[[aStudentTest student] otherContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
					&& ([[[aStudentTest student] otherContact] email])) {
					[emailRecipients addObject:[[[aStudentTest student] otherContact] email]];
				}
				if ([[[[aStudentTest student] otherContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[[aStudentTest student] otherContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[aStudentTest student] otherContact] textNumber])) {
						[savedTextRecipients addObject:[[[aStudentTest student] otherContact] textNumber]];
					}
				}
			}
		}
		if ([[[aStudentTest student] principalNotify] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			if ([[theClass myTeacher] principalEmail]) {
				[emailRecipients addObject:[[theClass myTeacher] principalEmail]];
			}
		}
		
		NSString *message = [NSString stringWithFormat:@"%@ %@ scored %@ for test: %@ in %@ class.", [[aStudentTest student] firstName], [[aStudentTest student] lastName], [aStudentTest grade], [[aStudentTest test] name], [theClass myClassName]];
		
		if ([emailRecipients count] > 0) {
			[[EmailSender sharedInstance] sendEmailTo:emailRecipients 
											  subject:@"Test Notification" 
											  message:message 
									   withController:self];
		} 
		
		if ([savedTextRecipients count] == 0) {
			savedTextRecipients = nil;
			previousStudent = nil;
		} else {
			UIAlertView *alertView = [[UIAlertView alloc] 
									  initWithTitle:NSLocalizedString(@"Information!",@"Information!") 
									  message:[NSString stringWithFormat:@"Touch %@ %@ row again to send text message(s).", 
											   [[aStudentTest student] firstName], 
											   [[aStudentTest student] lastName]]
									  delegate:nil 
									  cancelButtonTitle:@"OK" 
									  otherButtonTitles:nil];
			[alertView show];
			savedMessage = message;
			previousStudent = [aStudentTest student];
		}
	}
	[self findAndResignFirstResponder];
	[[self tableView] reloadData];
}

-(void)save {
	if (savedTextRecipients) {
		[[TextSender sharedInstance] sendTextTo:savedTextRecipients 
										message:savedMessage 
								 withController:self];
		savedMessage = nil;
		savedTextRecipients = nil;
		[self findAndResignFirstResponder];
		return;
	}
	[[MWSCoreDataManager sharedInstance] saveContext];
	[self.navigationController popViewControllerAnimated:YES];
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

