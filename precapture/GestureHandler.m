//
//  GestureController.m
//  precapture
//
//  Created by Randy Crafton on 4/12/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "GestureHandler.h"

@implementation GestureHandler

@synthesize relativeView, viewToAdjust;



- (IBAction)move:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:relativeView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [viewToAdjust center].x;
        _firstY = [viewToAdjust center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [viewToAdjust setCenter:translatedPoint];
}


- (IBAction)scale:(id)sender {
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = viewToAdjust.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [viewToAdjust setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
}
@end
