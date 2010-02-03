//
//  SCHttpServer.h
//  TouchCustoms
//
//  Edited by Aleks Nesterow on 03/02/10.
//  aleks.nesterow@gmail.com
//  
//	Original copyright holder unknown. 
//	Maintained by Screen Customs s.r.o.
//  

@class SCAsyncSocket;

@interface SCHttpServer : NSObject {
	
	// Underlying asynchronous TCP/IP socket
	SCAsyncSocket *asyncSocket;
	
	// Standard delegate
	id delegate;
	
	// HTTP server configuration
	NSURL *documentRoot;
	Class connectionClass;
	
	// NSNetService and related variables
	NSNetService *netService;
	NSString *domain;
	NSString *type;
	NSString *name;
	UInt16 port;
	NSDictionary *txtRecordDictionary;
	
	NSMutableArray *connections;
	
	BOOL _isRunning;
}

- (id)delegate;
- (void)setDelegate:(id)newDelegate;

- (NSURL *)documentRoot;
- (void)setDocumentRoot:(NSURL *)value;

- (Class)connectionClass;
- (void)setConnectionClass:(Class)value;

- (NSString *)domain;
- (void)setDomain:(NSString *)value;

- (NSString *)type;
- (void)setType:(NSString *)value;

- (NSString *)name;
- (NSString *)publishedName;
- (void)setName:(NSString *)value;

- (UInt16)port;
- (void)setPort:(UInt16)value;

- (NSDictionary *)TXTRecordDictionary;
- (void)setTXTRecordDictionary:(NSDictionary *)dict;

- (BOOL)start:(NSError **)error;
- (BOOL)stop;

- (uint)numberOfHTTPConnections;

- (BOOL)isRunning;

@end
