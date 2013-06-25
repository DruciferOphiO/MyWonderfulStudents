//
//  MWSEnterAssignmentsDoneViewController.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/6/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSEnterAssignmentsDoneViewController.h"
#import "MWSStudentAssignment.h"
#import "MWSCoreDataManager.h"
#import "EmailSender.h"
#import "TextSender.h"
#import "MWSTeacher.h"
#import "MWSClass.h"
#import "MWSLabelTableCell.h"
#import "MWSStudent.h"

static NSString *sortByFirstName = @"sortByFirstName";
static NSString *sortByLastName  = @"sortByLastName";
static NSString *sortById		 = @"sortById";

@implementation MWSEnterAssignmentsDoneViewController

@synthesize theAssignment, theStudentAssignmentList, buttonContainer, buttonItem, savedTextRecipients, savedMessage;

#pragma mark -
#pragma mark View lifecycle

-(id)initForAssignment:(MWSAssignment *)anAssignment forStudents:(NSArray *)studentListArray inClass:(MWSClass *)theClass individualFlag:(BOOL)individual {
    if (self = [self initWithNibName:@"MWSEnterAssignmentsDoneViewController" bundle:nil]) {
        
        [self setTheAssignment:anAssignment];
        [self setTitle:[anAssignment subject]];
        
        // sort the array
        NSSortDescriptor *sortDescriptor;
        if ([[[[[[self theStudentAssignmentList] objectAtIndex:0] student] myClass] sortBy] compare:sortByFirstName] == NSOrderedSame) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                                         ascending:YES];
        } else if ([[[[[[self theStudentAssignmentList] objectAtIndex:0] student] myClass] sortBy] compare:sortByLastName] == NSOrderedSame) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName"
                                                         ascending:YES];
        } else if ([[[[[[self theStudentAssignmentList] objectAtIndex:0] student] myClass] sortBy] compare:sortById] == NSOrderedSame) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idNumber"
                                                         ascending:YES];
        }
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedStudentList = [studentListArray sortedArrayUsingDescriptors:sortDescriptors];
        NSArray *sortedAndFilteredStudentList;
        
        NSMutableArray *workArray = [[NSMutableArray alloc] init];
        [workArray addObjectsFromArray:sortedStudentList];
        if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
            for (int indx = 0; indx < [sortedStudentList count]; indx++) {
                if ([[sortedStudentList objectAtIndex:indx] isKindOfClass:[MWSStudentAssignment class]]) {
                    if ([[[[sortedStudentList objectAtIndex:indx] student] deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                        [workArray removeObject:[sortedStudentList objectAtIndex:indx]];
                    }
                }
                if ([[sortedStudentList objectAtIndex:indx] isKindOfClass:[MWSStudent class]]) {
                    if ([[[sortedStudentList objectAtIndex:indx] deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                        [workArray removeObject:[sortedStudentList objectAtIndex:indx]];
                    }
                }
            }
        }
        sortedStudentList = [NSArray arrayWithArray:workArray];
        sortedAndFilteredStudentList = [NSArray arrayWithArray:sortedStudentList];
        // Don't know why the f%$# the filter predicate doesn't work
        //NSPredicate *deletedPredicate;
        //	if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
        //		deletedPredicate = [NSPredicate predicateWithFormat:@"deleted = 0"];
        //		sortedAndFilteredStudentList = [sortedStudentList filteredArrayUsingPredicate:deletedPredicate];
        //	} else {
        //		sortedAndFilteredStudentList = [NSArray arrayWithArray:sortedStudentList];
        //	}
        
        // set the assignment
        if (individual) {
            [self setTheStudentAssignmentList:[NSMutableArray arrayWithArray:sortedAndFilteredStudentList]];
        } else {
            if ([[anAssignment studentAssignments] count] == 0) {
                NSMutableArray *buildList = [[NSMutableArray alloc] init];
                for (MWSStudent *eachStudent in sortedAndFilteredStudentList) {
                    MWSStudentAssignment *aStudentAssignment = [[MWSCoreDataManager sharedInstance] newStudentAssignment];
                    [aStudentAssignment setStudent:eachStudent];
                    [aStudentAssignment setDone:[NSNumber numberWithInt:0]];
                    [aStudentAssignment setAssignment:anAssignment];
                    [buildList addObject:aStudentAssignment];
                    // Add the student Assignment to each student
                    int arraySize = [[eachStudent assignments] count] + 1;
                    NSMutableArray *workArray = [NSMutableArray arrayWithCapacity:arraySize];
                    [workArray addObjectsFromArray:[NSArray arrayWithArray:[[eachStudent assignments] allObjects]]];
                    [workArray addObject:aStudentAssignment];
                    [eachStudent setAssignments:[NSSet setWithArray:workArray]];
                }
                [anAssignment setStudentAssignments:[NSSet setWithArray:buildList]];
                [self setTheStudentAssignmentList:[NSMutableArray arrayWithArray:buildList]];
            } else {
                NSArray *sortedStudentAssignmentList;
                //NSArray *sortedAndFilteredStudentAssignmentList;
                if ([[[[[[self theStudentAssignmentList] objectAtIndex:0] student] myClass] sortBy] compare:sortByFirstName] == NSOrderedSame) {
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"student.firstName"
                                                                 ascending:YES];
                } else if ([[[[[[self theStudentAssignmentList] objectAtIndex:0] student] myClass] sortBy] compare:sortByLastName] == NSOrderedSame) {
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"student.lastName"
                                                                 ascending:YES];
                } else if ([[[[[[self theStudentAssignmentList] objectAtIndex:0] student] myClass] sortBy] compare:sortById] == NSOrderedSame) {
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"student.idNumber"
                                                                 ascending:YES];
                }
                sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                sortedStudentAssignmentList = [[anAssignment studentAssignments] sortedArrayUsingDescriptors:sortDescriptors];
                workArray = [[NSMutableArray alloc] init];
                [workArray addObjectsFromArray:sortedStudentAssignmentList];
                if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
                    for (MWSStudentAssignment *eachStudent in sortedStudentAssignmentList) {
                        if ([[[eachStudent student] deleted] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
                            [workArray removeObject:eachStudent];
                        }
                    }
                }
                [self setTheStudentAssignmentList:[NSArray arrayWithArray:workArray]];
                // don't know why this doesn't work
                //if ([[theClass showDeletedStudents] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
                //				deletedPredicate = [NSPredicate predicateWithFormat:@"student.deleted = 0"];
                //				sortedAndFilteredStudentAssignmentList = [sortedStudentAssignmentList filteredArrayUsingPredicate:deletedPredicate];
                //			} else {
                //				sortedAndFilteredStudentAssignmentList = [NSArray arrayWithArray:sortedStudentAssignmentList];
                //			}
                //			[self setTheStudentAssignmentList:sortedAndFilteredStudentAssignmentList];
            }
        }
        
        //            set the nav bar buttons
        // array to hold buttons
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
        // the help button
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
            // create a spacer between the buttons
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
            [buttons addObject:spacer];
        }else {
            buttonContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
        }
        
        
        
        // put the tool bar in the nav bar
        buttonItem = [[UIBarButtonItem alloc] 
                      initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                      target:self 
                      action:@selector(save)];
        [buttons addObject:buttonItem];
        
        if ([buttons count] > 0) {
            // put the buttons in the toolbar and release them
            [buttonContainer setItems:buttons animated:NO];
            // place the toolbar into the navigation bar
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithCustomView:buttonContainer];
        }
        
        [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]]];
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)helpMe {
	UIAlertView *alertView;
	alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help",@"Help") 
										   message:NSLocalizedString(@"Touch a row to toggle assignment done!",@"Touch a row to toggle assignment done!") 
										  delegate:nil 
								 cancelButtonTitle:@"Got it!" 
								 otherButtonTitles:nil];
	[alertView show];
}

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
    return [[self theStudentAssignmentList] count];
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
	
	MWSStudentAssignment *theStudentAssignment = [[self theStudentAssignmentList] objectAtIndex:[indexPath row]];
	MWSStudent *theStudent = [theStudentAssignment student];
	aLabelCell.cellLabel.text = [NSString stringWithFormat:@"%@ %@", [theStudent firstName], [theStudent lastName]];
	if (([theStudentAssignment done] == nil) || ([[theStudentAssignment done] compare:[NSNumber numberWithInt: 0]] == NSOrderedSame)) {
		aLabelCell.accessoryType = UITableViewCellAccessoryNone;
	} else {
		aLabelCell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
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
	
	if (savedTextRecipients) {
		[[TextSender sharedInstance] sendTextTo:savedTextRecipients 
										message:savedMessage 
								 withController:self];
		//[savedMessage autorelease];
		//[savedTextRecipients autorelease];
		savedMessage = nil;
		savedTextRecipients = nil;
		[self findAndResignFirstResponder];
		return;
	}
	
	NSString *didComplete;
	MWSStudentAssignment *theStudentAssignment = [[self theStudentAssignmentList] objectAtIndex:[indexPath row]];
	if ([[theStudentAssignment done] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		[theStudentAssignment setDone:[NSNumber numberWithInt:0]];
		didComplete = @"didn't complete";
	} else {
		[theStudentAssignment setDone:[NSNumber numberWithInt:1]];
		didComplete = @"did complete";
	}
	
	[[MWSCoreDataManager sharedInstance] saveContext];
	
	// send notifications
	MWSClass *theClass = [[[[self theStudentAssignmentList] objectAtIndex:0] student] myClass];
	if ([[theClass sendAssignmentNotification] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
		if ([[[theStudentAssignment assignment] sendNotification] compare:[NSNumber numberWithInt: 1]] == NSOrderedSame) {
			NSMutableArray *emailRecipients = [[NSMutableArray alloc] init];
			savedTextRecipients = [[NSMutableArray alloc] init];
			
			if ([[theStudentAssignment student] firstContact]) {
				if ([[[[theStudentAssignment student] firstContact] notifyForAssignments] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[[theStudentAssignment student] firstContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[theStudentAssignment student] firstContact] email])) {
						[emailRecipients addObject:[[[theStudentAssignment student] firstContact] email]];
					}
					if (([[[[theStudentAssignment student] firstContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[theStudentAssignment student] firstContact] textNumber])) {
						[savedTextRecipients addObject:[[[theStudentAssignment student] firstContact] textNumber]];
					}
				}
			}
			if ([[theStudentAssignment student] secondContact]) {
				if ([[[[theStudentAssignment student] secondContact] notifyForAssignments] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[[theStudentAssignment student] secondContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[theStudentAssignment student] secondContact] email])) {
						[emailRecipients addObject:[[[theStudentAssignment student] secondContact] email]];
					}
					if (([[[[theStudentAssignment student] secondContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[theStudentAssignment student] secondContact] textNumber])) {
						[savedTextRecipients addObject:[[[theStudentAssignment student] secondContact] textNumber]];
					}
				}
			}
			if ([[theStudentAssignment student] otherContact]) {
				if ([[[[theStudentAssignment student] otherContact] notifyForAssignments] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
					if (([[[[theStudentAssignment student] otherContact] notifyByEmail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[theStudentAssignment student] otherContact] email])) {
						[emailRecipients addObject:[[[theStudentAssignment student] otherContact] email]];
					}
					if (([[[[theStudentAssignment student] otherContact] notifyByText] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) 
						&& ([[[theStudentAssignment student] otherContact] textNumber])) {
						[savedTextRecipients addObject:[[[theStudentAssignment student] otherContact] textNumber]];
					}
				}
			}
			if ([[[theStudentAssignment student]principalNotify] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
				if ([[theClass myTeacher] principalEmail]) {
					[emailRecipients addObject:[[theClass myTeacher] principalEmail]];
				}
			}
			NSString *message = [NSString stringWithFormat:@"%@ %@ %@ assignment: %@ in %@ class.", 
								 [[theStudentAssignment student] firstName], 
								 [[theStudentAssignment student] lastName], 
								 didComplete, 
								 [[theStudentAssignment assignment] subject], 
								 [theClass myClassName]];
			
			if ([emailRecipients count] > 0) {
				// got emails to send and no text messages to send
				[[EmailSender sharedInstance] sendEmailTo:emailRecipients 
												  subject:@"Assignment Notification" 
												  message:message 
										   withController:self];
			} 
			
			if ([savedTextRecipients count] == 0) {
				savedTextRecipients = nil;
			} else {
				UIAlertView *alertView = [[UIAlertView alloc] 
										  initWithTitle:NSLocalizedString(@"Information!",@"Information!") 
										  message:[NSString stringWithFormat:@"Touch %@ %@ row again to send text message(s).", 
												   [[theStudentAssignment student] firstName], 
												   [[theStudentAssignment student] lastName]]
										  delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
				//[alertView autorelease];
				[alertView show];
				savedMessage = message;
			}
		}
	}
    [self findAndResignFirstResponder];
    [[self tableView] reloadData];
}


-(void)save {
	[self findAndResignFirstResponder];
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

