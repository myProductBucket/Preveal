//
//  PrevealColors.h
//  precapture
//
//  Created by Randy Crafton on 6/6/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrevealColors : NSObject {
    UIColor *woodFrameColor;
    UIColor *blackFrameColor;
    UIColor *whiteFrameColor;
}
@property (nonatomic, retain) UIColor *woodFrameColor;
@property (nonatomic, retain) UIColor *blackFrameColor;
@property (nonatomic, retain) UIColor *whiteFrameColor;

+ (PrevealColors *) sharedInstance;

@end
