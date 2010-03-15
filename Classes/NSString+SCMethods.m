//
//  NSString+ExtensionMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 7/19/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009-2010 Screen Customs s.r.o. All rights reserved.
//  

#import "NSString+SCMethods.h"

@interface NSString (SCMethodsPrivate)

+ (CGFloat)widthOfString:(NSString *)aString withFont:(UIFont *)font;

@end

@implementation NSString (SCMethods)

+ (BOOL)isNullOrEmpty:(NSString *)aString {
	
	if (!aString)
		return YES;
	
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	aString = [aString stringByTrimmingCharactersInSet:whitespace];
	
	if ([@"" isEqualToString:aString])
		return YES;
	
	return NO;
}

+ (NSString *)stringFromInteger:(NSInteger)anInteger {
	
	return [NSString stringWithFormat:@"%d", anInteger];
}

+ (NSString *)stringFromDouble:(double)aDouble {

	return [NSString stringWithFormat:@"%f", aDouble];
}

- (NSString *)stringByTruncatingWith:(NSString *)truncateString measuringAgainstFont:(UIFont *)font
							forWidth:(CGFloat)width {
	
	/* First check maybe the string already fits the specified width, then we simply return it as a new NSString. */
	
	CGFloat stringWidth = [NSString widthOfString:self withFont:font];
	if (stringWidth <= width) {
		return [NSString stringWithString:self];
	}
	
	/* 
	 * Before starting modifying the long string check whether we have enough place for truncateString.
	 * If not, then we simply return truncateString, the resulting string cannot be shorter than this 
	 * combination anyway. 
	 */
	
	CGFloat truncateStringWidth = [NSString widthOfString:truncateString withFont:font];
	
	if (truncateStringWidth >= width) {
		return [NSString stringWithString:truncateString];
	}
	
	/* Only now there is motivation to start modifying the string. */
	
    NSMutableString *temp = [self mutableCopy];
	
	[temp appendString:truncateString];
	stringWidth = [NSString widthOfString:temp withFont:font];
	
    NSRange range = { temp.length - 1 - truncateString.length, 1 };
	
	while (stringWidth > width && range.location > 0) {
		
		[temp deleteCharactersInRange:range];
		range.location--;
		stringWidth = [NSString widthOfString:temp withFont:font];
	}
	
	NSString *result = [NSString stringWithString:temp];
	[temp release];
	return result;
}

+ (CGFloat)widthOfString:(NSString *)aString withFont:(UIFont *)font {
	
	return [aString sizeWithFont:font forWidth:NSUIntegerMax lineBreakMode:UILineBreakModeCharacterWrap].width;
}

@end
