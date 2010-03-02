//
//  AppDelegate.m
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/2/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"

#import "SCMemoryManagement.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController = _mainController;

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_mainController);
	SC_RELEASE_SAFELY(_window);
    
	[super dealloc];
}

#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
      
    [self.window addSubview:self.mainController.view];
    [self.window makeKeyAndVisible];
}

@end
