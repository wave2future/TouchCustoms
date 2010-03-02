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

@class MainController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	
@private
    UIWindow *_window;
	MainController *_mainController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainController *mainController;

@end

