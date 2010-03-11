//
//  SCRadioViewController.h
//  TouchCustoms
//
//  Created by Aleks Nesterow on 12/22/09.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2009 Screen Customs s.r.o.
//	All rights reserved.
//	
//	Purpose
//	Provides a generic way to display one-choice options.
//

@class SCRadioController;

@protocol SCRadioControllerDelegate<NSObject>

- (void)radioController:(SCRadioController *)radioController setSelectedIndex:(NSUInteger)selectedIndex forKey:(NSString *)key;

@end

@interface SCRadioController : UITableViewController {
	
@private
	id<SCRadioControllerDelegate> _delegate;
	
	NSUInteger _selectedIndex;
	NSArray *_optionList;
	NSString *_key;
	SEL _selector;
}

@property (nonatomic, assign) id<SCRadioControllerDelegate> delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, retain) NSArray *optionList;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) SEL selector;

@end
