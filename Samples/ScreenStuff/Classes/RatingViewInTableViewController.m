//
//  RatingViewInTableView.m
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "RatingCellView.h"
#import "RatingViewInTableViewController.h"

#import "SCMemoryManagement.h"

@implementation RatingViewInTableViewController

@synthesize xCodeRatingView = _xCodeRatingView, eclipseRatingView = _eclipseRatingView;
@synthesize xCodeCell = _xCodeCell, eclipseCell = _eclipseCell;

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_xCodeRatingView);
	SC_RELEASE_SAFELY(_eclipseRatingView);
	SC_RELEASE_SAFELY(_xCodeCell);
	SC_RELEASE_SAFELY(_eclipseCell);
	
    [super dealloc];
}

#pragma mark UIView lifecycle

- (void)viewDidLoad {

	[super viewDidLoad];
	
	self.xCodeRatingView.rating = 5;
	self.eclipseRatingView.rating = 3.5;
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];
}

#pragma mark UITableView callbacks

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.section) {
		case 0: {
			switch (indexPath.row) {
				case 0:
					return self.xCodeCell;
				case 1:
					return self.eclipseCell;
			}
		}
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	switch (section) {
		case 0:
			return NSLocalizedString(@"Pleasure from work", @"");
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

@end
