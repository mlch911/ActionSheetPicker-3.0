//
//Copyright (c) 2011, Tim Cinel
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//* Neither the name of the <organization> nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#import "ActionSheetPickerViewController.h"
#import "ActionSheetPicker.h"
#import "ActionSheetDistancePicker.h"
#import "ActionSheetDatePicker.h"
#import "NSDate+TCUtils.h"

@implementation ActionSheetPickerViewController

@synthesize animals = _animals;

@synthesize selectedIndex = _selectedIndex;
@synthesize selectedDate = _selectedDate;
@synthesize selectedBigUnit = _selectedBigUnit;
@synthesize selectedSmallUnit = _selectedSmallUnit;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animals = [NSArray arrayWithObjects:@"Aardvark", @"Beaver", @"Cheetah", @"Deer", @"Elephant", @"Frog", @"Gopher", @"Horse", @"Impala", @"...", @"Zebra", nil];
    self.selectedDate = [NSDate date];
}

- (void)viewDidUnload {
    self.actionSheetPicker = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)selectAnItem:(UIControl *)sender {
    [ActionSheetPicker showPickerWithTitle:@"Select Animal" 
                                      rows:self.animals 
                          initialSelection:self.selectedIndex 
                                    target:self
                                    action:@selector(itemWasSelected:element:) 
                                    origin:sender];
    
    
    //Example ActionSheetPicker using customButtons
//    self.actionSheetPicker = [[ActionSheetPicker alloc] initWithTitle:@"Select Animal" 
//                                                                 rows:self.animals 
//                                                     initialSelection:self.selectedIndex 
//                                                               target:self
//                                                               action:@selector(itemWasSelected:element:) 
//                                                               origin:sender];
//    
//    [self.actionSheetPicker addCustomButtonWithTitle:@"Special" value:[NSNumber numberWithInt:1]];
//    self.actionSheetPicker.hideCancel = YES;
//    
//    [self.actionSheetPicker showActionSheetPicker];    
    
}

- (IBAction)selectADate:(UIControl *)sender {
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" 
                                                           datePickerMode:UIDatePickerModeDate 
                                                             selectedDate:self.selectedDate
                                                                   target:self 
                                                                   action:@selector(dateWasSelected:element:) 
                                                                   origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] dateByAdddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    
    [self.actionSheetPicker showActionSheetPicker];
    
//    [ActionSheetDatePicker showPickerWithTitle:@"Select Date" 
//                                datePickerMode:UIDatePickerModeDate 
//                                  selectedDate:self.selectedDate                                                                             
//                                        target:self 
//                                        action:@selector(dateWasSelected:element:) 
//                                        origin:sender];
}

- (IBAction)animalButtonTapped:(UIBarButtonItem *)sender {
    [self selectAnItem:sender];
}

- (IBAction)dateButtonTapped:(UIBarButtonItem *)sender {
    [self selectADate:sender];
}

- (IBAction)selectAMeasurement:(UIControl *)sender {
    [ActionSheetDistancePicker showPickerWithTitle:@"Select Length" 
                                     bigUnitString:@"m" bigUnitMax:330 selectedBigUnit:self.selectedBigUnit
                                   smallUnitString:@"cm" smallUnitMax:99 selectedSmallUnit:self.selectedSmallUnit
                                            target:self 
                                            action:@selector(measurementWasSelectedWithBigUnit:smallUnit:element:) 
                                            origin:sender];
}

#pragma mark -
#pragma mark Implementation

- (void)itemWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.animals objectAtIndex:self.selectedIndex]];
    }
}


- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.selectedDate description]];
    }
}

- (void)measurementWasSelectedWithBigUnit:(NSNumber *)bigUnit smallUnit:(NSNumber *)smallUnit element:(id)element {
    self.selectedBigUnit = [bigUnit intValue];
    self.selectedSmallUnit = [smallUnit intValue];
    [element setText:[NSString stringWithFormat:@"%i m and %i cm", [bigUnit intValue], [smallUnit intValue]]];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark -
#pragma mark Memory Management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)dealloc {
    self.animals = nil;
    self.selectedDate = nil;
    self.actionSheetPicker = nil;
    [super dealloc];
}

@end