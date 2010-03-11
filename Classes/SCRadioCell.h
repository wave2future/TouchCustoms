//
//  SCRadioCell.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/11/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	UITableViewCell that is used in RadioController.
//

@interface SCRadioCell : UITableViewCell {

@private
	UIColor *_selectedColor, *_defaultColor;
}

@property (nonatomic, retain) UIColor *selectedColor, *defaultColor;

@end
