//
//  SegmentedControlController.m
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/4/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SegmentedControlController.h"

#import "SCSegmentedControl.h"
#import "SCMemoryManagement.h"

@implementation SegmentedControlController

@synthesize oneRowControl = _oneRowControl, twoRowControl = _twoRowControl, threeRowControl = _threeRowControl;
@synthesize valueLabel = _valueLabel;

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_oneRowControl);
	SC_RELEASE_SAFELY(_twoRowControl);
	SC_RELEASE_SAFELY(_threeRowControl);
	
	SC_RELEASE_SAFELY(_valueLabel);
	
    [super dealloc];
}

#pragma mark UIView lifecycle

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.oneRowControl.rowCount = 1;
	self.oneRowControl.columnCount = 3;
	self.oneRowControl.segmentTitles = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
	
	self.twoRowControl.rowCount = 2;
	self.twoRowControl.columnCount = 3;
	self.twoRowControl.segmentTitles = [NSArray arrayWithObjects:@"One", @"Two", @"Three",
										@"Four", @"Five", @"Six", nil];
	
	self.threeRowControl.rowCount = 3;
	self.threeRowControl.columnCount = 3;
	self.threeRowControl.segmentTitles = [NSArray arrayWithObjects:@"One", @"Two", @"Three",
										  @"Four", @"Five", @"Six",
										  @"Seven", @"Eight", @"Nine", nil];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
}

#pragma mark User interaction

- (IBAction)selectedIndexChanged:(id)sender {

	self.valueLabel.text = [[sender segmentTitles] objectAtIndex:[sender selectedIndex]];
}

@end
