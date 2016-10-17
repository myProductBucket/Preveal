//
//  Scalinator.m
//  PreCapture
//
//  Created by Randy Crafton on 3/8/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "Scalinator.h"

@implementation Scalinator

@synthesize actualSize, referenceSize, ratio;

- (NSDecimalNumber *)getRatio
{
    if (self.ratio == nil) {
        self.ratio = [referenceSize decimalNumberByDividingBy:actualSize];
    }
    return self.ratio;
}

- (NSDecimalNumber *)getAdjustedSize: (NSDecimalNumber *)startingSize
{
    return [startingSize decimalNumberByMultiplyingBy:[self getRatio] 
                                         withBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                             scale:1
                                                                                                  raiseOnExactness:NO
                                                                                                   raiseOnOverflow:NO
                                                                                                  raiseOnUnderflow:NO
                                                                                               raiseOnDivideByZero:YES]
            ];
}



- (CGRect)getAdjustedFrame: (CGRect)startingFrame
{
    NSDecimalNumber *startingWidth = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", startingFrame.size.width]];
    NSDecimalNumber *startingHeight = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", startingFrame.size.height]];
    float newWidth = [[self getAdjustedSize:startingWidth] floatValue];
    float newHeight = [[self getAdjustedSize:startingHeight] floatValue];
    NSDecimalNumber *startingX = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", startingFrame.origin.x]];
    float newX = [[self getAdjustedSize:startingX] floatValue];
    NSDecimalNumber *startingY = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", startingFrame.origin.y]];
    float newY = [[self getAdjustedSize:startingY] floatValue];
    return CGRectMake(newX, newY, newWidth, newHeight);
}

- (CGRect)getAdjustedFrame: (CGRect)startingFrame withX: (float) newX andY: (float)newY
{
    NSDecimalNumber *startingWidth = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", startingFrame.size.width]];
    NSDecimalNumber *startingHeight = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", startingFrame.size.height]];
    float newWidth = [[self getAdjustedSize:startingWidth] floatValue];
    float newHeight = [[self getAdjustedSize:startingHeight] floatValue];
    return CGRectMake(newX, newY, newWidth, newHeight);

}

@end
