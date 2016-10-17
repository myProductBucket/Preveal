//
//  CollectionImageDiamondCanvas.m
//  precapture
//
//  Created by Randy Crafton on 12/20/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionImageDiamondCanvas.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@implementation CollectionImageDiamondCanvas

@synthesize diamondContainer;

- (NSDictionary *)renderAsDictionary
{
    NSMutableDictionary *dict = [[super renderAsDictionary] mutableCopy];
    [dict setObject:@"CollectionImageDiamondCanvas" forKey:@"class"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)addMask
{
    //Draw a diamond path
    UIBezierPath *maskPath = [self getDiamondPath];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
}

- (UIBezierPath *) getDiamondPath
{
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(self.frame.size.width/2, 0)];
    [maskPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [maskPath addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height)];
    [maskPath addLineToPoint:CGPointMake(0, self.frame.size.height/2)];
    [maskPath addLineToPoint:CGPointMake(self.frame.size.width/2, 0)];
    
    return maskPath;
}

- (void)addSizeLabel
{
    [super addSizeLabel];
    self.sizeLabel.center = self.container.center;
}

- (NSString *) getSizeAsString
{
    double actualCanvasWidth = sqrt(([width doubleValue] * [width doubleValue]) / 2);
    NSDecimalNumber *canvasWidth = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", actualCanvasWidth]];
    double actualCanvasHeight = sqrt(([height doubleValue] * [height doubleValue]) / 2);
    NSDecimalNumber *canvasHeight = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", actualCanvasHeight]];
    return [NSString stringWithFormat:@"%@ x %@", canvasWidth, canvasHeight];
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [[self getDiamondPath] containsPoint:point];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    UIBezierPath *maskPath = [self getDiamondPath];
    [maskPath stroke];
}

@end
