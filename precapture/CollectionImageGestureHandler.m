//
//  CollectionImageGestureHandler.m
//  precapture
//
//  Created by Randy Crafton on 4/16/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionImageGestureHandler.h"
#import "CollectionImage.h"

@implementation CollectionImageGestureHandler


- (IBAction)move:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:relativeView];
//    CollectionImage *collectionImage = (CollectionImage *)viewToAdjust;
  
    float deltaX = translatedPoint.x;
    float deltaY = translatedPoint.y;
    /*
     if dragging pulls the vertical edge inside the frame, stop it by setting deltaY = 0
     ditto horizontal
     */
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [viewToAdjust center].x;
        _firstY = [viewToAdjust center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+deltaX, _firstY+deltaY);
    [viewToAdjust setCenter:translatedPoint];
}

@end
