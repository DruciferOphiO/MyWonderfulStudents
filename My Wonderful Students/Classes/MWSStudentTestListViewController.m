//
//  MWSStudentTestListViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 3/27/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentTestListViewController.h"
#import "MWSCoreDataManager.h"
#import "MWSLabelTableCell.h"

@implementation MWSStudentTestListViewController

@synthesize theClass, tabBarController, testListArray, aStudent, helpIndex;
@synthesize testEditViewController;
@synthesize enterTestGradesViewController;

#pragma mark -
#pragma mark init

- (id)initForClass:(MWSClass *)aClass withTabBarController:(UITabBarController *)theTabBarController  {
	
	theClass = aClass;
	
	tabBarController = theTabBarController;
	
	[self setTitle:NSLocalizedString(@"Tests",@"Tests")];
	self.tabBarItem.image = [UIImage imageNamed:@"tests1.png"];
	
	[[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]]];
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// set up for swipe
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
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTest)];
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

	
	[self loadTests];
	[[self tableView] reloadData];
	
}

-(void)helpMe {
	UIAlertView *alertView;
	if (helpIndex > 2) helpIndex = 0;
	switch (helpIndex) {
		case 0:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch + to enter a new test!",@"Touch + to enter a new test!") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 1:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Swipe a row a test to edit!",@"Swipe a row to edit a test!") 
												  delegate:nil 
										 cancelButtonTitle:@"Got it!" 
										 otherButtonTitles:nil];
			helpIndex++;
			break;
		case 2:
			alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
												   message:NSLocalizedString(@"Touch a test to enter test scores!",@"Touch a row to enter test scores!") 
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

- (void)loadTests {
	testListArray = [[NSMutableArray alloc] init];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
																	ascending:NO];
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
																	ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nameDescriptor, nil];
	NSArray *sortedStudents = [[[[self theClass] tests] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
	if ([[theClass showDeletedTests] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		[[self testListArray] addObjectsFromArray:sortedStudents];
	} else {
		for (MWSTest *eachTest in sortedStudents) {
			if ([[eachTest deleted] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
				[[self testListArray] addObject:eachTest];
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
    return [[self testListArray] count];
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
    
	MWSTest *aTest = [[self testListArray] objectAtIndex:[indexPath row]];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM-dd-yyyy"];
	aLabelCell.cellLabel.text = [NSString stringWithFormat:@"%@ (%@)", [aTest name], [df stringFromDate:[aTest date]]];
	aLabelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return aLabelCell;
}

- (void)addTest {
	testEditViewController = [[MWSTestEditViewController alloc] initForTest:nil inClass:theClass];
	[self.navigationController pushViewController:testEditViewController animated:YES];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MWSTest *aTest = [[self testListArray] objectAtIndex:[indexPath row]];
	enterTestGradesViewController = [[MWSEnterTestGrades alloc] initForTest:aTest inClass:theClass];
	[self.navigationController pushViewController:enterTestGradesViewController animated:YES];
}

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
	
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        MWSTest *aTest = [[self testListArray] objectAtIndex:[swipedIndexPath row]];
		testEditViewController = [[MWSTestEditViewController alloc] initForTest:aTest inClass:theClass];
		[self.navigationController pushViewController:testEditViewController animated:YES];
		
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

