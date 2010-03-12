//
//  SCRadioViewController.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 12/22/09.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2009 Screen Customs s.r.o.
//	All rights reserved.
//	

#import "SCRadioController.h"
#import "SCRadioCell.h"
#import "SCMemoryManagement.h"

@implementation SCRadioController

@synthesize delegate = _delegate;
@synthesize selectedIndex = _selectedIndex;
@synthesize optionList = _optionList;
@synthesize key = _key;
@synthesize selector = _selector;

- (void)setOptionList:(NSArray *)value {
	
	if (_optionList != value) {
		
		[_optionList release];
		_optionList = [value retain];
		
		[self.tableView reloadData];
	}
}

- (void)setSelectedIndex:(NSUInteger)value {
	
	if (_selectedIndex != value) {
		_selectedIndex = value;
		[self.tableView reloadData];
	}
}

#pragma mark init / dealloc

- (void)dealloc {
	
	SC_RELEASE_SAFELY(_optionList);
	SC_RELEASE_SAFELY(_key);
	
    [super dealloc];
}

#pragma mark View lifecycle

- (void)viewDidLoad {

	[super viewDidLoad];
	
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
														  style:UITableViewStyleGrouped];
	
	tableView.dataSource = self;
	tableView.delegate = self;
	
	self.tableView = tableView;
	
	[tableView release];
}

- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];
	
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]
						  atScrollPosition:UITableViewScrollPositionMiddle
								  animated:YES];
}

#pragma mark TableView callbacks

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellId = @"radio-cell";
	
	SCRadioCell *cell = (SCRadioCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
	if (!cell) {
		cell = [[[SCRadioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
	}
	
	if (_selectedIndex == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.textLabel.text = [_optionList objectAtIndex:indexPath.row];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return _optionList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger rowCount = [tableView numberOfRowsInSection:indexPath.section];
	
	for (NSUInteger i = 0; i < rowCount; i++) {
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
		[cell setSelected:NO animated:YES];
		
		if (i != indexPath.row) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		} else {
			_selectedIndex = indexPath.row;
			
			if ([self.delegate respondsToSelector:@selector(radioController:setSelectedIndex:forKey:)]) {
				[self.delegate radioController:self setSelectedIndex:self.selectedIndex forKey:self.key];
			}
			
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	}
}

@end
