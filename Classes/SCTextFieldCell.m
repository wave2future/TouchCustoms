//
//  SCTextFieldCell.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/18/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCColorScheme.h"
#import "SCTextFieldCell.h"
#import "SCMemoryManagement.h"

@interface SCTextFieldCell (/* Private methods */)

- (CGRect)calculateTitleLabelRect;
- (CGRect)calculateTextFieldRect;
- (void)initializeComponent;

@end

@implementation SCTextFieldCell

#define kOffset						10
#define kDefaultTextFieldLeftOffset 120
#define kTextFieldHeight			31

@synthesize titleLabel = _titleLabel, textField = _textField, textFieldLeftOffset = _textFieldLeftOffset;

- (void)setTextFieldLeftOffset:(CGFloat)value {

	if (_textFieldLeftOffset != value) {
		_textFieldLeftOffset = value;
		[self setNeedsLayout];
	}
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		[self initializeComponent];
	}
	
	return self;
}

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_titleLabel);
	SC_RELEASE_SAFELY(_textField);
	
    [super dealloc];
}

- (void)initializeComponent {
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_textFieldLeftOffset = kDefaultTextFieldLeftOffset;
	
	/* titleLabel */
	
	_titleLabel = [[UILabel alloc] initWithFrame:[self calculateTitleLabelRect]];
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:17];
	
	[self.contentView addSubview:_titleLabel];
	
	/* textField */
	
	_textField = [[UITextField alloc] initWithFrame:[self calculateTextFieldRect]];
	_textField.borderStyle = UITextBorderStyleNone;
	_textField.font = [UIFont systemFontOfSize:17];
	_textField.textColor = SETTINGS_TEXT_COLOR;
	
	[self.contentView addSubview:_textField];
}

- (void)layoutSubviews {

	[super layoutSubviews];
	
	self.titleLabel.frame = [self calculateTitleLabelRect];
	self.textField.frame = [self calculateTextFieldRect];
}

- (CGRect)calculateTitleLabelRect {

	CGRect result = CGRectMake(kOffset, 0, self.textFieldLeftOffset, CGRectGetHeight(self.contentView.frame));
	return result;
}

- (CGRect)calculateTextFieldRect {
	
	CGRect result = CGRectMake(self.textFieldLeftOffset, (CGRectGetHeight(self.contentView.frame) - kTextFieldHeight) / 2. + 5,
							   CGRectGetWidth(self.contentView.frame) - self.textFieldLeftOffset - kOffset, kTextFieldHeight);
	return result;
}

@end
