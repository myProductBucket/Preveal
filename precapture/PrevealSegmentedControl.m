//
//  PrevealSegmentedControl.m
//  precapture
//
//  Created by Randy Crafton on 4/7/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "PrevealSegmentedControl.h"

@implementation PrevealSegmentedControl

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger current = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
    if (current == self.selectedSegmentIndex) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}
@end
