//
//  StudentAnalyzer.h
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/14/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "MWSStudent.h"


@interface StudentAnalyzer : NSObject {

}

-(UIColor *)attendanceStatusColorForStudent:(MWSStudent *)theStudent;
-(UIColor *)assignmentStatusColorForStudent:(MWSStudent *)theStudent;
-(UIColor *)conductStatusColorForStudent:(MWSStudent *)theStudent;
-(UIColor *)testStatusColorForStudent:(MWSStudent *)theStudent;

@end
