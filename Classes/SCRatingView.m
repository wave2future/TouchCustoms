//
//  SCRatingView.m
//  Touch Customs
//
//  Created by Aleks Nesterow on 7/21/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o. All rights reserved.
//  

#import "SCRatingView.h"
#import "math.h"

#define PROP_RATING			@"rating"

#define STAR_HALFSELECTED	@"star-halfselected.png"
#define STAR_HOT			@"star-hot.png"
#define STAR_NONSELECTED	@"star-nonselected.png"
#define STAR_SELECTED		@"star-selected.png"
#define STAR_HIGHLIGHTED	@"star-highlighted.png"
#define STAR_USERSELECTED	@"star-userselected.png"

#define MIN_RATING			1
#define MAX_RATING			5
#define STARS				MAX_RATING - MIN_RATING + 1

#define ALIGN(X)			(MIN(MAX_RATING, MAX(MIN_RATING, X)))

typedef UIImageView			StarView;
typedef UIImageView *		StarViewRef;

@interface SCRatingView (/* Private methods */)

- (NSMutableDictionary *)stateImageDictionary;
- (UIImage *)imageForState:(NSString *)state fromDictionary:(NSDictionary *)stateImageDict defaultName:(NSString *)defaultImageName;
- (void)initializeComponent;
- (NSInteger)getRatingFromTouches:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)visualizeCurrentUserRating:(NSInteger)currentUserRating;
- (void)visualizeCurrentRating:(CGFloat)currentRating;

@end

@implementation SCRatingView

@synthesize delegate = _delegate;
@synthesize rating = _rating;
- (void)setRating:(CGFloat)value {
	
	if (_rating != value) {
		
		CGFloat previousRating = _rating;
		_rating = value;
		
		[self visualizeCurrentRating:value];
		
		[self.delegate ratingView:self didChangeRatingFrom:previousRating to:_rating];
	}
}

@synthesize userRating = _userRating;
- (void)setUserRating:(NSInteger)value {
	
	NSInteger previousUserRating = _userRating;
	
	if (!value) {
		
		if (!_userRating /* User hasn't voted yet. */) {
			[self visualizeCurrentRating:self.rating];
		} else {
			[self visualizeCurrentRating:_userRating]; /* Visualizing previous user rating. */
		}
		
	} else {
		
		/* Align the passed value so that it would fit physical range of 5 stars. */
		_userRating = ALIGN(value);
		
		NSMutableDictionary *stateImageDict = [self stateImageDictionary];
		
		for (NSInteger i = 0; i < _userRating; i++) {
			
			StarViewRef starView = [_starViews objectAtIndex:i];
			starView.image = [self imageForState:STATE_USERSELECTED fromDictionary:stateImageDict defaultName:STAR_USERSELECTED];
		}
		
		if (value < _starViews.count) {
			/* Need to leave some stars with non-selected images. */
			for (NSInteger i = _starViews.count - 1; i >= value; i--) {
				StarViewRef starView = [_starViews objectAtIndex:i];
				starView.image = [self imageForState:STATE_NONSELECTED fromDictionary:stateImageDict defaultName:STAR_NONSELECTED];
			}
		}
	}
	
	if (previousUserRating != _userRating) {
		[self.delegate ratingView:self didChangeUserRatingFrom:previousUserRating to:_userRating];
	}
}

@synthesize starPlaceSize;
- (void)setStarPlaceSize:(CGSize)value {
	
	_starPlaceSize = value;
	
	for (NSInteger i = 0; i < STARS; i++) {
		
		StarViewRef starView = [_starViews objectAtIndex:i];
		CGFloat width = _starPlaceSize.width;
		starView.frame = CGRectMake(i * width, 0, width, _starPlaceSize.height); 
	}
}

@synthesize highlighted;
- (void)setHighlighted:(BOOL)value {
	
	for (StarViewRef starView in _starViews) {
		starView.highlighted = value;
	}
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		self.clipsToBounds = YES;
		[self initializeComponent];
	}
	
	return self;
}

- (void)initializeComponent {
	
	NSMutableArray *starViewList = [[NSMutableArray alloc] initWithCapacity:STARS];
	NSDictionary *stateImageDict = [self stateImageDictionary];
	
	for (NSInteger i = 0; i < STARS; i++) {
		
		StarViewRef starView = [[StarView alloc] initWithFrame:CGRectMake(i * 30, 0, 30, 20)];
		starView.clearsContextBeforeDrawing = YES;
		starView.contentMode = UIViewContentModeCenter;
		starView.highlightedImage = [UIImage imageNamed:STAR_HIGHLIGHTED];
		starView.image = [self imageForState:STATE_NONSELECTED fromDictionary:stateImageDict defaultName:STAR_NONSELECTED];
		starView.multipleTouchEnabled = YES;
		starView.tag = MIN_RATING + i; /* Associated rating, which is from MIN_RATING to MAX_RATING. */
		[starViewList addObject:starView];
		[self addSubview:starView];
		[starView release];
	}
	
	_starViews = starViewList;
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_stateImageDictionary);
	SC_RELEASE_SAFELY(_starViews);
	
	[super dealloc];
}

#pragma mark Look-n-feel

- (void)setStarImage:(UIImage *)image forState:(NSString *)state {
	
	if ([STATE_HIGHLIGHTED isEqualToString:state]) {
		
		for (StarViewRef starView in _starViews) {
			starView.highlightedImage = image;
		}
		
	} else {
		
		NSMutableDictionary *stateImageDict = [self stateImageDictionary];
		[stateImageDict setObject:image forKey:state];
		
		[self visualizeCurrentRating:self.rating];
	}
}

- (NSMutableDictionary *)stateImageDictionary {
	
	if (!_stateImageDictionary) {
		_stateImageDictionary = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	return _stateImageDictionary;
}

- (UIImage *)imageForState:(NSString *)state fromDictionary:(NSDictionary *)stateImageDict defaultName:(NSString *)defaultImageName {
	
	UIImage *result = [stateImageDict objectForKey:state];
	if (!result) {
		result = [UIImage imageNamed:defaultImageName];
	}
	return result;
}

- (NSInteger)getRatingFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
	
	id touch = [touches anyObject];
	
	for (StarViewRef starView in _starViews) {
		
		if ([starView pointInside:[touch locationInView:starView] withEvent:event]) {
			return starView.tag;
		}
	}
	
	return 0;
}

- (void)visualizeCurrentUserRating:(NSInteger)currentUserRating {
	
	NSDictionary *stateImageDict = [self stateImageDictionary];
	
	/* Making red the stars that indicate the current rating. */
	
	for (NSInteger i = 0; i < currentUserRating; i++) {
		
		StarViewRef starView = [_starViews objectAtIndex:i];
		starView.image = [self imageForState:STATE_HOT fromDictionary:stateImageDict defaultName:STAR_HOT];
	}
	
	/* Leaving only star borders for the others. */
	
	for (NSInteger i = _starViews.count - 1; i >= currentUserRating; i--) {
		
		StarViewRef starView = [_starViews objectAtIndex:i];
		starView.image = [self imageForState:STATE_NONSELECTED fromDictionary:stateImageDict defaultName:STAR_NONSELECTED];
	}
}

- (void)visualizeCurrentRating:(CGFloat)currentRating {
	
	NSInteger counter = 0;
	NSDictionary *stateImageDict = [self stateImageDictionary];
	
	if (currentRating != 0) {
		
		/* Round currentRating to 0.5 stop. */
		
		currentRating = (lroundf(ALIGN(currentRating) * 2)) / 2.0;
		
		/* First set images for full stars. */
		
		NSInteger fullStars = floorf(currentRating);
		for (NSInteger i = 0; i < fullStars; i++, counter++) {
			
			StarViewRef starView = [_starViews objectAtIndex:i];
			starView.image = [self imageForState:STATE_SELECTED fromDictionary:stateImageDict defaultName:STAR_SELECTED];
		}
		
		/* Now set images for a half star if any. */
		
		if (currentRating - fullStars > 0) {
			
			StarViewRef starView = [_starViews objectAtIndex:counter++];
			starView.image = [self imageForState:STATE_HALFSELECTED fromDictionary:stateImageDict defaultName:STAR_HALFSELECTED];
		}
	}
	
	/* Leave other stars unselected. */
	
	for (NSInteger i = _starViews.count - 1; i >= counter; i--) {
		
		StarViewRef starView = [_starViews objectAtIndex:i];
		starView.image = [self imageForState:STATE_NONSELECTED fromDictionary:stateImageDict defaultName:STAR_NONSELECTED];
	}
}

#pragma mark User Interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	NSInteger starsToHighlight = [self getRatingFromTouches:touches withEvent:event];
	[self visualizeCurrentUserRating:starsToHighlight];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	NSInteger starsToHighlight = [self getRatingFromTouches:touches withEvent:event];
	[self visualizeCurrentUserRating:starsToHighlight];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSInteger starsToSelect = [self getRatingFromTouches:touches withEvent:event]; /* Basically this is final user rating. */
	[self setUserRating:starsToSelect];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self setUserRating:self.rating];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

	if (self.userInteractionEnabled && [self pointInside:point withEvent:event]) {
		return self; /* Only intercept events if the touch happened inside the view. */
	}
	
	return [super hitTest:point withEvent:event];
}

- (void)setUserInteractionEnabled:(BOOL)value {
	
	[super setUserInteractionEnabled:value];
	
	for (StarViewRef starView in _starViews) {
		starView.userInteractionEnabled = value;
	}
}

@end
