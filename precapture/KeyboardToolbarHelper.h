//
//  KeyboardToolbarHelper.h
//  precapture
//
//  Created by Randy Crafton on 3/24/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardToolbarHelper : NSObject

+ (UIToolbar *) makeKeyboardToolbarWithView:(UIView *) view andTarget:(UIViewController *)target;
+ (UIToolbar *) makeKeyboardToolbarNoDoneButtonWithView:(UIView *) view andTarget:(UIViewController *)target;
@end
