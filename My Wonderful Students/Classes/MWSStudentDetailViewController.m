//
//  MWSStudentDetailViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/5/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentDetailViewController.h"
#import "MWSStudentDetailTableCell.h"
#import "MWSAssignment.h"
#import "MWSAttendance.h"
#import "MWSConduct.h"
#import "MWSStudentTest.h"
#import "MWSTest.h"
#import "MWSStudentAssignment.h"
#import "MWSTeacher.h"
#import "MWSStudent.h"
#import "MWSContact.h"
#import "EmailSender.h"

@implementation MWSStudentDetailViewController

@synthesize student, theClass, sortedConductArray, sortedAttendanceAbsentArray, df, sortedStudentTests, sortedStudentAssignments, helpIndex;
@synthesize assignmentEditViewController;
@synthesize enterAssignmentsDoneViewController;

#pragma mark -
#pragma mark init

- (id)initStudent:aStudent forClassName:aClass  {
    if (self = [self initWithNibName:@"MWSStudentDetailViewController" bundle:nil]) {
        
        // save the class
        theClass = aClass;
        
        // if Student is nil, create one
        student = aStudent;
        
        // title
        [self setTitle:[NSString stringWithFormat:@"%@ %@", [student firstName], [student lastName]]];
        
        // create the conduct array and sort
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [sortedConductArray addObjectsFromArray: [[[student conduct] allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
        
        // create the attendance array and sort
        sortedAttendanceAbsentArray = [[NSMutableArray alloc] init];
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                     ascending:NO];
        sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedAttendanceArray = [[[student attendance] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        for (MWSAttendance *eachAttendance in sortedAttendanceArray) {
            if ([[eachAttendance isPresent] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
                [sortedAttendanceAbsentArray addObject:eachAttendance];
            }
        }
        
        // date formatter
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy"];
        // create the test array and sort
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"test.date"
                                                     ascending:NO];
        sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        sortedStudentTests = [[[student tests] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        
        // create the assignment array and sort
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"assignment.assignmentDate"
                                                     ascending:NO];
        sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        sortedStudentAssignments = [[[student assignments] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        
        
        //            set the nav bar buttons
        // array to hold buttons
        // create the toolbar to place buttons
        UIToolbar *buttonContainer;
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
        // the help button
        if ([[[theClass myTeacher] showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
            buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 45)];
            UIImage *image = [UIImage imageNamed:@"help-icon.png"];
            UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc]
                                               initWithImage:image
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(helpMe)];
            //helpButtonItem.style = UIBarButtonItemStyleBordered;
            [buttons addObject:helpButtonItem];
        } else {
            buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        }
        
        // the add a report button
        UIImage *image = [UIImage imageNamed:@"sendreport.png"];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] 
                                       initWithImage:image 
                                       style:UIBarButtonItemStylePlain 
                                       target:self 
                                       action:@selector(sendStudentReport)];
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


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set up the swipe
	//UISwipeGestureRecognizer *recognizer;
//	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
//	[[self tableView] addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// create the conduct array and sort
	sortedConductArray = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
												 ascending:NO];
	NSMutableArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	NSArray *sortedConducts = [[[student conduct] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
	if ([[theClass showDeletedConducts] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		[sortedConductArray addObjectsFromArray:sortedConducts];
	} else {
		for (MWSConduct *eachConduct in sortedConducts) {
			if ([[eachConduct deleted] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
				[sortedConductArray addObject:eachConduct];
			}
		}
	}
	
	
	// create the assignment array and sort
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"assignment.assignmentDate"
												 ascending:NO];
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	sortedStudentAssignments = [[[student assignments] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
	
	[[self tableView] reloadData];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rtn = 0;
    switch (section) {
		case 0:
			rtn = [sortedConductArray count] + 1;
			break;
		case 1:
			if ([sortedAttendanceAbsentArray count] == 0) {
				rtn = 1;
			} else {
				rtn = [sortedAttendanceAbsentArray count];
			}
			break;
		case 2:
			if ([sortedStudentTests count] == 0) {
				rtn = 1;
			} else {
				rtn = [sortedStudentTests count];
			}
			break;
		case 3:
			rtn = [sortedStudentAssignments count] + 1;
			break;
		default:
			break;
	}
    return rtn;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	
	switch ([indexPath section]) {
		case 0:
			cell = [self section0CellForTableView:tableView andIndexPath:indexPath];
			break;
		case 1:
			cell = [self section1CellForTableView:tableView andIndexPath:indexPath];
			break;
		case 2:
			cell = [self section2CellForTableView:tableView andIndexPath:indexPath];
			break;
		case 3:
			cell = [self section3CellForTableView:tableView andIndexPath:indexPath];
			break;
		default:
			break;
	}
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *rtn = @"";
	NSString *atndceHdr;
	NSString *dayOrDays;
	if ([sortedAttendanceAbsentArray count] == 1) {
		dayOrDays = NSLocalizedString(@"day",@"day");
	} else {
		dayOrDays = NSLocalizedString(@"days",@"days");
	}

	switch (section) {
		case 0:
			rtn = NSLocalizedString(@"Conduct",@"Conduct");
			break;
		case 1:
			atndceHdr = [NSString stringWithFormat:@"%@ (%@ %d %@)", 
						 NSLocalizedString(@"Attendance",@"Attendance"), 
						 NSLocalizedString(@"absent",@"absent"), 
						 [sortedAttendanceAbsentArray count],
						 dayOrDays]; 
			rtn = atndceHdr;
			break;
		case 2:
			rtn = NSLocalizedString(@"Tests",@"Tests");
			break;
		case 3:
			rtn = NSLocalizedString(@"Assignments",@"Assignements");
			break;
		default:
			break;
	}
	return rtn;
	
}

-(UITableViewCell *)section0CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {	
	// Conduct
	// setup the cell
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	if ([indexPath row] < [sortedConductArray count]) {
		[[cell textLabel] setText:[[sortedConductArray objectAtIndex:[indexPath row]] conductText]]; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		[[cell textLabel] setText:NSLocalizedString(@"New Conduct",@"New Conduct")]; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}

-(UITableViewCell *)section1CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
	// Attendance
	// setup the cell
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	if ([sortedAttendanceAbsentArray count] == 0) {
		[[cell textLabel] setText:NSLocalizedString(@"No attendance records",@"No attendance records")];
	} else {
		NSString *dateAbsent = [df stringFromDate:[[sortedAttendanceAbsentArray objectAtIndex:[indexPath row]] date]];
		[[cell textLabel] setText:dateAbsent];
	}

	return cell;	
}

-(UITableViewCell *)section2CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
	// Tests
	// setup the cell
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	if ([sortedStudentTests count] == 0) {
		[[cell textLabel] setText:NSLocalizedString(@"No tests",@"No tests")];
	} else {
		NSString *testName = [[[sortedStudentTests objectAtIndex:[indexPath row]] test] name];
		NSString *testDate = [df stringFromDate:[[[sortedStudentTests objectAtIndex:[indexPath row]] test] date]];
		NSString *testGrade = [[sortedStudentTests objectAtIndex:[indexPath row]] grade];
		[[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@ (%@)", testGrade, testName, testDate]];
	}
	
	return cell;	
}

-(UITableViewCell *)section3CellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
	// Assignments
	// setup the cell
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	if ([indexPath row] < [sortedStudentAssignments count]) {
		NSString *assignmentName = [[[sortedStudentAssignments objectAtIndex:[indexPath row]] assignment] subject];
		NSString *assignmentDate = [df stringFromDate:[[[sortedStudentAssignments objectAtIndex:[indexPath row]] assignment] assignmentDate]];
		NSString *assignmentDone;
		if ([[[sortedStudentAssignments objectAtIndex:[indexPath row]] done] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
			assignmentDone = @"Not completed";
		} else {
			assignmentDone = @"Completed";
		}
		[[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@ (%@)", assignmentDone, assignmentName, assignmentDate]]; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		[[cell textLabel] setText:NSLocalizedString(@"New Assignment",@"New Assignment")]; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MWSConductEditViewController *conductEditViewController;
	MWSConduct *selectedConduct;
	MWSStudentAssignment *aStudentAssignment;
	
	switch ([indexPath section]) {
		case 0:
			conductEditViewController = [[MWSConductEditViewController alloc] initWithNibName:@"MWSConductEditViewController" bundle:nil];
			if ([indexPath row] < [sortedConductArray count]) {
				selectedConduct = [sortedConductArray objectAtIndex:[indexPath row]];
				conductEditViewController = [conductEditViewController initWithConduct:selectedConduct forStudent:student];
			} else {
				conductEditViewController = [conductEditViewController initWithConduct:nil forStudent:student];
			}
			[self.navigationController pushViewController:conductEditViewController animated:YES];
			break;
		case 3:
			if ([indexPath row] < [sortedStudentAssignments count]) {
				aStudentAssignment = [sortedStudentAssignments objectAtIndex:[indexPath row]];
				enterAssignmentsDoneViewController =[[MWSEnterAssignmentsDoneViewController alloc] initForAssignment:[[sortedStudentAssignments objectAtIndex:[indexPath row]] assignment]
														  forStudents:[NSArray arrayWithObject:aStudentAssignment]
															  inClass:theClass
													   individualFlag:YES];
				[self.navigationController pushViewController:enterAssignmentsDoneViewController animated:YES];
			} else {
				assignmentEditViewController = [[MWSAssignmentEditViewController alloc] initWithStudent:student andStudentAssignment:nil];
				[self.navigationController pushViewController:assignmentEditViewController animated:YES];
			}
			break;
		default:
			break;
	}
	
	[[self tableView] reloadData];
	[self findAndResignFirstResponder];
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

-(void)helpMe {
	UIAlertView *alertView;
	if (helpIndex > 0) helpIndex = 0;
		switch (helpIndex) {
			case 0:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Touch report button to send student summart to contacts!",@"Touch report button to send student summart to contacts!") 
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

-(void)sendStudentReport {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    UIAlertView *alertView;
    if ([[student principalNotify] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
        if ([[theClass myTeacher] principalEmail]) {
            [contacts addObject:[[theClass myTeacher] principalEmail]];
        }
    }
    if (([student firstContact]) &&
        (([[[student firstContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame)) 
        && ([[student firstContact] email])) {
        [contacts addObject:[[student firstContact] email]];
    }
    if (([student secondContact]) &&
        (([[[student secondContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame)) 
        && ([[student firstContact] email])) {
        [contacts addObject:[[student secondContact] email]];
    }
    if (([student otherContact]) &&
        (([[[student otherContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame)) 
        && ([[student otherContact] email])) {
        [contacts addObject:[[student otherContact] email]];
    }
    if ([contacts count] == 0) {
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information!",@"Information!") 
                                               message:NSLocalizedString(@"No contacts with email addresses to send student report to!",@"No contacts with email addresses to send student report to!") 
                                              delegate:nil 
                                     cancelButtonTitle:@"Got it!" 
                                     otherButtonTitles:nil];
        [alertView show];
    } else {
        NSString *report = [NSString stringWithFormat:@"%@, %@\n\n", [student firstName], [student lastName]];
        if ([sortedConductArray count] > 0) {
            report = [report stringByAppendingFormat:@"Conduct\n"];
            for (MWSConduct *eachConduct in sortedConductArray) {
                report = [report stringByAppendingFormat:@"\t%@", [eachConduct conductText]];
            }
            report = [report stringByAppendingFormat:@"\n\n"];
        }
        if ([sortedAttendanceAbsentArray count] > 0) {
           report = [report stringByAppendingFormat:@"Attendance (Days absent)\n"];
            for (MWSAttendance *eachAttendance in sortedAttendanceAbsentArray) {
                report = [report stringByAppendingFormat:@"\t%@\n", [df stringFromDate:[eachAttendance date]]];
            }
            report = [report stringByAppendingFormat:@"\n\n"];
        }
        if ([sortedStudentTests count] > 0) {
            NSString *testName;
            NSString *testDate;
            NSString *testGrade;
            report = [report stringByAppendingFormat:@"Tests\n"];
            for (MWSStudentTest *eachTest in sortedStudentTests) {
                testName = [[eachTest test] name];
                testDate = [df stringFromDate:[[eachTest test] date]];
                testGrade = [eachTest grade];
                report = [report stringByAppendingFormat:@"\t%@ - %@ (%@)", testGrade, testName, testDate];
            }
            report = [report stringByAppendingFormat:@"\n\n"];
        }
        if ([sortedStudentAssignments count] > 0) {
            NSString *assignmentName;
            NSString *assignmentDate;
            NSString *assignmentDone;
            report = [report stringByAppendingFormat:@"Assignments\n"];
            for (MWSStudentAssignment *eachStudentAssigment in sortedStudentAssignments) {
                if ([[eachStudentAssigment done] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame) {
                    assignmentDone = @"Not completed";
                } else {
                    assignmentDone = @"Completed";
                }
                assignmentName = [[eachStudentAssigment assignment] subject];
                assignmentDate = [df stringFromDate:[[eachStudentAssigment assignment] assignmentDate]];
                report = [report stringByAppendingFormat:@"\t%@\n", [NSString stringWithFormat:@"%@ - %@ (%@)", assignmentDone, assignmentName, assignmentDate]];
            }
            report = [report stringByAppendingFormat:@"\n\n"];
        }
        [[EmailSender sharedInstance] sendEmailTo:contacts 
                                          subject:@"Student Report" 
                                          message:report 
                                   withController:self];
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

