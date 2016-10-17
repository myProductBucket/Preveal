//
//  GestureController.h
//  precapture
//
//  Created by Randy Crafton on 4/12/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GestureHandler : NSObject <UIGestureRecognizerDelegate> {
    /*** Scaling Stuff ***/
    CGFloat _lastScale;
	CGFloat _lastRotation;  
    
    /*** Panning Stuff ***/
	CGFloat _firstX;
	CGFloat _firstY;
    
    /*** ***/
    UIView *relativeView;
    UIView *viewToAdjust;

    
}

@property (nonatomic, retain) UIView *relativeView;
@property (nonatomic, retain) UIView *viewToAdjust;


- (IBAction)move:(id)sender;

- (IBAction)scale:(id)sender;



@end
