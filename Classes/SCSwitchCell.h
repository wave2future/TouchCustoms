//
//  SCSwitchCell.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/18/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Represents UITableViewCell with UISwitch on the right and descriptive text on the left.
//

#import <UIKit/UIKit.h>

@interface SCSwitchCell : UITableViewCell {

@private
	UILabel *_titleLabel;
	UISwitch *_optionSwitch;
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UISwitch *optionSwitch;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
