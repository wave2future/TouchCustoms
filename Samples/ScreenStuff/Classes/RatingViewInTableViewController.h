//
//  RatingViewInTableViewController.h
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	SCRatingView showcase as a part of UITableView cell.
//

@class RatingCellView;

@interface RatingViewInTableViewController : UITableViewController {

@private
	RatingCellView *_xCodeRatingView, *_eclipseRatingView;
	UITableViewCell *_xCodeCell, *_eclipseCell;
}

@property (nonatomic, retain) IBOutlet RatingCellView *xCodeRatingView, *eclipseRatingView;
@property (nonatomic, retain) IBOutlet UITableViewCell *xCodeCell, *eclipseCell;

@end
