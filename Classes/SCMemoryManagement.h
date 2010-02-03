//
//  SCMemoryManagement.h
//
//  Created by Aleks Nesterow on 11/19/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o.
//  All rights reserved.
//  
//  Purpose
//	Contains macros to make memory management easier.
//

#define SC_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define SC_AUTORELEASE_SAFELY(__POINTER) { [__POINTER autorelease]; __POINTER = nil; }
#define SC_RELEASE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
