//
//  NSData+Digests.h
//  TouchCustoms
//
//  Edited by Aleks Nesterow on 03/02/10.
//  aleks.nesterow@gmail.com
//  
//	Original copyright holder unknown. 
//	Maintained by Screen Customs s.r.o.
//  

@interface NSData (Digets)

- (NSData *)md5Digest;
- (NSData *)sha1Digest;
- (NSString *)hexStringValue;
- (NSString *)base64Encoded;
- (NSData *)base64Decoded;

@end
