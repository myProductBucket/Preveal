//
//  PrevealSlidingViewController.h
//  precapture
//
//  Created by Randy Crafton on 3/21/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSlidingViewController.h"

@interface PrevealSlidingViewController : SCSlidingViewController

- (void) keyboardDidHide:(NSNotification *)aNotification;
- (void) keyboardDidShow:(NSNotification *)aNotification;
@end
