//
//  UIAlertView+SCMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/14/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "UIAlertView+SCMethods.h"

@implementation UIAlertView (SCMethods)

+ (UIAlertView *)alertViewFromError:(NSError *)error {
	
	UIAlertView *result = [[[UIAlertView alloc] initWithTitle:[error localizedFailureReason]
													  message:[error localizedDescription]
													 delegate:nil
											cancelButtonTitle:NSLocalizedString(@"OK", @"")
											otherButtonTitles:nil] autorelease];
	return result;
}

+ (void)showWithMessage:(NSString *)message {

	[[[[UIAlertView alloc] initWithTitle:nil
								 message:message
								delegate:nil
					   cancelButtonTitle:NSLocalizedString(@"OK", @"")
					   otherButtonTitles:nil] autorelease] show];
}

@end
