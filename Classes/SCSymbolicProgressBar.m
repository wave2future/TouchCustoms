//
//  SCSymbolicProgressBar.m
//  Bredbandskollen
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCSymbolicProgressBar.h"

#import "SCMemoryManagement.h"

@interface SCSymbolicProgressBar (/* Private methods */)

- (void)__initializeComponent;
- (void)__updateComponent;

@end

@implementation SCSymbolicProgressBar

@synthesize value = _value;
- (void)setValue:(CGFloat)value {
	
	value = MIN(1, MAX(0, value));
	
	if (_value != value) {
		_value = value;
		[self __updateComponent];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

@synthesize symbols = _symbols;
- (void)setSymbols:(NSUInteger)value {
	if (_symbols != value) {
		_symbols = value;
		
		for (UIImageView *imageView in _imageViews) {
			[imageView removeFromSuperview];
		}
		
		[_imageViews removeAllObjects];
		
		for (NSUInteger i = 0; i < _symbols; i++) {
			
			UIImageView *imageView = [[UIImageView alloc] initWithImage:self.emptyImage];
			imageView.contentMode = UIViewContentModeCenter;
			[self addSubview:imageView];
			[_imageViews addObject:imageView];
			[imageView release];
		}
		
		[self setNeedsLayout];
		[self __updateComponent];
	}
}

@synthesize filledImage = _filledImage;
- (void)setFilledImage:(UIImage *)value {

	if (_filledImage != value) {
	
		[_filledImage release];
		_filledImage = [value retain];
		
		[self __updateComponent];
	}
}

@synthesize emptyImage = _emptyImage;
- (void)setEmptyImage:(UIImage *)value {
	
	if (_emptyImage != value) {
		
		[_emptyImage release];
		_emptyImage = [value retain];
		
		[self __updateComponent];
	}
}

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		[self __initializeComponent];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

	if (self = [super initWithCoder:aDecoder]) {
		[self __initializeComponent];
	}
	
	return self;
}

- (void)__initializeComponent {
	
	_imageViews = [[NSMutableArray alloc] initWithCapacity:32];	
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_filledImage);
	SC_RELEASE_SAFELY(_emptyImage);
	
	SC_RELEASE_SAFELY(_imageViews);
	
    [super dealloc];
}

#pragma mark Layout

- (void)layoutSubviews {

	[super layoutSubviews];
	
	if (_imageViews.count < 1) {
		return;
	}
	
	CGRect frame = self.frame;
	
	CGFloat imageWidth = CGRectGetWidth(frame) / _symbols;
	CGFloat imageHeight = CGRectGetHeight(frame);
	
	CGFloat imageOffset = 0;
	
	for (UIImageView *imageView in _imageViews) {
		imageView.frame = CGRectMake(imageOffset, 0, imageWidth, imageHeight);
		imageOffset += imageWidth;
	}
}

- (void)__updateComponent {
	
	if (_imageViews.count < 1) {
		return;
	}
	
	/* Learn how many there should be filled images. */
	
	NSUInteger filledImages = self.symbols * self.value;
	
	NSUInteger i = 0;
	
	for (; i < filledImages; i++) {
		UIImageView *imageView = [_imageViews objectAtIndex:i];
		imageView.image = self.filledImage;
	}
	
	for (; i < self.symbols; i++) {
		UIImageView *imageView = [_imageViews objectAtIndex:i];
		imageView.image = self.emptyImage;
	}
}

@end
