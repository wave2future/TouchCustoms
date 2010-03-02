//
//  RatingViewCell.m
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "RatingCellView.h"

@interface RatingCellView (/* Private methods */)

- (void)setStarImages;

@end

@implementation RatingCellView

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		[self setStarImages];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	if (self = [super initWithCoder:aDecoder]) {
		[self setStarImages];
	}
	
	return self;
}

- (void)setStarImages {

	[self setStarImage:[UIImage imageNamed:@"small-star-nonselected.png"] forState:kSCRatingViewNonSelected];
	[self setStarImage:[UIImage imageNamed:@"small-star-selected.png"] forState:kSCRatingViewSelected];
	[self setStarImage:[UIImage imageNamed:@"small-star-halfselected.png"] forState:kSCRatingViewHalfSelected];
	[self setStarImage:[UIImage imageNamed:@"small-star-hot.png"] forState:kSCRatingViewHot];
	[self setStarImage:[UIImage imageNamed:@"small-star-highlighted.png"] forState:kSCRatingViewHighlighted];
	
	self.userInteractionEnabled = NO;
}

- (void)dealloc {
	
    [super dealloc];
}

@end
