//
//  SCSegment.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 1/26/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Represents a single segment in SCSegmentedControl.
//

typedef enum {
	SCSegmentCenter,
	SCSegmentLeft,
	SCSegmentRight,
	SCSegmentLeftRound,
	SCSegmentRightRound,
	SCSegmentLeftTopRound,
	SCSegmentLeftBottomRound,
	SCSegmentRightTopRound,
	SCSegmentRightBottomRound,
	SCSegmentRound
} SCSegmentStyle;

@interface SCSegment : UIView {

@private
	BOOL _selected;
	SCSegmentStyle _style;
	UILabel *_titleLabel;
}

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) SCSegmentStyle style;
@property (nonatomic, readonly) UILabel *titleLabel;

+ (SCSegment *)segmentWithStyle:(SCSegmentStyle)style;
- (id)initWithStyle:(SCSegmentStyle)style frame:(CGRect)frame;

@end
