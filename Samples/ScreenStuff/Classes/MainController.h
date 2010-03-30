//
//  MainController.h
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Represents Main screen.
//

@class RatingViewStandAloneController, RatingViewInTableViewController;
@class SegmentedControlController;
@class SymbolicProgressBarController;

@interface MainController : UITableViewController {

@private
	RatingViewStandAloneController *_ratingViewStandAloneController;
	RatingViewInTableViewController *_ratingViewInTableViewController;
	
	SegmentedControlController *_segmentedControlController;
	
	SymbolicProgressBarController *_symbolicProgressBarController;
}

@property (nonatomic, retain) IBOutlet RatingViewStandAloneController *ratingViewStandAloneController;
@property (nonatomic, retain) IBOutlet RatingViewInTableViewController *ratingViewInTableViewController;

@property (nonatomic, retain) IBOutlet SegmentedControlController *segmentedControlController;

@property (nonatomic, retain) IBOutlet SymbolicProgressBarController *symbolicProgressBarController;

@end

