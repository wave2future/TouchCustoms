//
//  SCSettingsService.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/26/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "SCSettingsService.h"

@implementation SCSettingsService

- (NSUserDefaults *)defaults {

	return [NSUserDefaults standardUserDefaults];
}

- (BOOL)boolForKey:(NSString *)key {
	
	return [self boolForKey:key defaultValue:YES];
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
	
	return [self.defaults objectForKey:key] ? [self.defaults boolForKey:key] : defaultValue;
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {

	[self.defaults setBool:value forKey:key];
}

@end
