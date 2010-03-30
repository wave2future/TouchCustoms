//
//  SymbolicProgressBarViewController.h
//  ScreenStuff
//
//  Created by Aleks Nesterow on 3/30/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	SCSymbolicProgressBar show-case.
//

@class SCSymbolicProgressBar;

@interface SymbolicProgressBarController : UIViewController {

@private
	SCSymbolicProgressBar *_progressBar, *_progressBar2, *_progressBar3, *_progressBar4;
	NSTimer *_timer;
	BOOL _started;
}

@property (nonatomic, retain) IBOutlet SCSymbolicProgressBar *progressBar, *progressBar2, *progressBar3, *progressBar4;

- (IBAction)startStopPressed:(id)sender;

@end
