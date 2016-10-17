//
//  PrevealColors.m
//  precapture
//
//  Created by Randy Crafton on 6/6/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "PrevealColors.h"

@implementation PrevealColors
static PrevealColors *sharedInstance = nil;

@synthesize blackFrameColor, woodFrameColor, whiteFrameColor;

+ (PrevealColors *) sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[PrevealColors alloc] init];
        sharedInstance.whiteFrameColor = [UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1];
        sharedInstance.blackFrameColor = [UIColor blackColor];
        sharedInstance.woodFrameColor = [UIColor colorWithRed:85./255. green:48./255. blue:12./255. alpha:1];
    }
    return sharedInstance;
}

@end
