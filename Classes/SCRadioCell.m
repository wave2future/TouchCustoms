//
//  SCRadioCell.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/11/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCRadioCell.h"

#import "SCColorScheme.h"
#import "SCMemoryManagement.h"

@implementation SCRadioCell

#define kDefaultSelectedColor	RGB(56, 84, 135)
#define kDefaultColor			[UIColor blackColor]

@synthesize selectedColor = _selectedColor, defaultColor = _defaultColor;

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_selectedColor);
	SC_RELEASE_SAFELY(_defaultColor);
	
    [super dealloc];
}

#pragma mark State management

- (void)setAccessoryType:(UITableViewCellAccessoryType)value {
	
	[super setAccessoryType:value];
	
	UIColor *textColor;
	
	if (UITableViewCellAccessoryCheckmark == value) {
		textColor = self.selectedColor ? self.selectedColor : kDefaultSelectedColor;
	} else {
		textColor = self.defaultColor ? self.defaultColor : kDefaultColor;
	}
	
	self.textLabel.textColor = textColor;
}

@end
