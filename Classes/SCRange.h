//
//  SCRange.h
//  TouchCustoms
//
//  Edited by Aleks Nesterow on 03/02/10.
//  aleks.nesterow@gmail.com
//  
//	Original copyright holder unknown. 
//	Maintained by Screen Customs s.r.o.
//  
//	Purpose
//	
//	SCRange is the functional equivalent of a 64 bit NSRange.
//	The SCHttpServer is designed to support very large files.
//	On 32 bit architectures (PPC, i386) NSRange uses unsigned 32 bit integers.
//	This only supports a range of up to 4 gigabytes.
//	By defining our own variant, we can support a range up to 16 exabytes.
//	
//	All effort is given such that SCRange functions EXACTLY the same as NSRange.
//	

@class NSString;

typedef struct _SCRange {
    UInt64 location;
    UInt64 length;
} SCRange;

typedef SCRange *SCRangePointer;

NS_INLINE SCRange SCMakeRange(UInt64 loc, UInt64 len) {
    SCRange r;
    r.location = loc;
    r.length = len;
    return r;
}

NS_INLINE UInt64 SCMaxRange(SCRange range) {
    return (range.location + range.length);
}

NS_INLINE BOOL SCLocationInRange(UInt64 loc, SCRange range) {
    return (loc - range.location < range.length);
}

NS_INLINE BOOL SCEqualRanges(SCRange range1, SCRange range2) {
    return ((range1.location == range2.location) && (range1.length == range2.length));
}

FOUNDATION_EXPORT SCRange SCUnionRange(SCRange range1, SCRange range2);
FOUNDATION_EXPORT SCRange SCIntersectionRange(SCRange range1, SCRange range2);
FOUNDATION_EXPORT NSString *SCStringFromRange(SCRange range);
FOUNDATION_EXPORT SCRange SCRangeFromString(NSString *aString);

@interface NSValue (NSValueSCRangeExtensions)

+ (NSValue *)valueWithSCRange:(SCRange)range;
- (SCRange)SCrangeValue;

@end
