//
//  SCActivityIndicator.m
//  Touch Customs
//
//  Created by Aleks Nesterow on 7/22/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o. All rights reserved.
//  

#import "SCActivityIndicator.h"

@interface SCActivityIndicator (/* Private methods */)

- (void)initializeComponent;

@end

@implementation SCActivityIndicator

@synthesize indicatorView, statusLabel;

- (id)initWithFrame:(CGRect)frame {

	if (self = [super initWithFrame:frame]) {
		[self initializeComponent];
	}
	
	return self;
}

- (void)initializeComponent {
	
	static NSInteger indicatorHeight = 20;
	static NSInteger indicatorWidth = 20;
	
	CGRect activityFrame = CGRectMake(0
									  , (self.frame.size.height - indicatorHeight) / 2.0
									  , indicatorWidth
									  , indicatorHeight);
	
	_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_indicatorView.frame = activityFrame;
	_indicatorView.hidesWhenStopped = NO;
	
	[self addSubview:_indicatorView];
	
	static NSInteger labelOffset = 5;
	
	_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(activityFrame.size.width + labelOffset
															, 0
															, self.frame.size.width - activityFrame.size.width - labelOffset
															, self.frame.size.height)];
	_statusLabel.adjustsFontSizeToFitWidth = NO;
	_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	_statusLabel.backgroundColor = [UIColor clearColor];
	_statusLabel.clearsContextBeforeDrawing = YES;
	_statusLabel.font = [UIFont boldSystemFontOfSize:13];
	_statusLabel.numberOfLines = 1;
	
	_statusLabel.text = NSLocalizedString(@"Loading...", @"Using internet connectivity.");
	[self addSubview:_statusLabel];
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_indicatorView);
	SC_RELEASE_SAFELY(_statusLabel);
	
	[super dealloc];
}

- (NSString *)statusMessage {

	return self.statusLabel.text;
}

- (void)setStatusMessage:(NSString *)value {

	self.statusLabel.text = value;
}

@end
