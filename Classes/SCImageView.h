//
//  SCImageView.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/15/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Represents UIImageView that can load its image asynchronously by URL.
//	While the image is loading, default image is displayed.
//

#import <UIKit/UIKit.h>

@interface SCImageView : UIImageView {

@private
	UIImage *_defaultImage;
	NSURL *_imageUrl;
	
	NSURLConnection *_connection;
	NSMutableData *_imageData;
}

@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, retain) NSURL *imageUrl;

@end
