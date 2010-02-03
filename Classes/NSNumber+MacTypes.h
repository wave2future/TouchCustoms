//
//  NSNumber+MacTypes.h
//  TouchCustoms
//
//  Edited by Aleks Nesterow on 03/02/10.
//  aleks.nesterow@gmail.com
//  
//	Original copyright holder unknown. 
//	Maintained by Screen Customs s.r.o.
//  

@interface NSNumber (MacTypes)

+ (BOOL)parseString:(NSString *)str intoSInt64:(SInt64 *)pNum;
+ (BOOL)parseString:(NSString *)str intoUInt64:(UInt64 *)pNum;

+ (BOOL)parseString:(NSString *)str intoNSInteger:(NSInteger *)pNum;
+ (BOOL)parseString:(NSString *)str intoNSUInteger:(NSUInteger *)pNum;

@end
