//
//  SCSegmentedControl.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 1/25/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Represents a multi-row segmented control.
//

@interface SCSegmentedControl : UIControl {

@private
	NSUInteger _columnCount, _rowCount;
	NSArray *_segmentTitles;
	NSMutableArray *_segments;
	NSUInteger _selectedIndex;
}

@property (nonatomic, assign) NSUInteger columnCount;
@property (nonatomic, assign) NSUInteger rowCount;
/** If you specified 3 columns and 2 rows, this array whould contain 6 items. */
@property (nonatomic, copy) NSArray *segmentTitles;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end
