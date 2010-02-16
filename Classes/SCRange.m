//
//  SCRange.m
//  TouchCustoms
//
//  Edited by Aleks Nesterow on 03/02/10.
//  aleks.nesterow@gmail.com
//  
//	Original copyright holder unknown. 
//	Maintained by Screen Customs s.r.o.
//  

#import "SCRange.h"
#import "NSNumber+SCMacTypes.h"

SCRange SCUnionRange(SCRange range1, SCRange range2) {
	
	SCRange result;
	
	result.location = MIN(range1.location, range2.location);
	result.length   = MAX(SCMaxRange(range1), SCMaxRange(range2)) - result.location;
	
	return result;
}

SCRange SCIntersectionRange(SCRange range1, SCRange range2) {
	
	SCRange result;
	
	if((SCMaxRange(range1) < range2.location) || (SCMaxRange(range2) < range1.location)) {
		return SCMakeRange(0, 0);
	}
	
	result.location = MAX(range1.location, range2.location);
	result.length   = MIN(SCMaxRange(range1), SCMaxRange(range2)) - result.location;
	
	return result;
}

NSString *SCStringFromRange(SCRange range) {
	
	return [NSString stringWithFormat:@"{%qu, %qu}", range.location, range.length];
}

SCRange SCRangeFromString(NSString *aString) {
	
	SCRange result = SCMakeRange(0, 0);
	
	// NSRange will ignore '-' characters, but not '+' characters
	NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"+0123456789"];
	
	NSScanner *scanner = [NSScanner scannerWithString:aString];
	[scanner setCharactersToBeSkipped:[cset invertedSet]];
	
	NSString *str1 = nil;
	NSString *str2 = nil;
	
	BOOL found1 = [scanner scanCharactersFromSet:cset intoString:&str1];
	BOOL found2 = [scanner scanCharactersFromSet:cset intoString:&str2];
	
	if(found1) [NSNumber parseString:str1 intoUInt64:&result.location];
	if(found2) [NSNumber parseString:str2 intoUInt64:&result.length];
	
	return result;
}

@implementation NSValue (NSValueSCRangeExtensions)

+ (NSValue *)valueWithSCRange:(SCRange)range {
	
	return [NSValue valueWithBytes:&range objCType:@encode(SCRange)];
}

- (SCRange)SCrangeValue {
	
	SCRange result;
	[self getValue:&result];
	return result;
}

@end
