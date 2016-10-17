//
//  KeyboardToolbarHelper.m
//  precapture
//
//  Created by Randy Crafton on 3/24/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "KeyboardToolbarHelper.h"

@implementation KeyboardToolbarHelper
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
+ (UIToolbar *) makeKeyboardToolbarWithView:(UIView *) view andTarget:(UIViewController *)target
{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    keyboardToolbar.tintColor = [UIColor darkGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:target action:@selector(keyboardPreviousButtonPressed:)],
                               [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:target action:@selector(keyboardNextButtonPressed:)],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:target action:@selector(keyboardNextButtonPressed:)],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:@selector(keyboardDonebuttonPressed:)],
                               nil]];
    return keyboardToolbar;
}



+ (UIToolbar *) makeKeyboardToolbarNoDoneButtonWithView:(UIView *) view andTarget:(UIViewController *)target
{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    keyboardToolbar.tintColor = [UIColor darkGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:target action:@selector(keyboardPreviousButtonPressed:)],
                               [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:target action:@selector(keyboardNextButtonPressed:)],
                               nil]];
    return keyboardToolbar;
}

#pragma clang diagnostic pop

@end
