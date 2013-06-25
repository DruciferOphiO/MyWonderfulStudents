//
//  MWSStudentListViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/13/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentListViewController.h"

#import "MWSStudentStatusTableCell.h"
#import "MWSCoreDataManager.h"
#import "MWSStudent.h"
#import "StudentAnalyzer.h"
#import "MWSTeacherCell.h"

static NSString *sortByFirstName = @"sortByFirstName";
static NSString *sortByLastName  = @"sortByLastName";
static NSString *sortById		 = @"sortById";

@implementation MWSStudentListViewController

@synthesize theClass, studentListArray, aStudent, tabBarController, helpIndex;
@synthesize studentDetailViewController;
@synthesize studentEditViewController;

#pragma mark -
#pragma mark init

- (id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *)theTabBarController  {
	
	// Initialize the class and student lists object
	theClass = aClass;
	
	tabBarController = theTabBarController;
	[self buildStudentListArray];
	
	[self setTitle:NSLocalizedString(@"Students",@"My Wonderful Students")];
	self.tabBarItem.image = [UIImage imageNamed:@"students1.png"];
	
	[[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]]];
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set up the swipe for teacher
	UISwipeGestureRecognizer *recognizer;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
	[[self tableView] addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	UIToolbar *buttonContainer;
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
	if ([[[theClass myTeacher] showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
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
    
    // new button
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudent)];
    [buttons addObject:buttonItem];
	
	if ([buttons count] >0) {
		// put the buttons in the toolbar and release them
		[buttonContainer setItems:buttons animated:NO];
		// place the toolbar into the navigation bar
		[tabBarController navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc]
																initWithCustomView:buttonContainer];
	} else {
		[tabBarController navigationItem].rightBarButtonItem = nil;
	}
	
	[self buildStudentListArray];
	[[self tableView] reloadData];
}

-(void)helpMe {
	
	UIAlertView *alertView;
	if ([[theClass students] count] == 0) {
		alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
											   message:NSLocalizedString(@"Touch + button to add a student!",@"Touch + button to add a student!") 
											  delegate:nil 
									 cancelButtonTitle:@"Got it!" 
									 otherButtonTitles:nil];
	} else {
		if (helpIndex > 3) helpIndex = 0;
		switch (helpIndex) {
			case 0:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"GOLD-Great BLUE-Good GREEN-Average YELLOW-Less than average RED-Bad",@"GOLD-Great BLUE-Good GREEN-Average YELLOW-Less than average RED-Bad") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 1:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Swipe a student to edit!",@"Swipe a row to edit!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 2:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Touch + button to add a new student!",@"Touch + button to add a student!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 3:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Touch a row to enter student summary!",@"Touch a row to enter student summary!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			default:
				break;
		}
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
	NSArray *sortedStudents = [[[[self theClass] students] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
	if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		[[self studentListArray] addObjectsFromArray:sortedStudents];
	} else {
		for (MWSStudent *eachStudent in sortedStudents) {
			if ([[eachStudent deleted] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
				[[self studentListArray] addObject:eachStudent];
			}
		}
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [studentListArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	

	MWSStudentStatusTableCell *aStudentCell;
	
	aStudentCell = (MWSStudentStatusTableCell *) [tableView dequeueReusableCellWithIdentifier:[MWSStudentStatusTableCell reuseIndentifier]];
	if (aStudentCell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MWSStudentStatusTableCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				aStudentCell = (MWSStudentStatusTableCell *)currentObject;
			}
		}
	}
	MWSStudent *cellStudent = [[self studentListArray] objectAtIndex:[indexPath row]];
	if ([[[self theClass] sortBy] compare:sortByFirstName] == NSOrderedSame) {
		[[aStudentCell studentName] setText:[NSString stringWithFormat:@"%@ %@", [cellStudent firstName], [cellStudent lastName]]];
	} else if ([[[self theClass] sortBy] compare:sortByLastName] == NSOrderedSame) {
		[[aStudentCell studentName] setText:[NSString stringWithFormat:@"%@, %@", [cellStudent lastName], [cellStudent firstName]]];
	} else if ([[[self theClass] sortBy] compare:sortById] == NSOrderedSame) {
		[[aStudentCell studentName] setText:[NSString stringWithFormat:@"%@ - %@, %@", 
											 [cellStudent idNumber] ? [cellStudent idNumber] : @"No ID", 
											 [cellStudent lastName], 
											 [cellStudent firstName]]];
	}
	aStudentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	StudentAnalyzer *studentAnalyzer = [[StudentAnalyzer alloc] init];
	[[aStudentCell attendanceIndicator] setTextColor:[studentAnalyzer attendanceStatusColorForStudent:cellStudent]];
	[[aStudentCell conductIndicator] setTextColor:[studentAnalyzer conductStatusColorForStudent:cellStudent]];
	[[aStudentCell testsIndicator] setTextColor:[studentAnalyzer testStatusColorForStudent:cellStudent]];
	[[aStudentCell assignmentsIndicator] setTextColor:[studentAnalyzer assignmentStatusColorForStudent:cellStudent]];
	
	return aStudentCell;
}

- (void)addStudent {
	studentEditViewController = [[MWSStudentEditViewController alloc] initStudent:[self aStudent] forClassName:[self theClass]];
	[self.navigationController pushViewController:studentEditViewController animated:YES];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    MWSStudent *selectedStudent = [[self studentListArray] objectAtIndex:[indexPath row]];
	studentDetailViewController = [[MWSStudentDetailViewController alloc] initStudent:selectedStudent forClassName:[self theClass]];
	[self.navigationController pushViewController:studentDetailViewController animated:YES];
	
}

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        MWSStudent *selectedStudent = [[self studentListArray] objectAtIndex:[swipedIndexPath row]];
        studentEditViewController = [[MWSStudentEditViewController alloc] initStudent:selectedStudent forClassName:[self theClass]];
		[self.navigationController pushViewController:studentEditViewController animated:YES];
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

