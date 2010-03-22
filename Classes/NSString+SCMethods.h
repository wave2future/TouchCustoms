//
//  NSString+SCMethods.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 7/19/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009-2010 Screen Customs s.r.o. All rights reserved.
//  
//  Purpose
//  Extension methods for NSString.
//

@interface NSString (SCMethods)

+ (BOOL)isNullOrEmpty:(NSString *)aString;
+ (NSString *)stringFromInteger:(NSInteger)anInteger;
+ (NSString *)stringFromDouble:(double)aDouble;
- (NSString *)stringByAddingPercentEscapes;
- (NSString *)stringByTruncatingWith:(NSString *)truncateString measuringAgainstFont:(UIFont *)font
							forWidth:(CGFloat)width;

@end
