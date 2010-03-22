//
//  SCActivityIndicatorCell.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/16/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCActivityIndicatorCell.h"
#import "SCMemoryManagement.h"

@implementation SCActivityIndicatorCell

@synthesize refreshLabel = _refreshLabel;

#pragma mark init / dealloc

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicator.hidesWhenStopped = YES;
		_activityIndicator.hidden = YES;
		
		[self.contentView addSubview:_activityIndicator];
		
		_refreshLabel = [[UILabel alloc] init];
		_refreshLabel.backgroundColor = [UIColor clearColor];
		_refreshLabel.font = [UIFont boldSystemFontOfSize:14];
		_refreshLabel.highlightedTextColor = [UIColor whiteColor];
		_refreshLabel.textAlignment = UITextAlignmentCenter;
		
		[self.contentView addSubview:_refreshLabel];
    }
	
    return self;
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_refreshLabel);
	SC_RELEASE_SAFELY(_activityIndicator);
	
    [super dealloc];
}

#pragma mark Layout

- (void)layoutSubviews {

	[super layoutSubviews];
	
	CGRect frame = self.frame;
	
	CGFloat width = CGRectGetWidth(frame);
	CGFloat height = CGRectGetHeight(frame);
	
	static CGFloat activityWidth = 20;
	static CGFloat activityHeight = 20;
	
	_activityIndicator.frame = CGRectMake((width - activityWidth) / 2., (height - activityHeight) / 2.,
										  activityWidth, activityHeight);
	
	_refreshLabel.frame = CGRectMake(0, 0, width, height);
}

#pragma mark State management

/* @Overridden */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}

- (void)setLoading:(BOOL)value {
	
	if (value) {
	
		self.userInteractionEnabled = NO;
		_refreshLabel.hidden = YES;
		[_activityIndicator startAnimating];
		
	} else {
		
		self.userInteractionEnabled = YES;
		_refreshLabel.hidden = NO;
		[_activityIndicator stopAnimating];
	}
}

@end
