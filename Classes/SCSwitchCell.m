//
//  SCSwitchCell.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/18/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCSwitchCell.h"
#import "SCMemoryManagement.h"

@interface SCSwitchCell (/* Private methods */)

- (void)initializeComponent;
- (CGRect)calculateTitleLabelRect;
- (CGRect)calculateOptionSwitchRect;

@end

@implementation SCSwitchCell

#define kOffset			10
#define kSwitchWidth	97
#define kSwitchHeight	27
#define kTitleFontSize	17

@synthesize titleLabel = _titleLabel, optionSwitch = _optionSwitch;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		[self initializeComponent];
	}
	return self;
}

- (void)initializeComponent {
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_titleLabel = [[UILabel alloc] initWithFrame:[self calculateTitleLabelRect]];
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
	[self.contentView addSubview:_titleLabel];
	
	_optionSwitch = [[UISwitch alloc] initWithFrame:[self calculateOptionSwitchRect]];
	[self.contentView addSubview:_optionSwitch];
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_titleLabel);
	SC_RELEASE_SAFELY(_optionSwitch);
	
    [super dealloc];
}

- (CGRect)calculateTitleLabelRect {

	CGFloat width = CGRectGetWidth(self.contentView.frame);
	CGFloat height = CGRectGetHeight(self.contentView.frame);
	
	CGRect result = CGRectMake(kOffset, 0, width - kSwitchWidth - kOffset * 3, height);
	return result;
}

- (CGRect)calculateOptionSwitchRect {
	
	CGFloat width = CGRectGetWidth(self.contentView.frame);
	CGFloat height = CGRectGetHeight(self.contentView.frame);
	
	CGRect result = CGRectMake(width - kOffset - kSwitchWidth, (height - kSwitchHeight) / 2.,
								kSwitchWidth, kSwitchHeight);
	return result;
}

- (void)layoutSubviews {

	[super layoutSubviews];
	
	self.titleLabel.frame = [self calculateTitleLabelRect];
	self.optionSwitch.frame = [self calculateOptionSwitchRect];
}

@end
