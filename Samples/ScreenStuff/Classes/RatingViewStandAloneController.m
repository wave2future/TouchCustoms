//
//  RatingViewStandAloneController.m
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "RatingViewStandAloneController.h"

#import "SCMemoryManagement.h"

@implementation RatingViewStandAloneController

@synthesize ratingView = _ratingView;
@synthesize ratingLabel = _ratingLabel, userRatingLabel = _userRatingLabel;

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_ratingView);
	SC_RELEASE_SAFELY(_ratingLabel);
	SC_RELEASE_SAFELY(_userRatingLabel);
	
    [super dealloc];
}

#pragma mark UIView lifecycle

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.ratingView.rating = 3.6;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
}

#pragma mark SCRatingView callbacks

- (void)ratingView:(SCRatingView *)ratingView didChangeUserRatingFrom:(NSInteger)previousUserRating
				to:(NSInteger)userRating {

	self.userRatingLabel.text = [NSString stringWithFormat:@"%d", userRating];
}

- (void)ratingView:(SCRatingView *)ratingView didChangeRatingFrom:(CGFloat)previousRating
				to:(CGFloat)rating {
	
	self.ratingLabel.text = [NSString stringWithFormat:@"%0.1f", rating];
}

@end
