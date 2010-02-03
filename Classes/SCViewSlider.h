//
//  SCViewSlider.h
//  iAudition
//
//  Created by Aleks Nesterow on 10/20/09.
//  aleks.nesterow@gmail.com
//  
//  Copyright © 2009 Screen Customs s.r.o.
//  All rights reserved.
//  
//  Purpose
//  There are cases when the screen keyboard hides a text-field. SCViewSlider allows to slide the view up to keep that text-field
//  in front of the eyes, and then back down when the keyboard becomes hidden.
//

typedef enum {
	SCSlideDirectionUp,
	SCSlideDirectionDown
} SCSlideDirection;

@interface SCViewSlider : NSObject<UITextFieldDelegate> {

@private
	UIView *_viewToSlide;
	CGFloat _ySlideDistance;
	CGFloat _heightSlideDistance;
	CGFloat _slideDuration;
	BOOL _hideKeyboardOnReturn;
}

@property (nonatomic, retain) IBOutlet UIView *viewToSlide;
@property (nonatomic, assign) CGFloat ySlideDistance;
@property (nonatomic, assign) CGFloat heightSlideDistance;
@property (nonatomic, assign) CGFloat slideDuration;
@property (nonatomic, assign) BOOL hideKeyboardOnReturn;

@end
