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

- (void)__initializeComponent;
- (CGRect)__calculateTitleLabelRect;
- (CGRect)__calculateOptionSwitchRect;

@end

@implementation SCSwitchCell

#define kOffset			10
#define kSwitchWidth	97
#define kSwitchHeight	27
#define kTitleFontSize	17

@synthesize titleLabel = _titleLabel, optionSwitch = _optionSwitch;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		[self __initializeComponent];
	}
	
	return self;
}

- (void)__initializeComponent {
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_titleLabel = [[UILabel alloc] initWithFrame:[self __calculateTitleLabelRect]];
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
	[self.contentView addSubview:_titleLabel];
	
	_optionSwitch = [[UISwitch alloc] initWithFrame:[self __calculateOptionSwitchRect]];
	[self.contentView addSubview:_optionSwitch];
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_titleLabel);
	SC_RELEASE_SAFELY(_optionSwitch);
	
    [super dealloc];
}

- (CGRect)__calculateTitleLabelRect {

	CGFloat width = CGRectGetWidth(self.contentView.frame);
	CGFloat height = CGRectGetHeight(self.contentView.frame);
	
	CGRect result = CGRectMake(kOffset, 0, width - kSwitchWidth - kOffset * 3, height);
	return result;
}

- (CGRect)__calculateOptionSwitchRect {
	
	CGFloat width = CGRectGetWidth(self.contentView.frame);
	CGFloat height = CGRectGetHeight(self.contentView.frame);
	
	CGRect result = CGRectMake(width - kOffset - kSwitchWidth, (height - kSwitchHeight) / 2.,
								kSwitchWidth, kSwitchHeight);
	return result;
}

- (void)layoutSubviews {

	[super layoutSubviews];
	
	self.titleLabel.frame = [self __calculateTitleLabelRect];
	self.optionSwitch.frame = [self __calculateOptionSwitchRect];
}

@end
