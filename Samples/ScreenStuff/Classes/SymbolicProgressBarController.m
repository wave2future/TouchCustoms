//
//  SymbolicProgressBarViewController.m
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/30/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SymbolicProgressBarController.h"

#import "SCMemoryManagement.h"
#import "SCSymbolicProgressBar.h"

@interface SymbolicProgressBarController (/* Private methods */)

- (void)increaseValueForProgressBar:(SCSymbolicProgressBar *)progressBar;

@end

@implementation SymbolicProgressBarController

@synthesize progressBar = _progressBar, progressBar2 = _progressBar2, progressBar3 = _progressBar3
, progressBar4 = _progressBar4;

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_TIMER(_timer);
	
	SC_RELEASE_SAFELY(_progressBar);
	SC_RELEASE_SAFELY(_progressBar2);
	SC_RELEASE_SAFELY(_progressBar3);
	SC_RELEASE_SAFELY(_progressBar4);
	
    [super dealloc];
}

#pragma mark UIView lifecycle

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.progressBar.emptyImage = [UIImage imageNamed:@"progress-bar-dot-empty.png"];
	self.progressBar.filledImage = [UIImage imageNamed:@"progress-bar-dot-filled.png"];
	self.progressBar.symbols = 14;
	self.progressBar.value = .3;
	
	self.progressBar2.emptyImage = [UIImage imageNamed:@"star-nonselected.png"];
	self.progressBar2.filledImage = [UIImage imageNamed:@"star-userselected.png"];
	self.progressBar2.symbols = 10;
	self.progressBar2.value = .5;
	
	self.progressBar3.emptyImage = [UIImage imageNamed:@"btn-yellow.png"];
	self.progressBar3.filledImage = [UIImage imageNamed:@"btn-blue.png"];
	self.progressBar3.symbols = 10;
	self.progressBar3.value = .75;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
}

#pragma mark Orientation handling

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return UIInterfaceOrientationPortrait == interfaceOrientation;
	// return UIInterfaceOrientationPortraitUpsideDown != interfaceOrientation;
}

#pragma mark User interaction

- (IBAction)startStopPressed:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	if (_started) {
	
		[button setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
		_started = NO;
		SC_RELEASE_TIMER(_timer);
		
	} else {
		
		[button setTitle:NSLocalizedString(@"Stop", @"") forState:UIControlStateNormal];
		_started = YES;
		_timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(tick:) userInfo:nil
												 repeats:YES];
	}
}

#pragma mark Timer

- (void)tick:(NSTimer *)timer {

	[self increaseValueForProgressBar:self.progressBar];
	[self increaseValueForProgressBar:self.progressBar2];
	[self increaseValueForProgressBar:self.progressBar3];
}

- (void)increaseValueForProgressBar:(SCSymbolicProgressBar *)progressBar {

	if (progressBar.value >= 1) {
		progressBar.value = 0;
	} else {
		progressBar.value += 0.1;
	}
}

@end
