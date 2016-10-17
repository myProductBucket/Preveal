//
//  PreCaptureSessionDetails.m
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "PreCaptureSessionDetails.h"
#import "Scalinator.h"

@implementation PreCaptureSessionDetails

static PreCaptureSessionDetails *sharedInstance = nil;

@synthesize roomImage, scalinator;

+ (id)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[PreCaptureSessionDetails alloc] init];
        sharedInstance.scalinator = [[Scalinator alloc] init];
    }
    return sharedInstance;
}

@end
