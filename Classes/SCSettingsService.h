//
//  SCSettingsService.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 2/26/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Provides functionality to access and persist application settings.
//

@interface SCSettingsService : NSObject {

}

/** Returns [NSUserDefaults standardUserDefaults].
  * Just an easy-access method for inheritors.
  */
@property (nonatomic, readonly) NSUserDefaults *defaults;

/** Returns the value of the property with the specified key.
  * If there is no such property, YES will be returned.
  * In case you need the property to be NO by default, use boolForKey:defaultValue: method
  * and pass NO as defaultValue.
  * 
  * While it's quite possible, you are not encouraged to use this method explicitly.
  * This is only to be used by inheritor's concrete properties for easy access.
  */
- (BOOL)boolForKey:(NSString *)key;

/** Returns the value of the property with the specified key.
  * If there is no such property, defaultValue will be returned.
  * 
  * While it's quite possible, you are not encouraged to use this method explicitely.
  * This is only to be used by inheritor's concrete properties for easy access.
  */
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

/** Sets the value for the property with the specified key.
  * While it's quite possible, you are not encouraged to use this method explicitely.
  * This is only to be used by inheritor's concrete properties for easy access.
  */
- (void)setBool:(BOOL)value forKey:(NSString *)key;

@end
