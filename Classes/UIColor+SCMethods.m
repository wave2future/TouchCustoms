//
//  UIColor+SCMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/16/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "UIColor+SCMethods.h"

@implementation UIColor (SCMethods)

- (CGColorSpaceModel)colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString {
	switch ([self colorSpaceModel]) {
		case kCGColorSpaceModelUnknown:
			return @"kCGColorSpaceModelUnknown";
		case kCGColorSpaceModelMonochrome:
			return @"kCGColorSpaceModelMonochrome";
		case kCGColorSpaceModelRGB:
			return @"kCGColorSpaceModelRGB";
		case kCGColorSpaceModelCMYK:
			return @"kCGColorSpaceModelCMYK";
		case kCGColorSpaceModelLab:
			return @"kCGColorSpaceModelLab";
		case kCGColorSpaceModelDeviceN:
			return @"kCGColorSpaceModelDeviceN";
		case kCGColorSpaceModelIndexed:
			return @"kCGColorSpaceModelIndexed";
		case kCGColorSpaceModelPattern:
			return @"kCGColorSpaceModelPattern";
		default:
			return NSLocalizedString(@"Invalid color space", @"");
	}
}

- (BOOL)canProvideRGBComponents {
	return (([self colorSpaceModel] == kCGColorSpaceModelRGB) || 
			([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

- (CGFloat)red {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) {
		return c[0];
	}
	return c[1];
}

- (CGFloat)blue {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) {
		return c[0];
	}
	return c[2];
}

- (CGFloat)alpha {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[CGColorGetNumberOfComponents(self.CGColor) - 1];
}

- (NSString *)stringFromColor {
	NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use stringFromColor");
	return [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
}

- (NSString *)hexStringFromColor {
	
	NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use hexStringFromColor");
	
	CGFloat r, g, b;
	r = self.red;
	g = self.green;
	b = self.blue;
	
	// Fix range if needed
	if (r < 0.0f) r = 0.0f;
	if (g < 0.0f) g = 0.0f;
	if (b < 0.0f) b = 0.0f;
	
	if (r > 1.0f) r = 1.0f;
	if (g > 1.0f) g = 1.0f;
	if (b > 1.0f) b = 1.0f;
	
	// Convert to hex string between 0x00 and 0xFF
	return [NSString stringWithFormat:@"%02X%02X%02X",
			(int)(r * 255), (int)(g * 255), (int)(b * 255)];
}

+ (UIColor *)colorWithString:(NSString *)stringToConvert {
	
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	if (![scanner scanString:@"{" intoString:NULL]) return nil;
	const NSUInteger kMaxComponents = 4;
	CGFloat c[kMaxComponents];
	NSUInteger i = 0;
	if (![scanner scanFloat:&c[i++]]) return nil;
	while (1) {
		if ([scanner scanString:@"}" intoString:NULL]) break;
		if (i >= kMaxComponents) return nil;
		if ([scanner scanString:@"," intoString:NULL]) {
			if (![scanner scanFloat:&c[i++]]) return nil;
		} else {
			// either we're at the end of there's an unexpected character here
			// both cases are error conditions
			return nil;
		}
	}
	
	if (![scanner isAtEnd]) return nil;
	UIColor *color;
	switch (i) {
		case 2: // monochrome
			color = [UIColor colorWithWhite:c[0] alpha:c[1]];
			break;
		case 4: // RGB
			color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
			break;
		default:
			color = nil;
	}
	return color;
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}

@end
