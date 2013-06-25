//
//  MWSClassesListViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 2/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSClassesListViewController.h"
#import "MWSTeacherCell.h"
#import "MWSCoreDataManager.h"
#import "MWSLabelTableCell.h"

@implementation MWSClassesListViewController

@synthesize fetchedResultsController;
@synthesize tabBarController;
@synthesize teacher;
@synthesize helpIndex;

@synthesize classEditViewController;
@synthesize detailViewController;
@synthesize studentListViewController;
@synthesize studentAttendance;
@synthesize studentTestList;
@synthesize studentAssignmentList;

#pragma mark -
#pragma mark init

- (id)init  {
    if (self = [self initWithNibName:@"MWSClassesListViewController" bundle:nil]) {
        // title
        [self setTitle:NSLocalizedString(@"Classes",@"Classes title")];
        
        // Initialize the teacher object
        if (teacher == nil) {
            teacher = [[MWSCoreDataManager sharedInstance] getTeacher];
        }
        
        // load the fetched results
        [self reloadFetchedResults];
        
        //            set the nav bar buttons
        // array to hold buttons
        // create the toolbar to place buttons
        UIToolbar *buttonContainer;
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
        // the help button
        if ([[teacher showHelp] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
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
        
        // the add a new new class button
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                       target:self
                                       action:@selector(addClass)];
        [buttons addObject:buttonItem];
        
        if ([buttons count] > 0) {
            // put the buttons in the toolbar and release them
            [buttonContainer setItems:buttons animated:NO];
            // place the toolbar into the navigation bar
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithCustomView:buttonContainer];
        }
        
        // alloc the tab bar controller
        tabBarController = [[UITabBarController alloc] init];
        
        // set the background image
        [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]]];
    }
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// set up the swipe action
	UISwipeGestureRecognizer *recognizer;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
	[[self tableView] addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated {
	[self reloadFetchedResults];
	[[self tableView] reloadData];
	[super viewWillAppear:animated];
	
 }

- (void)reloadFetchedResults {
	
	// Get rid of the old one
	if (fetchedResultsController != nil) {
		fetchedResultsController = nil;
	}
	// build a new one
	[self setFetchedResultsController:[[MWSCoreDataManager sharedInstance] getFetchedResultsControllerForClassesForTeacher:teacher]];
	[[self fetchedResultsController] setDelegate:self];
	
	// load it up
	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
	if (error != nil) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fetch for class failed" message:@"Fetch for class failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
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
	int cellCount = [[fetchedResultsController fetchedObjects] count];
	// add one for the teacher cell
    return cellCount + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	MWSTeacherCell *aTeacherCell;
	MWSLabelTableCell *aLabelCell;

	if ([indexPath row] == 0) {
		// the first row is a teacher cell
		aTeacherCell = (MWSTeacherCell *) [tableView dequeueReusableCellWithIdentifier:[MWSTeacherCell reuseIndentifier]];
		if (aTeacherCell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MWSTeacherCell" owner:nil options:nil];
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[UITableViewCell class]]) {
					aTeacherCell = (MWSTeacherCell *)currentObject;
				}
			}
		}
		if (([teacher firstName]  == nil) || ([[teacher firstName] length] == 0)) {
			aTeacherCell.teacherName.text = NSLocalizedString(@"Touch to enter teacher info",@"Touch to enter teacher info");
			aTeacherCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			aTeacherCell.teacherName.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", 
											 ([teacher title] == nil ? @"" : [teacher title]), 
											 ([teacher firstName] == nil ? @"" : [teacher firstName]), 
											 ([teacher middleName] == nil ? @"" : [teacher middleName]),
											 ([teacher lastName] == nil ? @"" : [teacher lastName]), 
											 ([teacher nameSuffix] == nil ? @"" : [teacher nameSuffix])];
			aTeacherCell.accessoryType = UITableViewCellAccessoryNone;
		}
		cell = aTeacherCell;
	} else {
		aLabelCell = (MWSLabelTableCell *) [tableView dequeueReusableCellWithIdentifier:[MWSLabelTableCell reuseIndentifier]];
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MWSLabelTableCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				aLabelCell = (MWSLabelTableCell *)currentObject;
			}
		}
		NSIndexPath *oneRowBack = [NSIndexPath indexPathForRow:[indexPath row] - 1 inSection:[indexPath section]];
		MWSClass *theClass = [[self fetchedResultsController] objectAtIndexPath:oneRowBack];
		aLabelCell.cellLabel.text = [theClass myClassName]; 
		aLabelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell = aLabelCell;
	}
    
    return cell;
}

-(void)editDone {
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] == 0) {
        if (([[teacher firstName] length] < 1) && ([[teacher lastName] length] < 1)) {
            detailViewController = [[MWSTeacherViewController alloc] initWithTeacher:teacher];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        [[self tableView] reloadData];
	} else {
		
		// get the class
		NSIndexPath *oneRowBack = [NSIndexPath indexPathForRow:[indexPath row] - 1 inSection:[indexPath section]];
		MWSClass *theClass = [[self fetchedResultsController] objectAtIndexPath:oneRowBack];

		// First item in the tab is student list
		studentListViewController = [[MWSStudentListViewController alloc] initForClass:theClass withTabBarController:tabBarController];
		
		// Second item in the tab is attendance
		studentAttendance = [[MWSStudentAttendanceViewController alloc] initForClass:theClass withTabBarController:tabBarController];
		
		// Third item in the tab is Tests
		studentTestList = [[MWSStudentTestListViewController alloc] initForClass:theClass withTabBarController:tabBarController];
		
		// Fourth item in the tab is assignmebnts
		studentAssignmentList = [[MWSStudentAssignmentListViewController alloc] initForClass:theClass withTabBarController:tabBarController forStudents:[[theClass students] allObjects]];
		
		NSArray *viewControlers = [NSArray arrayWithObjects:studentListViewController, studentAttendance, studentTestList, studentAssignmentList, nil];
		[tabBarController setViewControllers:viewControlers];
		[tabBarController setTitle:[theClass myClassName]];
		
		[self.navigationController pushViewController:tabBarController animated:YES];
	}
}

- (void)addClass {
	// if teacher infor hasn't been entered navigate to the teacher screen instead of class
	if (([teacher lastName] == nil) || ([[teacher lastName] length] == 0)) {
		detailViewController = [[MWSTeacherViewController alloc] initWithTeacher:teacher];
		[self.navigationController pushViewController:detailViewController animated:YES];
	} else {
		classEditViewController = [[MWSClassEditViewController alloc] initClassWithTeacher:teacher forClassName:nil];
		[self.navigationController pushViewController:classEditViewController animated:YES];
	}
}

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
	
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        //UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        if ([swipedIndexPath row] == 0) {
			detailViewController = [[MWSTeacherViewController alloc] initWithTeacher:teacher];
			[self.navigationController pushViewController:detailViewController animated:YES];
		} else  {
			NSIndexPath *oneRowBack = [NSIndexPath indexPathForRow:[swipedIndexPath row] - 1 inSection:[swipedIndexPath section]];
			MWSClass *swipedClass = [[self fetchedResultsController] objectAtIndexPath:oneRowBack];
			classEditViewController = [[MWSClassEditViewController alloc] initClassWithTeacher:teacher forClassName:[swipedClass myClassName]];
			[self.navigationController pushViewController:classEditViewController animated:YES];
		}

	}
	
}

-(void)helpMe {
	UIAlertView *alertView;
	if ([[[teacher lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
		alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
											   message:NSLocalizedString(@"Touch + button to add teacher info!",@"Touch + button to add personal info!") 
											  delegate:nil 
									 cancelButtonTitle:@"Got it!" 
									 otherButtonTitles:nil];
	} else {
		if (helpIndex > 3) helpIndex = 0;
		switch (helpIndex) {
			case 0:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Touch + button to add a new class!",@"Touch + button to add a class!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 1:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Swipe a class row to edit!",@"Swipe a row to edit!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 2:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
													   message:NSLocalizedString(@"Touch a class row to enter class!",@"Touch a row for students!") 
													  delegate:nil 
											 cancelButtonTitle:@"Got it!" 
											 otherButtonTitles:nil];
				helpIndex++;
				break;
			case 3:
				alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Turn Help off/on!",@"Turn Help off/on!") 
													   message:NSLocalizedString(@"Swipe first row and go to Settings!",@"Swipe first row and go to Settings!") 
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


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

@end

