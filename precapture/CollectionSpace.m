//
//  CollectionSpace.m
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "CollectionSpace.h"

@implementation CollectionSpace

@synthesize width, height, x, y, spaceType, spaceShift, originalFrame, myCollection;

- (NSDictionary *)renderAsDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d", width] forKey:@"width"];
    [dict setObject:[NSString stringWithFormat:@"%d", height] forKey:@"height"];
    [dict setObject:[NSString stringWithFormat:@"%d", x] forKey:@"x"];
    [dict setObject:[NSString stringWithFormat:@"%d", y] forKey:@"y"];
    [dict setObject:[NSString stringWithFormat:@"%d", spaceShift] forKey:@"shift"];
    [dict setObject:spaceType forKey:@"type"];
    [dict setObject:@"CollectionSpace" forKey:@"class"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)loadFromDictionary:(NSDictionary *)definition
{
    self.height = [[definition valueForKey:@"height"] intValue];
    self.width = [[definition valueForKey:@"width"] intValue];
    self.x = [[definition valueForKey:@"x"] intValue];
    self.y = [[definition valueForKey:@"y"] intValue];

    self.spaceShift = [[definition valueForKey:@"shift"] intValue];
    self.spaceType = [definition valueForKey:@"type"];
    self.frame = CGRectMake(x, y, width, height);
    self.originalFrame = self.frame;
}

- (void)setCollection:(Collection *)collection
{
    self.myCollection = collection;
}

- (void) doneResizing
{
    return;
}
@end
