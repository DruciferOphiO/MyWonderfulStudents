//
//  MWSStudentSearchViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 7/16/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudentSearchViewController.h"
#import "MWSCoreDataManager.h"
#import "MWSContact.h"
#import "MWSLabelTableCell.h"

@implementation MWSStudentSearchViewController
@synthesize fetchedResultsController, theClass, delegate;

#pragma mark -
#pragma mark View lifecycle

#pragma mark -
#pragma mark init

- (id)initForClass:(MWSClass *)aClass  withDelegate:(id)theDelegate {
	
	// set the class
	theClass = aClass;
    
    // set the delegate
    [self setDelegate:theDelegate];
	
	// load the fetched results
	[self reloadFetchedResults];
	
	[self setTitle:NSLocalizedString(@"Students",@"My Wonderful Students")];
	
	[[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]]];
	
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

- (void)reloadFetchedResults {
	if (fetchedResultsController != nil) {
		fetchedResultsController = nil;
	}
	[self setFetchedResultsController:[[MWSCoreDataManager sharedInstance] getFetchedResultsControllerForStudentsNotInClass:theClass]];
	[[self fetchedResultsController] setDelegate:self];
	NSError *error = nil;
	@try {
		[[self fetchedResultsController] performFetch:&error];
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
	}
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
    return [[fetchedResultsController fetchedObjects] count];
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
    
    MWSStudent *aStudent = [fetchedResultsController objectAtIndexPath:indexPath];
	aLabelCell.cellLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)", 
							   [aStudent firstName], [aStudent lastName], [[aStudent myClass] myClassName]];
    
    return aLabelCell;
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
    MWSStudent *aStudent = [fetchedResultsController objectAtIndexPath:indexPath];
	MWSStudent *copiedStudent = [self copyStudent:aStudent];
	[delegate resetTheStudent:copiedStudent];
	[self.navigationController popViewControllerAnimated:YES];
}

-(MWSStudent *)copyStudent:(MWSStudent *)student {
	MWSStudent *copiedStudent = [[MWSCoreDataManager sharedInstance] newStudent];
	[copiedStudent setLastName:[student lastName]];
	[copiedStudent setFirstName:[student firstName]];
	[copiedStudent setIdNumber:[student idNumber]];
	[copiedStudent setSpclNeeds:[student spclNeeds]];
	[copiedStudent setPrincipalNotify:[student principalNotify]];
	[copiedStudent setHealthAlert:[student healthAlert]];
	[copiedStudent setEmail:[student email]];
	if ([student firstContact]) {
		[copiedStudent setFirstContact:[self copyContact:[student firstContact]]];
		[[copiedStudent firstContact] setFirstContact:copiedStudent];
	}
	if ([student secondContact]) {
		[copiedStudent setSecondContact:[self copyContact:[student secondContact]]];
		[[copiedStudent secondContact] setFirstContact:copiedStudent];
	}
	if ([student otherContact]) {
		[copiedStudent setOtherContact:[self copyContact:[student otherContact]]];
		[[copiedStudent otherContact] setOtherContact:copiedStudent];
	}
	[copiedStudent setDeleted:[NSNumber numberWithInt:0]];
	[copiedStudent setMyClass:theClass];
	[copiedStudent setMyClassName:[theClass myClassName]];
	
	return copiedStudent;
}

-(MWSContact *)copyContact:(MWSContact *)contact {
	MWSContact *copiedContact = [[MWSCoreDataManager sharedInstance] newContact];
	[copiedContact setNotifyByEmail:[contact notifyByEmail]];
	[copiedContact setLastName:[contact lastName]];
	[copiedContact setFirstName:[contact firstName]];
	[copiedContact setNotifyByEmail:[contact notifyByEmail]];
	[copiedContact setIsChanged:[NSNumber numberWithInt:0]];
	[copiedContact setNotifyForConduct:[contact notifyForConduct]];
	[copiedContact setNotifyByEmail:[contact notifyByEmail]];
	[copiedContact setTextNumber:[contact textNumber]];
	[copiedContact setDeleted:[NSNumber numberWithInt:0]];
	[copiedContact setNotifyForTests:[contact notifyForTests]];
	[copiedContact setNotifyByText:[contact notifyByText]];
	[copiedContact setNotifyByEmail:[contact notifyByEmail]];
	[copiedContact setNotifyForAttendance:[contact notifyForAttendance]];
	[copiedContact setPhoneNumber:[contact phoneNumber]];
	[copiedContact setNotifyByEmail:[contact notifyByEmail]];
	[copiedContact setEmail:[contact email]];
	
	return copiedContact;
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

