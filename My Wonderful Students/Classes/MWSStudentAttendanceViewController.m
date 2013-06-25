//
//  MWSStudentAttendance.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/27/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentAttendanceViewController.h"
#import "MWSCoreDataManager.h"
#import "MWSStudentEditViewController.h"
#import "MWSAttendance.h"
#import "EmailSender.h"
#import "TextSender.h"
#import "MWSLabelTableCell.h"

static NSString *sortByFirstName = @"sortByFirstName";
static NSString *sortByLastName  = @"sortByLastName";
static NSString *sortById		 = @"sortById";

@implementation MWSStudentAttendanceViewController
@synthesize theClass, theTeacher, studentListArray, attendanceArray, aStudent, theDate, theDatePicker, tabBarController, buttonItem, savedTextRecipients, savedMessage, helpIndex;
#pragma mark -
#pragma mark init

- (id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *)theTabBarController {
	
	// Initialize the class, teacher and student lists object
	theClass = aClass;
	[self setTheTeacher:[[self theClass] myTeacher]];
	
	tabBarController = theTabBarController;
	[self buildStudentListArray];
	
	// set the date to today
	[self setTheDate:[NSDate date]];
	
	[self setTitle:NSLocalizedString(@"Attendance",@"Attendance")];
	self.tabBarItem.image = [UIImage imageNamed:@"attendence1.png"];
	
	[[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]]];
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set up the swipe
	UISwipeGestureRecognizer *recognizer;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
	[[self tableView] addGestureRecognizer:recognizer];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	UIToolbar *buttonContainer;
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
	if ([[[theClass myTeacher] showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
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
    
    buttonItem = [[UIBarButtonItem alloc] 
                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                  target:self 
                  action:@selector(save)];
    [buttons addObject:buttonItem];
	
	if ([buttons count] > 0) {
		// put the buttons in the toolbar and release them
		[buttonContainer setItems:buttons animated:NO];
		// place the toolbar into the navigation bar
		tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
												  initWithCustomView:buttonContainer];
	}

	
	// allocate the attendance array
	[self setAttendanceArray:[NSMutableArray arrayWithCapacity:[[self studentListArray] count]]];
	// build the attendance array for today
	[self buildAttendanceArrayForDate:theDate];
	[[self tableView] reloadData];
	
}

-(void)helpMe {
	UIAlertView *alertView;
	if (helpIndex > 2) helpIndex = 0;
	switch (helpIndex) {
		case 0:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch SAVE button to save changes!",@"Touch SAVE button to save changes!") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 1:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch date to select new date!",@"Touch date to select new date!") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 2:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch a student row to mark absent or present!",@"Touch a student row to mark absent or present!") 
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

-(void)buildStudentListArray {
	
	studentListArray = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor;
	if ([[[self theClass] sortBy] compare:sortByFirstName] == NSOrderedSame) {
		sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName"
													  ascending:YES];
	} else if ([[[self theClass] sortBy] compare:sortByLastName] == NSOrderedSame) {
		sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName"
													  ascending:YES];
	} else if ([[[self theClass] sortBy] compare:sortById] == NSOrderedSame) {
		sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idNumber"
													  ascending:YES];
	}
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[[self studentListArray] addObjectsFromArray:[[[[self theClass] students] allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
	
	
	NSMutableArray *workArray = [[NSMutableArray alloc] init];
	[workArray addObjectsFromArray:[self studentListArray]];
	if ([[[self theClass] showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
		for (MWSStudent *eachStudent in workArray) {
			if ([[eachStudent deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				[[self studentListArray] removeObject:eachStudent];
			}
		}
	}
	// Don't know why the f&^% filtered array is not working
	// not getting the right deleted flag from db
	//NSArray *sortedAndFilteredStudentArray;
//	NSPredicate *deletedPredicate = [NSPredicate predicateWithFormat:@"deleted = 0"];;
//	// load the attendance array for the date passed in
//	if ([[[self theClass] showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
//		sortedAndFilteredStudentArray = [[self studentListArray] filteredArrayUsingPredicate:deletedPredicate];
//		[[self studentListArray] removeAllObjects];
//		[[self studentListArray] addObjectsFromArray:[NSArray arrayWithArray:sortedAndFilteredStudentArray]];
//	}
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	
	// activate the add button
	[[[tabBarController navigationItem] rightBarButtonItem] setEnabled:YES];
	
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self studentListArray] count] + 1;
}
  

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   MWSLabelTableCell *aLabelCell;
	
	if ([indexPath row] == 0) {
		aLabelCell = (MWSLabelTableCell *) [tableView dequeueReusableCellWithIdentifier:[MWSLabelTableCell reuseIndentifier]];
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MWSLabelTableCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				aLabelCell = (MWSLabelTableCell *)currentObject;
			}
		}
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"MM-dd-yyyy"];
		aLabelCell.cellLabel.text = [df stringFromDate:[self theDate]];
        [aLabelCell textLabel].textAlignment = NSTextAlignmentCenter;
	}
	else {
		aLabelCell = (MWSLabelTableCell *) [tableView dequeueReusableCellWithIdentifier:[MWSLabelTableCell reuseIndentifier]];
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MWSLabelTableCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				aLabelCell = (MWSLabelTableCell *)currentObject;
			}
		}
		NSIndexPath *oneRowBack = [NSIndexPath indexPathForRow:[indexPath row] - 1 inSection:[indexPath section]];
		[self setAStudent:[[self studentListArray] objectAtIndex:[oneRowBack row]]];
		aLabelCell.cellLabel.text = [NSString stringWithFormat:@"%@ %@", [aStudent firstName], [aStudent lastName]];
		MWSAttendance *anAttendance = [attendanceArray objectAtIndex:[oneRowBack row]];
		if ([[anAttendance isPresent] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			aLabelCell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			aLabelCell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
    
    return aLabelCell;
}


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
		return;
	}
	
	if ([indexPath row] == 0) {
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
		
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Set Date" 
																  delegate:self 
														 cancelButtonTitle:@"OK" 
													destructiveButtonTitle:@"Cancel" 
														 otherButtonTitles:nil];
		[actionSheet bringSubviewToFront:self.theDatePicker];
		[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[actionSheet showInView:[self.view superview]];
		[actionSheet addSubview:theDatePicker];
		[actionSheet sendSubviewToBack:theDatePicker];
		[actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
		[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
		
		
		[self findAndResignFirstResponder];
		
	} else {
		// get the student (one row back)
		NSIndexPath *oneRowBack = [NSIndexPath indexPathForRow:[indexPath row] - 1 inSection:[indexPath section]];
		[self setAStudent:[[self studentListArray] objectAtIndex:[oneRowBack row]]];NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
		[formatter1 setDateFormat:@"MM-dd-yyyy"];
		// change the students attendance flag from present/absent/etc
		MWSAttendance *anAttendance = [attendanceArray objectAtIndex:[oneRowBack row]];
		if ([[anAttendance isPresent] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			[anAttendance setIsPresent:[NSNumber numberWithInt:0]];
		} else {
			[anAttendance setIsPresent:[NSNumber numberWithInt:1]];
		}
		
		[[MWSCoreDataManager sharedInstance] saveContext];
		
		if ([[theClass sendAttendanceNotification] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			
			NSMutableArray *emailRecipients = [[NSMutableArray alloc] init];
			savedTextRecipients = [[NSMutableArray alloc] init];
			
			if ([aStudent firstContact]) {
				if ([[[aStudent firstContact] notifyForAttendance] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[aStudent firstContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[aStudent firstContact] email])) {
						[emailRecipients addObject:[[aStudent firstContact] email]];
					}
					if ([[[aStudent firstContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
						if (([[[aStudent firstContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
							&& ([[aStudent firstContact] textNumber])) {
							[savedTextRecipients addObject:[[aStudent firstContact] textNumber]];
						}
					}
				}
			}
			if ([aStudent secondContact]) {
				if ([[[aStudent secondContact] notifyForAttendance] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[aStudent secondContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[aStudent secondContact] email])) {
						[emailRecipients addObject:[[aStudent secondContact] email]];
					}
					if ([[[aStudent secondContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
						if (([[[aStudent secondContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
							&& ([[aStudent secondContact] textNumber])) {
							[savedTextRecipients addObject:[[aStudent secondContact] textNumber]];
						}
					}
				}
			}
			if ([aStudent otherContact]) {
				if ([[[aStudent otherContact] notifyForAttendance] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[aStudent otherContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[aStudent otherContact] email])) {
						[emailRecipients addObject:[[aStudent otherContact] email]];
					}
					if ([[[aStudent otherContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
						if (([[[aStudent otherContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
							&& ([[aStudent otherContact] textNumber])) {
							[savedTextRecipients addObject:[[aStudent otherContact] textNumber]];
						}
					}
				}
			}
			if ([[aStudent principalNotify] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				if ([[self theTeacher] principalEmail]) {
					[emailRecipients addObject:[[self theTeacher] principalEmail]];
				}
			}
			NSString *message;
			if ([[anAttendance isPresent] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
				message = [NSString stringWithFormat:@"%@ %@ was marked absent on %@ for class %@", 
						   [aStudent firstName], 
						   [aStudent lastName], 
						   [formatter1 stringFromDate:[NSDate date]], 
						   [theClass myClassName]];
			} else {
				message = [NSString stringWithFormat:@"%@ %@ was marked as present on %@ for class %@", 
						   [aStudent firstName], 
						   [aStudent lastName], 
						   [formatter1 stringFromDate:[NSDate date]], 
						   [theClass  myClassName]];
			}
			
			if ([emailRecipients count] > 0) {
				// got emails to send and no text messages to send
				[[EmailSender sharedInstance] sendEmailTo:emailRecipients 
												  subject:@"Attendance Notification" 
												  message:message 
										   withController:self];
			} 
			
			if ([savedTextRecipients count] == 0) {
				savedTextRecipients = nil;
			} else {
				UIAlertView *alertView = [[UIAlertView alloc] 
										  initWithTitle:NSLocalizedString(@"Information!",@"Information!") 
										  message:[NSString stringWithFormat:@"Touch %@ %@ row again to send text message(s).", 
													[aStudent firstName], 
													[aStudent lastName]]
										  delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
				[alertView show];
				savedMessage = message;
			}
		}
	}
	[self findAndResignFirstResponder];
	[[self tableView] reloadData];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		
		// abandon any updates because there is a new date to work with
		[[MWSCoreDataManager sharedInstance] abandonChanges];
		
		NSDate *newDate = [theDatePicker date];
		[self setTheDate: newDate];
		
		// build student list array
		[self buildStudentListArray];
		
		// re-build the attendance array for new date
		[self setAttendanceArray:[NSMutableArray arrayWithCapacity:[[self studentListArray] count]]];
		[self buildAttendanceArrayForDate:newDate];
		[[self tableView] reloadData];
		
	}
}

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
	
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
		NSIndexPath *oneRowBack = [NSIndexPath indexPathForRow:[swipedIndexPath row] - 1 inSection:[swipedIndexPath section]];
		MWSStudentEditViewController *studentEditViewController;
		[self setAStudent:[[self studentListArray] objectAtIndex:[oneRowBack row]]];
		studentEditViewController = [studentEditViewController initStudent:aStudent forClassName:theClass];
		[self.navigationController pushViewController:studentEditViewController animated:YES];
		
	}
	
}

-(void)save {
	
	if (savedTextRecipients) {
		[[TextSender sharedInstance] sendTextTo:savedTextRecipients 
										message:savedMessage 
								 withController:self];
		savedMessage = nil;
		savedTextRecipients = nil;
		[self findAndResignFirstResponder];
	}
	// save context
	[[MWSCoreDataManager sharedInstance] saveContext];
}


#pragma mark -
#pragma mark Custom methods

-(void)buildAttendanceArrayForDate:(NSDate *)aDate {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM-dd-yyyy"];
	NSString *passedDateString = [df stringFromDate:aDate];
	NSString *compareDateString;
	
	BOOL gotOne = NO;
	int theIndex = 0;
	MWSAttendance *newAttendance;
	//NSArray *sortedAndFilteredStudentArray;
//	NSPredicate *deletedPredicate = [NSPredicate predicateWithFormat:@"deleted = 0"];;
//	// load the attendance array for the date passed in
//	if ([[[self theClass] showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
//		sortedAndFilteredStudentArray = [[self studentListArray] filteredArrayUsingPredicate:deletedPredicate];
//		[[self studentListArray] removeAllObjects];
//		[[self studentListArray] addObjectsFromArray:[NSArray arrayWithArray:sortedAndFilteredStudentArray]];
//	}	
	NSMutableArray *workArray = [NSMutableArray arrayWithCapacity:(52 * 5)];
	[workArray addObjectsFromArray:[self studentListArray]];
	// load the attendance array for the date passed in//
	// Don't know why the f&^$ filtered array doesn't work
//	if ([[[self theClass] showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
//		for (MWSStudent *eachStudent in workArray) {
//			if ([[eachStudent deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
//				[[self studentListArray] removeObject:eachStudent];
//			}
//		}
//	}
	for (MWSStudent *eachStudent in [self studentListArray]) {
		gotOne = NO;
		[workArray removeAllObjects];
		[workArray addObjectsFromArray:[[eachStudent attendance] allObjects]];
		for (MWSAttendance *aDay in [eachStudent attendance]) {
			compareDateString = [df stringFromDate:[aDay date]];
			if ([passedDateString compare:compareDateString] == NSOrderedSame) {
				gotOne = YES;
				[attendanceArray addObject:aDay];
				break;
			}
		}
		if (! gotOne) {
			newAttendance = [[MWSCoreDataManager sharedInstance] getNewAttendance];
			[newAttendance setDate:aDate];
			[newAttendance setIsPresent:[NSNumber numberWithInt:1]];
			[newAttendance setStudent:eachStudent];
			[attendanceArray addObject:newAttendance];
			[workArray addObject:newAttendance];
			[eachStudent setAttendance:[NSSet setWithArray:workArray]];
		}
		theIndex++;
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

