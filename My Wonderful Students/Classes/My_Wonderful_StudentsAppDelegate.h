//
//  My_Wonderful_StudentsAppDelegate.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 1/23/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MWSClassesListViewController.h"

@class My_Wonderful_StudentsViewController;
@class MWSCoreDataManager;

@interface My_Wonderful_StudentsAppDelegate : NSObject <UIApplicationDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet My_Wonderful_StudentsViewController *viewController;
@property (nonatomic, retain) MWSClassesListViewController *classesViewController;
@property (nonatomic, retain) UINavigationController *navController;

@end

