//
//  SCHttpAuthenticationRequest.h
//  TouchCustoms
//
//  Edited by Aleks Nesterow on 03/02/10.
//  aleks.nesterow@gmail.com
//  
//	Original copyright holder unknown. 
//	Maintained by Screen Customs s.r.o.
//  

#if TARGET_OS_IPHONE
// Note: You may need to add the CFNetwork Framework to your project
#import <CFNetwork/CFNetwork.h>
#endif

@interface SCHttpAuthenticationRequest : NSObject
{
	BOOL isBasic;
	BOOL isDigest;
	
	NSString *base64Credentials;
	
	NSString *username;
	NSString *realm;
	NSString *nonce;
	NSString *uri;
	NSString *qop;
	NSString *nc;
	NSString *cnonce;
	NSString *response;
}
- (id)initWithRequest:(CFHTTPMessageRef)request;

- (BOOL)isBasic;
- (BOOL)isDigest;

// Basic
- (NSString *)base64Credentials;

// Digest
- (NSString *)username;
- (NSString *)realm;
- (NSString *)nonce;
- (NSString *)uri;
- (NSString *)qop;
- (NSString *)nc;
- (NSString *)cnonce;
- (NSString *)response;

@end
