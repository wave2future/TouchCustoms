//
//  SCSegmentedControl.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 1/25/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCSegment.h"
#import "SCSegmentedControl.h"
#import "SCMemoryManagement.h"

#define kRowHeight	37

@interface SCSegmentedControl (/* Private methods */)

- (void)__initializeComponent;

@end

@interface SCSegmentedControl (UserInteraction) 

- (NSInteger)__getSegmentIndexFromTouches:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@implementation SCSegmentedControl

@synthesize columnCount = _columnCount, rowCount = _rowCount;
@synthesize segmentTitles = _segmentTitles;
@synthesize selectedIndex = _selectedIndex;

- (void)setColumnCount:(NSUInteger)value {

	if (_columnCount != value) {
		
		_columnCount = value;
		[self setNeedsLayout];
	}
}

- (void)setRowCount:(NSUInteger)value {
	
	if (_rowCount != value) {
		
		_rowCount = value;
		[self setNeedsLayout];
	}
}

- (void)setSegmentTitles:(NSArray *)value {
	
	if (_segmentTitles != value) {
		
		SC_RELEASE_SAFELY(_segmentTitles);
		_segmentTitles = [[NSArray alloc] initWithArray:value];
		[self setNeedsLayout];
	}
}

- (void)setSelectedIndex:(NSUInteger)value {

	if (_selectedIndex != value) {
		
		if (_segments.count > _selectedIndex) {
			[[_segments objectAtIndex:_selectedIndex] setSelected:NO];
		}
		
		_selectedIndex = value;
		
		if (_segments.count > _selectedIndex) {
			[[_segments objectAtIndex:_selectedIndex] setSelected:YES];
		}
		
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (id)init {
	
	return [self initWithFrame:CGRectMake(0, 0, 200, 37)];
}

- (id)initWithFrame:(CGRect)frame {

	if (self = [super initWithFrame:frame]) {
		[self __initializeComponent];
	}
	
	return self;
}
			
- (id)initWithCoder:(NSCoder *)decoder {

	if (self = [super initWithCoder:decoder]) {
		[self __initializeComponent];
	}
	
	return self;
}

- (void)__initializeComponent {
	
	_segments = [[NSMutableArray alloc] initWithCapacity:12];
}

- (void)dealloc {

	SC_RELEASE_SAFELY(_segmentTitles);
	SC_RELEASE_SAFELY(_segments);
	
	[super dealloc];
}

- (void)layoutSubviews {

	[super layoutSubviews];
	
	NSUInteger mustItemCount = self.columnCount * self.rowCount;
	
	for (SCSegment *segment in _segments) {
		[segment removeFromSuperview];
	}
	
	[_segments removeAllObjects];
	
	if (0 == mustItemCount) {
		return;
	}
	
	if (mustItemCount != self.segmentTitles.count) {
		return;
	}
	
	NSInteger width = CGRectGetWidth(self.frame);
	NSInteger segmentWidth = width / self.columnCount;
	NSInteger segmentOffsetY = 0;
	NSUInteger titleIndex = 0;
	
	for (NSUInteger row = 0; row < self.rowCount; row++) {
		
		CGFloat buttonOffsetX = 0;
		
		for (NSUInteger col = 0; col < self.columnCount; col++) {
			
			SCSegment *segment = [SCSegment segmentWithStyle:SCSegmentCenter];
			
			segment.frame = CGRectMake(buttonOffsetX, segmentOffsetY, segmentWidth, kRowHeight);
			segment.tag = titleIndex;
			segment.titleLabel.font = [UIFont boldSystemFontOfSize:14];
			segment.titleLabel.text = [self.segmentTitles objectAtIndex:titleIndex];
			
			if (self.selectedIndex == titleIndex) {
				segment.selected = YES;
			}
			
			segment.style = SCSegmentCenter;
			
			if (1 == self.rowCount) {
				
				if (0 == col) {
					
					/* +---+---+---+
					   | * |   |   |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentLeftRound;
					
				} else if (self.columnCount - 1 == col) {
					
					/* +---+---+---+
					   |   |   | * |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentRightRound;
				}
			} else if (0 == row) {
				
				if (0 == col) {
					
					/* +---+---+---+
					   | * |   |   |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentLeftTopRound;
					
				} else if (self.columnCount - 1 == col) {
					
					/* +---+---+---+
					   |   |   | * |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentRightTopRound;
				}
			} else if (self.rowCount - 1 == row) {
				
				if (0 == col) {
					
					/* +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   | * |   |   |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentLeftBottomRound;
					
				} else if (self.columnCount - 1 == col) {
					
					/* +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   |   |   | * |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentRightBottomRound;
				}
			} else {
				
				if (0 == col) {
					
					/* +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   | * |   |   |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentLeft;
					
				} else if (self.columnCount - 1 == col) {
					
					/* +---+---+---+
					   |   |   |   |
					   +---+---+---+
					   |   |   | * |
					   +---+---+---+
					   |   |   |   |
					   +---+---+---+
					 */
					
					segment.style = SCSegmentRight;
				}
			}
			
			buttonOffsetX += segmentWidth;
			titleIndex += 1;
			
			[_segments addObject:segment];
			[self addSubview:segment];
			[self sendSubviewToBack:segment];
		}
		
		segmentOffsetY += kRowHeight - 1;
	}
}

@end

@implementation SCSegmentedControl (UserInteraction)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSInteger segmentIndex = [self __getSegmentIndexFromTouches:touches withEvent:event];
	if (0 <= segmentIndex) {
		[self setSelectedIndex:segmentIndex];
	}
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	
	if (self.userInteractionEnabled && [self pointInside:point withEvent:event]) {
		return self; /* Only intercept events if the touch happened inside the view. */
	}
	return [super hitTest:point withEvent:event];
}

- (void)setUserInteractionEnabled:(BOOL)value {
	
	[super setUserInteractionEnabled:value];
	
	for (SCSegment *segment in _segments) {
		segment.userInteractionEnabled = value;
	}
}

- (NSInteger)__getSegmentIndexFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {

	id touch = [touches anyObject];
	
	for (SCSegment *segment in _segments) {
		if ([segment pointInside:[touch locationInView:segment] withEvent:event]) {
			return segment.tag;
		}
	}
	
	return -1;
}

@end
