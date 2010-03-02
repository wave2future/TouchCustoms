//
//  RatingViewStandAloneController.h
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	SCRatingView showcase as a stand-alone control.
//

#import "SCRatingView.h"

@interface RatingViewStandAloneController : UIViewController<SCRatingDelegate> {

@private
	SCRatingView *_ratingView;
	UILabel *_ratingLabel, *_userRatingLabel;
}

@property (nonatomic, retain) IBOutlet SCRatingView *ratingView;
@property (nonatomic, retain) IBOutlet UILabel *ratingLabel, *userRatingLabel;

- (IBAction)ratingSelected:(UISegmentedControl *)sender;

@end
