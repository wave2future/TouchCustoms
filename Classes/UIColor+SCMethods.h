//
//  UIColor+SCMethods.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/16/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Extension methods for UIColor.
//

#import <UIKit/UIKit.h>

@interface UIColor (SCMethods)

- (CGColorSpaceModel)colorSpaceModel;
- (NSString *)colorSpaceString;
- (BOOL)canProvideRGBComponents;
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;
- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
