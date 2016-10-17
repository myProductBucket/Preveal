//
//  NSString+Utility.m
//  precapture
//
//  Created by Urban Drescher on 3/21/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)
- (BOOL)checkText {//check the Quiz Name and Time in ModalEffectView
    NSString *rawString = self;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        // Text was empty or only whitespace.
        
        return NO;
    }
    return YES;
}
@end
