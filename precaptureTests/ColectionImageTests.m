//
//  ColectionImageTests.m
//  precapture
//
//  Created by Randy Crafton on 3/11/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "ColectionImageTests.h"
#import "Collections.h"
#import "Collection.h"
#import "CollectionImage.h"

@implementation ColectionImageTests


- (void)testFrameIsSizedBasedOnTheSizeOfImageInLayout
{
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    Collection *collection = (Collection *)[[collections currentGroup] objectAtIndex:0];
    
    CollectionImage *firstImage = [collection.imageLayout objectAtIndex:0];
    STAssertTrue(firstImage.frame.size.width == firstImage.width,
                 @"Image not initially scaled properly.");
}
@end
