//
//	SCColorScheme.h
//	TouchCustoms
//	
//	Created by Aleks Nesterow on 2/18/10.
//	aleks.nesterow@gmail.com
//	
//	Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	

#import <UIKit/UIKit.h>

#define RGBA(R, G, B, A)	[UIColor colorWithRed:R / 255. green:G / 255. blue:B / 255. alpha:A / 255.]
#define RGB(R, G, B)		RGBA(R, G, B, 255)

#define SETTINGS_TEXT_COLOR	RGB(57, 85, 135)
