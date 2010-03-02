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

@class RatingViewStandAloneController, RatingViewInTableView;

@interface MainController : UITableViewController {

@private
	RatingViewStandAloneController *_ratingViewStandAloneController;
	RatingViewInTableView *_ratingViewInTableView;
}

@property (nonatomic, retain) IBOutlet RatingViewStandAloneController *ratingViewStandAloneController;
@property (nonatomic, retain) IBOutlet RatingViewInTableView *ratingViewInTableView;

@end

