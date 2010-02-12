//
//  SCTabOrder.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/12/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCTabOrder.h"
#import "SCMemoryManagement.h"

@implementation SCTabOrder

@synthesize textField = _textField, textField2 = _textField2, textField3 = _textField3, textField4 = _textField4;

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_textField);
	SC_RELEASE_SAFELY(_textField2);
	SC_RELEASE_SAFELY(_textField3);
	SC_RELEASE_SAFELY(_textField4);
	
	[super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	if (textField == self.textField) {
		[self.textField2 becomeFirstResponder];
	} else if (textField == self.textField2) {
		[self.textField3 becomeFirstResponder];
	} else if (textField == self.textField3) {
		[self.textField4 becomeFirstResponder];
	} else if (textField == self.textField4) {
		[self.textField4 resignFirstResponder];
	}
	
	return YES;
}

@end
