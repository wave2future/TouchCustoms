//
//  SegmentedControlController.h
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/4/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	SCSegmentedControl show-case with one, two, and three rows.
//

@class SCSegmentedControl;

@interface SegmentedControlController : UIViewController {

@private
	SCSegmentedControl *_oneRowControl, *_twoRowControl, *_threeRowControl;
	UILabel *_valueLabel;
}

@property (nonatomic, retain) IBOutlet SCSegmentedControl *oneRowControl, *twoRowControl, *threeRowControl;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;

- (IBAction)selectedIndexChanged:(id)sender;

@end
