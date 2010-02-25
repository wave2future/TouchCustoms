//
//  SCAppDelegate.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/25/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCAppDelegate.h"

@implementation SCAppDelegate

static int _ActivityCount = 0;
+ (void)showActivityIndicator {
	
	if (!_ActivityCount) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	_ActivityCount++;
}

+ (void)hideActivityIndicator {
	
	_ActivityCount--;
	if (!_ActivityCount) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}

@end
