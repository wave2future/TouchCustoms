//
//  SCActivityIndicator.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 7/22/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o. All rights reserved.
//  
//  Purpose
//  Combines UIActivityIndicatorView and UILabel with current operation under one hood.
//

@interface SCActivityIndicator : UIView {
	
@private
	UIActivityIndicatorView *_indicatorView;
	UILabel	*_statusLabel;
}

@property (nonatomic, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, readonly) UILabel	*statusLabel;

- (NSString *)statusMessage;
- (void)setStatusMessage:(NSString *)value;

@end
