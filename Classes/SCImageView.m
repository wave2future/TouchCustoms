//
//  SCImageView.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/15/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCImageView.h"

#import "SCMemoryManagement.h"

@implementation SCImageView

@synthesize defaultImage = _defaultImage, imageUrl = _imageUrl;

- (void)setDefaultImage:(UIImage *)value {

	if (_defaultImage != value) {
	
		SC_RELEASE_SAFELY(_defaultImage);
		_defaultImage = [value retain];
		
		if (!super.image) {
			super.image = _defaultImage;
		}
	}
}

- (void)setImageUrl:(NSURL *)value {

	if (_imageUrl != value) {
	
		[_connection cancel];
		
		SC_RELEASE_SAFELY(_imageData);
		_imageData = [[NSMutableData alloc] init];
		
		SC_RELEASE_SAFELY(_imageUrl);
		_imageUrl = [value retain];
		
		_connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_imageUrl] delegate:self];
		[_connection start];
	}
}

- (void)dealloc {
	
	[_connection cancel];
	SC_RELEASE_SAFELY(_connection);
	
	SC_RELEASE_SAFELY(_defaultImage);
	SC_RELEASE_SAFELY(_imageUrl);
	SC_RELEASE_SAFELY(_imageData);
	
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

	[_imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

	SC_RELEASE_SAFELY(_imageData);
	SC_RELEASE_SAFELY(_connection);
	
	super.image = self.defaultImage;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	super.image = [UIImage imageWithData:_imageData];
	SC_RELEASE_SAFELY(_imageData);
}

@end
