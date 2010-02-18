//
//  SCTabOrder.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/12/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Allows to go from one field to another using Next button on the screen keyboard.
//	The last text-field when Done clicked will close the keyboard.
//

#import <Foundation/Foundation.h>

@class SCTabOrderGroup;

@interface SCTabOrder : NSObject<UITextFieldDelegate> {

@private
	NSMutableArray *_textFields;
}

- (void)addTextField:(UITextField *)textField;
- (void)removeTextField:(UITextField *)textField;

@end
