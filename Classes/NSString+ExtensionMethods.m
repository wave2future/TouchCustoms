//
//  NSString+ExtensionMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 7/19/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009-2010 Screen Customs s.r.o. All rights reserved.
//  

#import "NSString+ExtensionMethods.h"

@implementation NSString (ExtensionMethods)

+ (BOOL)isNullOrEmpty:(NSString *)aString {
	
	if (!aString)
		return YES;
	
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	aString = [aString stringByTrimmingCharactersInSet:whitespace];
	
	if ([@"" isEqualToString:aString])
		return YES;
	
	return NO;
}

+ (NSString *)stringFromInteger:(NSInteger)value {
	
	return [NSString stringWithFormat:@"%d", value];
}

@end
