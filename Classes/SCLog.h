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

#define SC_LEVEL_TRACE		0 /* All level messages will go through. */
#define SC_LEVEL_DEBUG		1
#define SC_LEVEL_INFO		2
#define SC_LEVEL_WARNING	3
#define SC_LEVEL_ERROR		4 /* Only error-level messages will go through. */
#define SC_LEVEL_OFF		5 /* No log messages will be produced. */

#ifndef SC_LOG_LEVEL

#if TARGET_IPHONE_SIMULATOR != 0
#define SC_LOG_LEVEL SC_LEVEL_TRACE
#else
#define SC_LOG_LEVEL SC_LEVEL_OFF
#endif

#endif

#if SC_LOG_LEVEL == SC_LEVEL_TRACE
#define SC_LOG_TRACE(CAT, MSG, ...)	\
NSLog(@"[T] [%@] %s:%d:%@", CAT, \
	__PRETTY_FUNCTION__, __LINE__, \
	[NSString stringWithFormat:MSG, ## __VA_ARGS__] \
);
#else
#define SC_LOG_TRACE(CAT, MSG, ...)
#endif

#if (SC_LOG_LEVEL <= SC_LEVEL_DEBUG)
#define SC_LOG_DEBUG(CAT, MSG, ...)	\
NSLog(@"[D] [%@] %s:%d:%@", CAT, \
	__PRETTY_FUNCTION__, __LINE__, \
	[NSString stringWithFormat:MSG, ## __VA_ARGS__] \
);
#else
#define SC_LOG_DEBUG(CAT, MSG, ...)
#endif

#if (SC_LOG_LEVEL <= SC_LEVEL_INFO)
#define SC_LOG_INFO(CAT, MSG, ...) \
NSLog(@"[I] [%@] %s:%d:%@", CAT, \
	__PRETTY_FUNCTION__, __LINE__, \
	[NSString stringWithFormat:MSG, ## __VA_ARGS__] \
);
#else
#define SC_LOG_INFO(CAT, MSG, ...)
#endif

#if (SC_LOG_LEVEL <= SC_LEVEL_WARNING)
#define SC_LOG_WARNING(CAT, MSG, ...) \
NSLog(@"[W] [%@] %s:%d:%@", CAT, \
	__PRETTY_FUNCTION__, __LINE__, \
	[NSString stringWithFormat:MSG, ## __VA_ARGS__] \
);
#else
#define SC_LOG_WARNING(CAT, MSG, ...)
#endif

#if (SC_LOG_LEVEL <= SC_LEVEL_ERROR)
#define SC_LOG_ERROR(CAT, MSG, ...)	\
NSLog(@"[E] [%@] %s:%d:%@", CAT, \
	__PRETTY_FUNCTION__, __LINE__, \
	[NSString stringWithFormat:MSG, ## __VA_ARGS__] \
);
#else
#define SC_LOG_ERROR(CAT, MSG, ...)
#endif
