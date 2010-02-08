//
//  SCFTPRequest.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 10/28/09.
//  aleks.nesterow@gmail.com
//	
//	Inspired by http://allseeing-i.com/ASIHTTPRequest/
//	Was using code samples from http://developer.apple.com/iphone/library/samplecode/SimpleFTPSample/index.html
//	and http://developer.apple.com/mac/library/samplecode/CFFTPSample/index.html
//  
//  Copyright © 2009 Screen Customs s.r.o.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the Screen Customs s.r.o. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY Screen Customs s.r.o. "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL Screen Customs s.r.o. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  

#import "SCLog.h"
#import "SCFTPRequest.h"
#import "NSString+ExtensionMethods.h"

NSString *const SCFTPRequestErrorDomain = @"SCFTPRequestErrorDomain";

static NSError *SCFTPRequestTimedOutError;
static NSError *SCFTPAuthenticationError;
static NSError *SCFTPRequestCancelledError;
static NSError *SCFTPUnableToCreateRequestError;

@interface SCFTPRequest (/* Private */)

@property (nonatomic, retain) NSOutputStream *writeStream;
@property (nonatomic, retain) NSInputStream *readStream;

- (void)applyCredentials;
- (void)cleanUp;
- (NSError *)constructErrorWithCode:(NSInteger)code message:(NSString *)message;
- (void)failWithError:(NSError *)error;
- (void)initializeComponentWithURL:(NSURL *)ftpURL operation:(SCFTPRequestOperation)operation;
- (BOOL)isComplete;
- (void)requestFinished;
- (void)setStatus:(SCFTPRequestStatus)status;
- (void)startUploadRequest;
- (void)handleUploadEvent:(NSStreamEvent)eventCode;
- (void)startCreateDirectoryRequest;
- (void)handleCreateDirectoryEvent:(NSStreamEvent)eventCode;

@end

@implementation SCFTPRequest

@synthesize delegate = _delegate, didFinishSelector = _didFinishSelector, didFailSelector = _didFailSelector;
@synthesize willStartSelector = _willStartSelector, didChangeStatusSelector = _didChangeStatusSelector, bytesWrittenSelector = _bytesWrittenSelector;
@synthesize fileSize = _fileSize, bytesWritten = _bytesWritten, error = _error;
@synthesize operation = _operation;
@synthesize userInfo = _userInfo;
@synthesize username = _username, password = _password;
@synthesize ftpURL = _ftpURL, filePath = _filePath, directoryName = _directoryName, fileNameOnFtp = _fileNameOnFtp;

@synthesize status = _status;
- (void)setStatus:(SCFTPRequestStatus)status {
	
	if (_status != status) {
		_status = status;
		if (self.didChangeStatusSelector && [self.delegate respondsToSelector:self.didChangeStatusSelector]) {
			[self.delegate performSelectorOnMainThread:self.didChangeStatusSelector withObject:self waitUntilDone:[NSThread isMainThread]];
		}
	}
}

/* Private */
@synthesize writeStream = _writeStream, readStream = _readStream;

#pragma mark init / dealloc

+ (void)initialize {
	
	if (self == [SCFTPRequest class]) {
		
		SCFTPRequestTimedOutError = [[NSError errorWithDomain:SCFTPRequestErrorDomain
														 code:SCFTPRequestTimedOutErrorType
													 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
															   NSLocalizedString(@"The request timed out.", @""),
															   NSLocalizedDescriptionKey, nil]] retain];	
		SCFTPAuthenticationError = [[NSError errorWithDomain:SCFTPRequestErrorDomain
														code:SCFTPAuthenticationErrorType
													userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
															  NSLocalizedString(@"Authentication needed.", @""),
															  NSLocalizedDescriptionKey, nil]] retain];
		SCFTPRequestCancelledError = [[NSError errorWithDomain:SCFTPRequestErrorDomain
														  code:SCFTPRequestCancelledErrorType
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																NSLocalizedString(@"The request was cancelled.", @""),
																NSLocalizedDescriptionKey, nil]] retain];
		SCFTPUnableToCreateRequestError = [[NSError errorWithDomain:SCFTPRequestErrorDomain
															   code:SCFTPUnableToCreateRequestErrorType
														   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																	 NSLocalizedString(@"Unable to create request (bad url?)", @""),
																	 NSLocalizedDescriptionKey,nil]] retain];
	}
	
	[super initialize];
}

- (id)init {
	
	if (self = [super init]) {
		[self initializeComponentWithURL:nil operation:SCFTPRequestOperationDownload];
	}
	
	return self;
}

- (id)initWithURL:(NSURL *)ftpURL toDownloadFile:(NSString *)filePath {
	
	if (self = [super init]) {
		[self initializeComponentWithURL:ftpURL operation:SCFTPRequestOperationDownload];
		self.filePath = filePath;
	}
	
	return self;
}

- (id)initWithURL:(NSURL *)ftpURL toUploadFile:(NSString *)filePath {
	
	if (self = [super init]) {
		[self initializeComponentWithURL:ftpURL operation:SCFTPRequestOperationUpload];
		self.filePath = filePath;
	}
	
	return self;
}

- (id)initWithURL:(NSURL *)ftpURL toCreateDirectory:(NSString *)directoryName {
	
	if (self = [super init]) {
		[self initializeComponentWithURL:ftpURL operation:SCFTPRequestOperationCreateDirectory];
		self.directoryName = directoryName;
	}
	
	return self;
}

- (void)initializeComponentWithURL:(NSURL *)ftpURL operation:(SCFTPRequestOperation)operation {
	
	self.ftpURL = ftpURL;
	self.operation = operation;
}

+ (id)requestWithURL:(NSURL *)ftpURL toDownloadFile:(NSString *)filePath {
	
	return [[[self alloc] initWithURL:ftpURL toDownloadFile:filePath] autorelease];
}

+ (id)requestWithURL:(NSURL *)ftpURL toUploadFile:(NSString *)filePath {
	
	return [[[self alloc] initWithURL:ftpURL toUploadFile:filePath] autorelease];
}

+ (id)requestWithURL:(NSURL *)ftpURL toCreateDirectory:(NSString *)directoryName {
	
	return [[[self alloc] initWithURL:ftpURL toCreateDirectory:directoryName] autorelease];
}

- (void)dealloc {
	
	[_writeStream release];
	[_readStream release];
	
	[_error release];
	
	[_userInfo release];
	
	[_username release];
	[_password release];
	
	[_ftpURL release];
	[_filePath release];
	[_directoryName release];
	[_fileNameOnFtp release];
	
	[super dealloc];
}

#pragma mark Request logic

- (void)applyCredentials {
	
	if (self.username) {
		if (![self.writeStream setProperty:self.username forKey:(id)kCFStreamPropertyFTPUserName]) {
			
			[self failWithError:
			 [self constructErrorWithCode:SCFTPInternalErrorWhileApplyingCredentialsType
								  message:[NSString stringWithFormat:
										   NSLocalizedString(@"Cannot apply the username \"%@\" to the FTP stream.", @""),
										   self.username]]];
			return;
		}
		if (![self.writeStream setProperty:self.password forKey:(id)kCFStreamPropertyFTPPassword]) {
			[self failWithError:
			 [self constructErrorWithCode:SCFTPInternalErrorWhileApplyingCredentialsType
								  message:[NSString stringWithFormat:
										   NSLocalizedString(@"Cannot apply the password \"%@\" to the FTP stream.", @""),
										   self.password]]];
			return;
		}
	}
}

- (void)cancel {
	
	/* Request may already be complete. */
	if ([self isComplete] || [self isCancelled]) {
		return;
	}
	
	[self cancelRequest];
	[super cancel];
}

- (void)main {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self startRequest];
	[pool release];
}

- (void)cancelRequest {
	
	[self failWithError:SCFTPRequestCancelledError];
}

- (void)startRequest {
	
	_complete = NO;
	_fileSize = 0;
	_bytesWritten = 0;
	_status = SCFTPRequestStatusNone;
	
	switch (self.operation) {
		case SCFTPRequestOperationUpload:
			[self startUploadRequest];
			break;
		case SCFTPRequestOperationCreateDirectory:
			[self startCreateDirectoryRequest];
			break;
	}
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	
    assert(stream == self.writeStream);
	
	switch (self.operation) {
		case SCFTPRequestOperationUpload:
			[self handleUploadEvent:eventCode];
			break;
		case SCFTPRequestOperationCreateDirectory:
			[self handleCreateDirectoryEvent:eventCode];
			break;
	}
}

#pragma mark Upload logic

- (void)startUploadRequest {
	
	if (!self.ftpURL || !self.filePath) {
		[self failWithError:SCFTPUnableToCreateRequestError];
		return;
	}
	
	CFStringRef fileName = NULL;
	if ([NSString isNullOrEmpty:self.fileNameOnFtp]) {
		fileName = (CFStringRef)[self.filePath lastPathComponent];
		if (!fileName) {
			[self failWithError:
			 [self constructErrorWithCode:SCFTPInternalErrorWhileBuildingRequestType
								  message:[NSString stringWithFormat:
										   NSLocalizedString(@"Unable to retrieve file name from file located at %@", @""),
										   self.filePath]]];
			return;
		}
	} else {
		fileName = (CFStringRef)self.fileNameOnFtp;
	}
	
	CFURLRef uploadUrl = CFURLCreateCopyAppendingPathComponent(kCFAllocatorDefault, (CFURLRef)self.ftpURL, fileName, false);
	SC_LOG_DEBUG(@"uploadUrl = %@", (NSString *)uploadUrl);
	if (!uploadUrl) {
		[self failWithError:[self constructErrorWithCode:SCFTPInternalErrorWhileBuildingRequestType
												 message:NSLocalizedString(@"Unable to build URL to upload.", @"")]];
		return;
	}
	
	NSError *attributesError = nil;
	NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:&attributesError];
	if (attributesError) {
		[self failWithError:attributesError];
		return;
	} else {
		_fileSize = [fileAttributes fileSize];
		if (self.willStartSelector && [self.delegate respondsToSelector:self.willStartSelector]) {
			[self.delegate performSelectorOnMainThread:self.willStartSelector withObject:self waitUntilDone:[NSThread isMainThread]];
		}
	}
	
	self.readStream = [NSInputStream inputStreamWithFileAtPath:self.filePath];
	if (!self.readStream) {
		[self failWithError:
		 [self constructErrorWithCode:SCFTPUnableToCreateRequestErrorType
							  message:[NSString stringWithFormat:
									   NSLocalizedString(@"Cannot start reading the file located at %@ (bad path?).", @""),
									   self.filePath]]];
		return;
	}
	
	[self.readStream open];
	
	CFWriteStreamRef uploadStream = CFWriteStreamCreateWithFTPURL(NULL, uploadUrl);
	if (!uploadStream) {
		[self failWithError:
		 [self constructErrorWithCode:SCFTPUnableToCreateRequestErrorType
							  message:[NSString stringWithFormat:
									   NSLocalizedString(@"Cannot open FTP connection to %@", @""),
									   (NSURL *)uploadUrl]]];
		CFRelease(uploadUrl);
		return;
	}
	CFRelease(uploadUrl);
	
	self.writeStream = (NSOutputStream *)uploadStream;
	[self applyCredentials];
	self.writeStream.delegate = self;
	[self.writeStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self.writeStream open];
	
	CFRelease(uploadStream);
}

- (void)handleUploadEvent:(NSStreamEvent)eventCode {
	
	switch (eventCode) {
        case NSStreamEventOpenCompleted: {
			[self setStatus:SCFTPRequestStatusOpenNetworkConnection];
        } break;
        case NSStreamEventHasSpaceAvailable: {
			
            /* If we don't have any data buffered, go read the next chunk of data. */
            if (_bufferOffset == _bufferLimit) {
				
				[self setStatus:SCFTPRequestStatusReadingFromStream];
                NSInteger bytesRead = [self.readStream read:_buffer maxLength:kSCFTPRequestBufferSize];
                if (bytesRead == -1) {
					[self failWithError:
					 [self constructErrorWithCode:SCFTPConnectionFailureErrorType
										  message:[NSString stringWithFormat:
												   NSLocalizedString(@"Cannot continue reading the file at %@", @""),
												   self.filePath]]];
					return;
				} else if (bytesRead == 0) {
					[self requestFinished];
					return;
                } else {
                    _bufferOffset = 0;
                    _bufferLimit = bytesRead;
                }
            }
            
            /* If we're not out of data completely, send the next chunk. */
            
            if (_bufferOffset != _bufferLimit) {
				
                _bytesWritten = [self.writeStream write:&_buffer[_bufferOffset] maxLength:_bufferLimit - _bufferOffset];
                assert(_bytesWritten != 0);
                
				if (_bytesWritten == -1) {
					
					[self failWithError:
					 [self constructErrorWithCode:SCFTPConnectionFailureErrorType
										  message:NSLocalizedString(@"Cannot continue writing file to the specified URL at the FTP server.", @"")]];
					return;
                } else {
					
					[self setStatus:SCFTPRequestStatusWritingToStream];
					
					if (self.bytesWrittenSelector && [self.delegate respondsToSelector:self.bytesWrittenSelector]) {
						[self.delegate performSelectorOnMainThread:self.bytesWrittenSelector withObject:self waitUntilDone:[NSThread isMainThread]];
					}
					
                    _bufferOffset += _bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
			[self failWithError:[self constructErrorWithCode:SCFTPConnectionFailureErrorType
													 message:NSLocalizedString(@"Cannot open FTP connection. Maybe wrong credentials. Please, go to Settings page and double check.", @"")]];
        } break;
        case NSStreamEventEndEncountered: {
			/* Ignore */
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)startCreateDirectoryRequest {
	
	if (!self.ftpURL || !self.directoryName) {
		[self failWithError:SCFTPUnableToCreateRequestError];
		return;
	}
	
	CFURLRef createUrl = CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef)self.ftpURL, (CFStringRef)self.directoryName, true);
	if (!createUrl) {
		[self failWithError:[self constructErrorWithCode:SCFTPInternalErrorWhileBuildingRequestType
												 message:NSLocalizedString(@"Unable to build URL to create directory.", @"")]];
		return;
	}
	
	CFWriteStreamRef createStream = CFWriteStreamCreateWithFTPURL(NULL, createUrl);
	if (!createStream) {
		[self failWithError:
		 [self constructErrorWithCode:SCFTPUnableToCreateRequestErrorType
							  message:[NSString stringWithFormat:
									   NSLocalizedString(@"Cannot open FTP connection to %@", @""),
									   (NSURL *)createUrl]]];
		CFRelease(createUrl);
		return;
	}
	CFRelease(createUrl);
	
	self.writeStream = (NSOutputStream *)createStream;
	[self applyCredentials];
	self.writeStream.delegate = self;
	[self.writeStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self.writeStream open];
	
	CFRelease(createStream);
}

- (void)handleCreateDirectoryEvent:(NSStreamEvent)eventCode {
	
	switch (eventCode) {
        case NSStreamEventOpenCompleted: {
			[self setStatus:SCFTPRequestStatusOpenNetworkConnection];
            /* Despite what it says in the documentation <rdar://problem/7163693>, 
             * you should wait for the NSStreamEventEndEncountered event to see 
             * if the directory was created successfully.  If you shut the stream 
             * down now, you miss any errors coming back from the server in response 
             * to the MKD command. */
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO); /* Should never happen for the output stream. */
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);
        } break;
        case NSStreamEventErrorOccurred: {
            /* -streamError does not return a useful error domain value, so we 
             * get the old school CFStreamError and check it. */
			CFStreamError err = CFWriteStreamGetError((CFWriteStreamRef)self.writeStream);
            if (err.domain == kCFStreamErrorDomainFTP) {
                [self failWithError:
				 [self constructErrorWithCode:SCFTPConnectionFailureErrorType
									  message:[NSString stringWithFormat:NSLocalizedString(@"FTP error %d", @""), (int)err.error]]];
            } else {
				[self failWithError:
				 [self constructErrorWithCode:SCFTPConnectionFailureErrorType
									  message:NSLocalizedString(@"Cannot open FTP connection. Maybe wrong credentials or the folder doesn't exist. Please, go to Settings page and double check.", @"")]];
            }
        } break;
        case NSStreamEventEndEncountered: {
			[self requestFinished];
        } break;
        default: {
            assert(NO);
        } break;
    }	
}

#pragma mark Complete / Failure

- (NSError *)constructErrorWithCode:(NSInteger)code message:(NSString *)message {
	
	return [NSError errorWithDomain:SCFTPRequestErrorDomain
							   code:code
						   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, nil]];
}

- (BOOL)isComplete {
	
	return _complete;
}

- (BOOL)isFinished {
	
	return [self isComplete];
}

- (void)requestFinished {
	
	_complete = YES;
	[self cleanUp];
	
	[self setStatus:SCFTPRequestStatusClosedNetworkConnection];
	
	if (self.didFinishSelector && [self.delegate respondsToSelector:self.didFinishSelector]) {
		[self.delegate performSelectorOnMainThread:self.didFinishSelector withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

- (void)failWithError:(NSError *)error {
	
	_complete = YES;
	
	if (self.error != nil || [self isCancelled]) {
		return;
	}
	
	self.error = error;
	[self cleanUp];
	[self setStatus:SCFTPRequestStatusError];
	
	if (self.didFailSelector && [self.delegate respondsToSelector:self.didFailSelector]) {
		[self.delegate performSelectorOnMainThread:self.didFailSelector withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

- (void)cleanUp {
	
	if (self.writeStream != nil) {
        [self.writeStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.writeStream.delegate = nil;
        [self.writeStream close];
        self.writeStream = nil;
    }
    if (self.readStream != nil) {
        [self.readStream close];
        self.readStream = nil;
    }
}

@end
