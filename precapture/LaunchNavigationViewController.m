//
//  LaunchNavigationViewController.m
//  precapture
//
//  Created by Karl Faust on 4/5/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import "LaunchNavigationViewController.h"

@implementation LaunchNavigationViewController

- (UIInterfaceOrientationMask) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
