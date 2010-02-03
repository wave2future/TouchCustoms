//
//  SCHttpConnection.h
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

@class SCAsyncSocket;
@class SCHttpServer;
@protocol SCHttpResponse;


#define HTTPConnectionDidDieNotification  @"HTTPConnectionDidDie"

@interface SCHttpConnection : NSObject {
	
	SCAsyncSocket *asyncSocket;
	SCHttpServer *server;
	
	CFHTTPMessageRef request;
	int numHeaderLines;
	
	NSString *nonce;
	long lastNC;
	
	NSObject<SCHttpResponse> *httpResponse;
	
	NSMutableArray *ranges;
	NSMutableArray *ranges_headers;
	NSString *ranges_boundry;
	int rangeIndex;
	
	UInt64 requestContentLength;
	UInt64 requestContentLengthReceived;
}

- (id)initWithAsyncSocket:(SCAsyncSocket *)newSocket forServer:(SCHttpServer *)myServer;

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path;

- (BOOL)isSecureServer;
- (NSArray *)sslIdentityAndCertificates;

- (BOOL)isPasswordProtected:(NSString *)path;
- (BOOL)useDigestAccessAuthentication;
- (NSString *)realm;
- (NSString *)passwordForUser:(NSString *)username;

- (NSString *)filePathForURI:(NSString *)path;

- (NSObject<SCHttpResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path;

- (void)prepareForBodyWithSize:(UInt64)contentLength;
- (void)processDataChunk:(NSData *)postDataChunk;

- (void)handleVersionNotSupported:(NSString *)version;
- (void)handleAuthenticationFailed;
- (void)handleResourceNotFound;
- (void)handleInvalidRequest:(NSData *)data;
- (void)handleUnknownMethod:(NSString *)method;

- (NSData *)preprocessResponse:(CFHTTPMessageRef)response;
- (NSData *)preprocessErrorResponse:(CFHTTPMessageRef)response;

- (void)die;

@end
