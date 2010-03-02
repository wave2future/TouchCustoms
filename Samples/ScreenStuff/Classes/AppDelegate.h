//
//  AppDelegate.h
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	
@private
    UIWindow *_window;
	UINavigationController *_mainNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *mainNavigationController;

@end

