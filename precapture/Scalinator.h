//
//  Scalinator.h
//  PreCapture
//
//  Created by Randy Crafton on 3/8/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scalinator : NSObject {
    NSDecimalNumber *actualSize;
    NSDecimalNumber *referenceSize;
    NSDecimalNumber *ratio;
}

@property (nonatomic, retain) NSDecimalNumber *actualSize;
@property (nonatomic, retain) NSDecimalNumber *referenceSize;
@property (nonatomic, retain) NSDecimalNumber *ratio;

- (NSDecimalNumber *)getRatio;

- (NSDecimalNumber *)getAdjustedSize: (NSDecimalNumber *)startingSize;

- (CGRect)getAdjustedFrame: (CGRect)startingFrame;

- (CGRect)getAdjustedFrame: (CGRect)startingFrame withX: (float) newX andY: (float)newY;

@end
