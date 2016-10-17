//
//  CollectionShelf.m
//  precapture
//
//  Created by Randy Crafton on 8/29/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "CollectionShelf.h"
#import <QuartzCore/QuartzCore.h>

@implementation CollectionShelf
- (void) configureViewDetails
{
    self.backgroundColor = [UIColor blackColor];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOpacity:.7];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)configureGestureRecognizers
{
    self.userInteractionEnabled = NO;
    self.multipleTouchEnabled = NO;
}

- (void)addSizeLabel
{
    return;
}
@end
