//
//  SCViewSlider.m
//  iAudition
//
//  Created by Aleks Nesterow on 10/20/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o.
//  All rights reserved.
//

#import "SCViewSlider.h"

@interface SCViewSlider (/* Private methods */)

- (void)__slideTableView:(SCSlideDirection)direction;

@end

@implementation SCViewSlider

@synthesize viewToSlide = _viewToSlide;
@synthesize ySlideDistance = _ySlideDistance, heightSlideDistance = _heightSlideDistance, slideDuration = _slideDuration;
@synthesize hideKeyboardOnReturn = _hideKeyboardOnReturn;

- (id)init {

	if (self = [super init]) {
		_slideDuration = 0.3f;
	}
	return self;
}

- (void)dealloc {

	[_viewToSlide release];
	[super dealloc];
}

#pragma mark TextField Callbacks

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[self __slideTableView:SCSlideDirectionUp];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	[self __slideTableView:SCSlideDirectionDown];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	if (self.hideKeyboardOnReturn) {
		[textField resignFirstResponder];
	}
	
	return YES;
}

#pragma mark Private Methods

- (void)__slideTableView:(SCSlideDirection)direction {
	
	CGFloat y = SCSlideDirectionUp == direction ? -self.ySlideDistance : self.ySlideDistance;
	CGFloat height = SCSlideDirectionUp == direction ? -self.heightSlideDistance : self.heightSlideDistance;
	
	CGRect rect = self.viewToSlide.frame;
	rect = CGRectMake(rect.origin.x, rect.origin.y + y, rect.size.width, rect.size.height + height);
	
	[UIView beginAnimations:@"SCViewSlider::slideView" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:self.slideDuration];
	
	self.viewToSlide.frame = rect;

	[UIView commitAnimations];
}

@end
