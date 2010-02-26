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

/** @Overridden
  * We are using NSUserDefaults to store user settings, so it's quite natural to store at this point
  * the values set while the application was running.
  * 
  * If such behavior is harmful for your application, override this method or do not inherit from
  * SCAppDelegate at all. */
- (void)applicationWillTerminate:(UIApplication *)application {

	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
