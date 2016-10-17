//
//  MyDBMetadata.m
//  precapture
//
//  Created by Daniel Muller on 28/04/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import "MyDBMetadata.h"

@implementation MyDBMetadata

@synthesize metadata;
@synthesize thumbnailPath;

//- (id)init {
//    MyDBMetadata *me = [self init];
//    return me;
//}

- (id)initWithMetadata: (DBMetadata *)meta {
    MyDBMetadata *me = [self init];
    me.metadata = meta;
    return me;
}

- (id)initWithMetadata: (DBMetadata *)meta andThumbnailPath: (NSString *)desPath {
    MyDBMetadata *me = [self init];
    me.metadata = meta;
    me.thumbnailPath = desPath;
    
    return me;
}

@end
