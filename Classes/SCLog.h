//
//  SCLog.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/8/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SC_LOG_LEVEL
#if TARGET_IPHONE_SIMULATOR != 0
#define SC_LOG_LEVEL 0
#else
#define SC_LOG_LEVEL 5
#endif
#endif

#if SC_LOG_LEVEL == 0
#define SC_LOG_TRACE(MSG, ...)		NSLog(@"[T] %s:%d:%@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:MSG, ## __VA_ARGS__]);
#else
#define SC_LOG_TRACE(MSG, ...)
#endif

#if (SC_LOG_LEVEL <= 1)
#define SC_LOG_DEBUG(MSG, ...)		NSLog(@"[D] %s:%d:%@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:MSG, ## __VA_ARGS__]);
#else
#define SC_LOG_DEBUG(MSG, ...)
#endif

#if (SC_LOG_LEVEL <= 2)
#define SC_LOG_INFO(MSG, ...)		NSLog(@"[I] %s:%d:%@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:MSG, ## __VA_ARGS__]);
#else
#define SC_LOG_INFO(MSG, ...)
#endif

#if (SC_LOG_LEVEL <= 3)
#define SC_LOG_WARNING(MSG, ...)	NSLog(@"[W]: %s:%d:%@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:MSG, ## __VA_ARGS__]);
#else
#define SC_LOG_WARNING(MSG, ...)
#endif

#if (SC_LOG_LEVEL <= 4)
#define SC_LOG_ERROR(MSG, ...)		NSLog(@"[E]: %s:%d:%@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:MSG, ## __VA_ARGS__]);
#else
#define SC_LOG_ERROR(MSG, ...)
#endif
