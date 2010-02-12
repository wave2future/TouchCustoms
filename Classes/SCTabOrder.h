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
	UITextField *_textField, *_textField2, *_textField3, *_textField4;
}

@property (nonatomic, retain) IBOutlet UITextField *textField, *textField2, *textField3, *textField4;

@end
