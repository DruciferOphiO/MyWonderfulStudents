//
//  StudentAnalyzer.m
//  My Wonderful Students
//
//  Created by Andrew McKinley on 8/14/11.
//  Copyright 2011 AVM Software. All rights reserved.
//

#import "StudentAnalyzer.h"
#import "MWSAttendance.h"
#import "MWSStudentAssignment.h"
#import "MWSConduct.h"
#import "MWSStudentTest.h"
#import "MWSTest.h"

@implementation StudentAnalyzer

-(UIColor *)attendanceStatusColorForStudent:(MWSStudent *)theStudent {
	
	UIColor *rtn = [UIColor greenColor];
	
	if ([[theStudent attendance] count] == 0) {
		return rtn;
	}
	int timesAbsent = 0;
	for (MWSAttendance *eachAttendance in [[theStudent attendance] allObjects]) {
		if ([[eachAttendance isPresent] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
			timesAbsent++;
		}
	}
	if (timesAbsent == 0) {
		rtn = [UIColor colorWithRed:255/255.0 green:207/255.0 blue:72/255.0 alpha:1.0];
	} else if (timesAbsent < 6) {
		rtn = [UIColor blueColor];
	} else if (timesAbsent < 10) {
		rtn = [UIColor greenColor];
	} else if (timesAbsent < 14) {
		rtn = [UIColor yellowColor];
	} else {
		rtn = [UIColor redColor];
	}
	return rtn;
}


-(UIColor *)assignmentStatusColorForStudent:(MWSStudent *)theStudent {
	

	UIColor *rtn = [UIColor greenColor];
	if ([[theStudent assignments] count] == 0) {
		return rtn;
	}
	int assignmentsDone = 0;
	float percentage;
	for (MWSStudentAssignment *eachStudentAssignment in [[theStudent assignments] allObjects]) {
		if ([[eachStudentAssignment done] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			assignmentsDone++;
		}
	}
	if (assignmentsDone == 0) {
		rtn = [UIColor redColor];
	}
	percentage = (assignmentsDone / [[theStudent assignments] count]) * 100;
	if (percentage > 90) {
		rtn = [UIColor colorWithRed:255/255.0 green:207/255.0 blue:72/255.0 alpha:1.0];

	} else if (percentage > 79) {
		rtn = [UIColor blueColor];
	} else if (percentage > 69) {
		rtn = [UIColor greenColor];
	} else if (percentage > 59) {
		rtn = [UIColor yellowColor];
	} else {
		rtn = [UIColor redColor];
	}
	return rtn;
}


-(UIColor *)conductStatusColorForStudent:(MWSStudent *)theStudent {
	
	UIColor *rtn = [UIColor greenColor];
	if ([[theStudent conduct] count] == 0) {
		return rtn;
	}
	int goodConduct = 0;
	int badConduct = 0;
	int nuetralConduct = 0;
	for (MWSConduct *eachConduct in [[theStudent conduct] allObjects]) {
		switch ([[eachConduct rate] intValue]) {
			case 1:
				badConduct++;
				break;
			case 2:
				nuetralConduct++;
				break;
			case 3:
				goodConduct++;
				break;
			default:
				break;
		}
	}
	if ((goodConduct == 0) && (badConduct == 0)) {
		rtn = [UIColor greenColor];
	}
	if (goodConduct > badConduct) {
		rtn = [UIColor colorWithRed:255/255.0 green:207/255.0 blue:72/255.0 alpha:1.0];
	} else {
		rtn = [UIColor redColor];
	}

	return rtn;
}


-(UIColor *)testStatusColorForStudent:(MWSStudent *)theStudent {
	
	UIColor *rtn = [UIColor greenColor];

	if ([[theStudent tests] count] == 0) {
		return rtn;
	}
	float totalTestScores = 0;
	float percentage;
	for (MWSStudentTest *eachStudentTest in [[theStudent tests] allObjects]) {
		if ([[[eachStudentTest test] numericGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			totalTestScores = totalTestScores + [[eachStudentTest grade] floatValue];
		}
		if ([[[eachStudentTest test] letterGrade] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			if ([[eachStudentTest grade] caseInsensitiveCompare:@"A"] == NSOrderedSame) {
				totalTestScores = totalTestScores + 100;
			} else if ([[eachStudentTest grade] caseInsensitiveCompare:@"B"] == NSOrderedSame) {
				totalTestScores = totalTestScores + 89;
			} else if ([[eachStudentTest grade] caseInsensitiveCompare:@"C"] == NSOrderedSame) {
				totalTestScores = totalTestScores + 79;
			} else if ([[eachStudentTest grade] caseInsensitiveCompare:@"D"] == NSOrderedSame) {
				totalTestScores = totalTestScores + 69;
			} else if ([[eachStudentTest grade] caseInsensitiveCompare:@"F"] == NSOrderedSame) {
				totalTestScores = totalTestScores + 59;
			}
		}
		if ([[[eachStudentTest test] passFail] compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
			if ([[eachStudentTest grade] caseInsensitiveCompare:@"Pass"] == NSOrderedSame) {
				totalTestScores = totalTestScores + 100;
			} else {
				totalTestScores = totalTestScores + 59;
			}
		}
	}
	percentage = (totalTestScores / [[theStudent tests] count]);

	if (percentage > 90) {
		rtn = [UIColor colorWithRed:255/255.0 green:207/255.0 blue:72/255.0 alpha:1.0];
	} else if (percentage > 79) {
		rtn = [UIColor blueColor];
	} else if (percentage > 69) {
		rtn = [UIColor greenColor];
	} else if (percentage > 59) {
		rtn = [UIColor yellowColor];
	} else {
		rtn = [UIColor redColor];
	}
	return rtn;
}

@end
