//
//  PrevealRootNavigationController.m
//  precapture
//
//  Created by Randy Crafton on 12/12/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "PrevealRootNavigationController.h"
#import "HamburglerMenuViewController.h"

@implementation PrevealRootNavigationController





- (UIInterfaceOrientationMask) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
