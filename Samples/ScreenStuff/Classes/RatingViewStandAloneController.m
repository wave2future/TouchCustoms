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

@implementation RatingViewStandAloneController

#pragma mark init / dealloc

- (void)dealloc {
	
    [super dealloc];
}

#pragma mark UIView lifecycle

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"As a stand-alone control.", @"");
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
}

@end
