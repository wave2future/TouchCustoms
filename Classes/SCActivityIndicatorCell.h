//
//  SCActivityIndicatorCell.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/16/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	UITableViewCell with a title and UIActivityIndicator.
//

#import <UIKit/UIKit.h>

@interface SCActivityIndicatorCell : UITableViewCell {

@private /* @property */
	UILabel *_refreshLabel;
@private
	UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, readonly) UILabel *refreshLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setLoading:(BOOL)value;

@end
