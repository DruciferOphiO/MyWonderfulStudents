//
//  MWSStudentAssignmentListViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/27/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentAssignmentListViewController.h"
#import "MWSCoreDataManager.h"
#import "MWSAssignment.h"
#import "MWSLabelTableCell.h"

static NSString *sortByFirstName = @"sortByFirstName";
static NSString *sortByLastName  = @"sortByLastName";
static NSString *sortById		 = @"sortById";

@implementation MWSStudentAssignmentListViewController
@synthesize theClass, df, assignmentListArray, studentListArray, tabBarController, helpIndex;
@synthesize enterAssignmentsDoneViewController;
@synthesize assignmentEditViewController;

#pragma mark -
#pragma mark init

- (id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *)theTabBarController forStudents:(NSArray *) studentList {
	if (self = [self initWithNibName:@"MWSStudentAssignmentListViewController" bundle:nil]) {
        theClass = aClass;
        
        tabBarController = theTabBarController;
        
        // sort the array
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
        [self setStudentListArray:[[NSMutableArray alloc] init]];
        [[self studentListArray] addObjectsFromArray:[[[[self theClass] students] allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
        
        [self setDf:[[NSDateFormatter alloc] init]];
        [[self df] setDateFormat:@"MM-dd-yyyy"];
        
        tabBarController = theTabBarController;
        
        [self setTitle:NSLocalizedString(@"Assignments",@"Assignments")];
        self.tabBarItem.image = [UIImage imageNamed:@"assign1.png"];
        
        [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]]];
    }
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Set up for swipe
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
		[buttons addObject:helpButtonItem];
	} else {
		buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
	}
    
    // new button
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newAssigment)];
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


	[self loadAssignments];
	[[self tableView] reloadData];
	
}

-(void)helpMe {
	UIAlertView *alertView;
	if (helpIndex > 2) helpIndex = 0;
		switch (helpIndex) {
			case 0:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Touch + to enter a new assignment!",@"Touch + to enter a new assignment!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 1:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Swipe a row to edit an assignment!",@"Swipe a row to edit an assignment!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 2:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Touch a row to enter assignments done!",@"Touch a row to enter assignments done!") 
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

- (void)loadAssignments {
	assignmentListArray = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"assignmentDate"
																	ascending:NO];
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subject"
																	ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nameDescriptor, nil];
	
	NSArray *sortedAssignments = [[[[self theClass] assignments] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
	if ([[theClass showDeletedAssignments] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		[[self assignmentListArray] addObjectsFromArray:sortedAssignments];
	} else {
		for (MWSAssignment *eachAssignment in sortedAssignments) {
			if ([[eachAssignment deleted] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
				[[self assignmentListArray] addObject:eachAssignment];
			}
		}
	}
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self assignmentListArray] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	MWSLabelTableCell *aLabelCell;
    
    aLabelCell = (MWSLabelTableCell *) [tableView dequeueReusableCellWithIdentifier:[MWSLabelTableCell reuseIndentifier]];
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MWSLabelTableCell" owner:nil options:nil];
	for (id currentObject in topLevelObjects) {
		if ([currentObject isKindOfClass:[UITableViewCell class]]) {
			aLabelCell = (MWSLabelTableCell *)currentObject;
		}
	}
    
	MWSAssignment *anAssignment = [[self assignmentListArray] objectAtIndex:[indexPath row]];
	aLabelCell.cellLabel.text = [NSString stringWithFormat:@"%@ (Due %@)", [anAssignment subject], [[self df] stringFromDate:[anAssignment dueDate]]];
	aLabelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return aLabelCell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MWSAssignment *anAssignment = [[self assignmentListArray] objectAtIndex:[indexPath row]];
    enterAssignmentsDoneViewController = [[MWSEnterAssignmentsDoneViewController alloc] initForAssignment:anAssignment forStudents:studentListArray inClass:theClass individualFlag:NO];
	[self.navigationController pushViewController:enterAssignmentsDoneViewController animated:YES];
}

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
	
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
		MWSAssignment *theAssignment = [[self assignmentListArray] objectAtIndex:[swipedIndexPath row]];
		assignmentEditViewController = [[MWSAssignmentEditViewController alloc] initWithClass:theClass andAssignment:theAssignment forStudents:[self studentListArray]];
		[self.navigationController pushViewController:assignmentEditViewController animated:YES];
	}
	
}

-(void)newAssigment {
	assignmentEditViewController = [[MWSAssignmentEditViewController alloc] initWithClass:theClass andAssignment:nil forStudents:[self studentListArray]];
	[self.navigationController pushViewController:assignmentEditViewController animated:YES];
	
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

