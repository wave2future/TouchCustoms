//
//  SCSegment.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 1/26/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCGrfx.h"
#import "SCSegment.h"
#import "SCMemoryManagement.h"

@interface SCSegment (/* Private methods */) 

- (void)__initializeComponent:(SCSegmentStyle)style;

@end

@interface SCSegment (Drawing)

- (void)clipBackground:(CGContextRef)c;
- (void)clipForeground:(CGContextRef)c;
- (void)clipCore:(CGContextRef)c rect:(CGRect)rect;

@end

@implementation SCSegment

@synthesize selected = _selected;
@synthesize style = _style;
@synthesize titleLabel = _titleLabel;

- (void)setSelected:(BOOL)value {
	
	if (_selected != value) {
		
		_selected = value;
		self.titleLabel.highlighted = _selected;
		[self setNeedsDisplay];
	}
}

- (void)setStyle:(SCSegmentStyle)value {
	
	if (_style != value) {
		
		_style = value;
		[self setNeedsDisplay];
	}
}

+ (SCSegment *)segmentWithStyle:(SCSegmentStyle)style {
	
	return [[[SCSegment alloc] initWithStyle:style] autorelease];
}

- (id)init {
	
	return [self initWithFrame:CGRectMake(0, 0, 100, 37)];
}

- (id)initWithStyle:(SCSegmentStyle)style {
	
	return [self initWithStyle:style frame:CGRectMake(0, 0, 100, 37)];
}

- (id)initWithFrame:(CGRect)frame {
	
	return [self initWithStyle:SCSegmentCenter frame:frame];
}

- (id)initWithStyle:(SCSegmentStyle)style frame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		[self __initializeComponent:style];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	
	if (self = [super initWithCoder:decoder]) {
		[self __initializeComponent:SCSegmentCenter];
	}
	return self;
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_titleLabel);
	
	[super dealloc];
}

- (void)__initializeComponent:(SCSegmentStyle)style {
	
	_style = style;
	
	self.backgroundColor = [UIColor clearColor];
	
	_titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.textAlignment = UITextAlignmentCenter;
	_titleLabel.textColor = [UIColor blackColor];
	_titleLabel.highlightedTextColor = [UIColor whiteColor];
	
	[self addSubview:_titleLabel];
}

@end

#define kSCSegmentBorderWidth	1.
#define kSCSegmentCornerRadius	10.

@implementation SCSegment (Drawing)

static CGFloat _BorderComponents[2][8] = {
	/* Default */ { /* Stop 1 */ .68, .68, .68, 1, /* Stop 2 */ .61, .61, .61, 1 },
	/* Selected */ { /* Stop 1 */ 0, .2, .53, 1, /* Stop 2 */ .3, .53, .88, 1 }
};

static CGFloat _BorderLocations[2] = { 0, 1 };

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat width = CGRectGetWidth(self.frame);
	CGFloat height = CGRectGetHeight(self.frame);
	
	CGColorSpaceRef gradientColorSpace = CGColorSpaceCreateDeviceRGB();
	CGPoint gradientStartPoint = CGPointMake(width / 2., 0);
	CGPoint gradientEndPoint = CGPointMake(width / 2., height);
	
	/* Border */
	
	[self clipBackground:context];
	
	CGGradientRef borderGradient = CGGradientCreateWithColorComponents(gradientColorSpace, _BorderComponents[self.selected], _BorderLocations, 2);
	CGContextDrawLinearGradient(context, borderGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsBeforeStartLocation);
	
	/* Foreground */
	
	[self clipForeground:context];
	
	if (self.selected) {
		
		CGFloat foreComponents[16] = {
			/* Stop 1 */ .15, .36, .73, 1,
			/* Stop 2 */ .21, .49, .92, 1,
			/* Stop 3 */ .27, .53, .93, 1,
			/* Stop 4 */ .42, .65, .99, 1
		};
		CGFloat foreLocations[4] = { 0, .5, .5, 1 };
		CGGradientRef foreGradient = CGGradientCreateWithColorComponents(gradientColorSpace, foreComponents, foreLocations, 4);
		
		CGContextDrawLinearGradient(context, foreGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsBeforeStartLocation);
		
	} else {
		
		CGFloat foreComponents[8] = {
			/* Stop 1 */ .97, .97, .97, 1,
			/* Stop 2 */ .78, .78, .78, 1
		};
		CGFloat foreLocations[2] = { 0, 1 };
		CGGradientRef foreGradient = CGGradientCreateWithColorComponents(gradientColorSpace, foreComponents, foreLocations, 2);
		
		CGContextDrawLinearGradient(context, foreGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsBeforeStartLocation);
	}
}

- (void)clipBackground:(CGContextRef)c {
	
	[self clipCore:c rect:self.bounds];
}

- (void)clipForeground:(CGContextRef)c {
	
	CGRect rect = self.bounds;
	
	CGFloat left = CGRectGetMinX(rect);
	CGFloat top = CGRectGetMinY(rect);
	CGFloat width = CGRectGetWidth(rect);
	CGFloat height = CGRectGetHeight(rect);
	
	CGRect foreRect;
	
	if (self.selected) {
		
		foreRect = CGRectMake(left + kSCSegmentBorderWidth, top + kSCSegmentBorderWidth,
							  width - kSCSegmentBorderWidth, height - kSCSegmentBorderWidth * 2);
		
	} else {
		
		foreRect = CGRectMake(left, top + kSCSegmentBorderWidth,
							  width - kSCSegmentBorderWidth, height - kSCSegmentBorderWidth * 2);
		
		switch (self.style) {
			case SCSegmentLeftRound:
			case SCSegmentLeftBottomRound:
			case SCSegmentLeftTopRound:
			case SCSegmentLeft:
				foreRect.origin.x += kSCSegmentBorderWidth;
				foreRect.size.width -= kSCSegmentBorderWidth;
				break;
		}
	}
	
	[self clipCore:c rect:foreRect];
}

- (void)clipCore:(CGContextRef)c rect:(CGRect)rect {

	switch (self.style) {
		case SCSegmentLeftRound:
			SCContextAddLeftRoundedRect(c, rect, kSCSegmentCornerRadius);
			break;
		case SCSegmentLeftBottomRound:
			SCContextAddLeftBottomRoundedRect(c, rect, kSCSegmentCornerRadius);
			break;
		case SCSegmentLeftTopRound:
			SCContextAddLeftTopRoundedRect(c, rect, kSCSegmentCornerRadius);
			break;
		case SCSegmentRightRound:
			SCContextAddRightRoundedRect(c, rect, kSCSegmentCornerRadius);
			break;
		case SCSegmentRightTopRound:
			SCContextAddRightTopRoundedRect(c, rect, kSCSegmentCornerRadius);
			break;
		case SCSegmentRightBottomRound:
			SCContextAddRightBottomRoundedRect(c, rect, kSCSegmentCornerRadius);
			break;
		default:
			SCContextAddRoundedRect(c, rect, 0);
			break;
	}
	
	CGContextClip(c);
}

@end
