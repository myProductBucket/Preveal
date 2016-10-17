//
//  PreCaptureSessionDetails.h
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scalinator;

@interface PreCaptureSessionDetails : NSObject{
    UIImage *roomImage;
    Scalinator *scalinator;
}

@property (nonatomic, retain) UIImage *roomImage;
@property (nonatomic, retain) Scalinator *scalinator;

+ (id)sharedInstance;

@end
