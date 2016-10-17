//
//  CreatedCollectionSaver.m
//  precapture
//
//  Created by Randy Crafton on 1/19/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "CreatedCollectionHandler.h"
#import "Collection.h"
#import "Collections.h"
#import "CollectionImage.h"
#import "CollectionFramedImage.h"
#import "Scalinator.h"
#import "PreCaptureSessionDetails.h"
#import <QuartzCore/QuartzCore.h>
#import "SecureUDID.h"


@implementation CreatedCollectionHandler

@synthesize collection, openings;

- (Collection *) handleCollectionCreationWithOpenings: (NSMutableArray *) withOpenings
{
    self.collection = [[Collection alloc] init];
    self.openings = withOpenings;
    
    [self sortCollectionOpenings];
    [self addOpeningsToCollection];
    [self calculateOriginsForOpenings];
    [self setCollectionDefaults];
    collection.imageLayout = [NSArray arrayWithArray:openings];

    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    NSError *error = nil;
    [collections setCurrentGroupName:kPrevealMyCollectionsGroupName error:&error];
    collection.order = [NSString stringWithFormat:@"%lu", [collections.currentGroup count] + 1];
    
    return self.collection;    
}

- (void) sortCollectionOpenings
{
    [openings sortUsingComparator: ^(id obj1, id obj2) {
        CGPoint first = [(CollectionImage *) obj1 frame].origin;
        CGPoint second = [(CollectionImage *) obj2 frame].origin;
        
        NSComparisonResult result;
        if (first.x > second.x) { result = NSOrderedDescending; }
        if (first.x < second.x) { result = NSOrderedAscending; }
        if (first.x == second.x) {
            if (first.y > second.y) { result = NSOrderedDescending; }
            if (first.y < second.y) { result = NSOrderedAscending; }
            if (first.y == second.y) { result = NSOrderedSame; }
        }
        
        return result;
    }];
    
    
}

- (void) addOpeningsToCollection
{
    NSEnumerator *e = [openings objectEnumerator];
    CollectionImage *currentOpening;

    CGPoint origin = [(CollectionImage *)[openings objectAtIndex:0] frame].origin;
     origin = CGPointMake([self getMinX], [self getMinY]);
    
    currentOpening = [openings lastObject];
    collection.frame = CGRectMake(
                                  origin.x,
                                  origin.y,
                                  currentOpening.frame.origin.x + currentOpening.frame.size.width - origin.x,
                                  currentOpening.frame.origin.y + currentOpening.frame.size.height - origin.y);
    
    while (currentOpening = [e nextObject]) {
        currentOpening.frame = CGRectMake(currentOpening.frame.origin.x - origin.x,
                                          currentOpening.frame.origin.y - origin.y,
                                          currentOpening.frame.size.width,
                                          currentOpening.frame.size.height);
        [collection addSubview:currentOpening];

    }
    
}

- (float) getMinX
{
    
    float minX = [(CollectionImage *)[openings objectAtIndex:0] frame].origin.x;
    for (CollectionImage *nextCollection in openings) {
        if (nextCollection.frame.origin.x < minX) {
            minX = nextCollection.frame.origin.x;
        }
    }
    return minX;
}


- (float) getMinY
{
    
    float minY = [(CollectionImage *)[openings objectAtIndex:0] frame].origin.y;
    for (CollectionImage *nextCollection in openings) {
        if (nextCollection.frame.origin.y < minY) {
            minY = nextCollection.frame.origin.y;
        }
    }
    return minY;
}

- (void) calculateOriginsForOpenings
{
    NSEnumerator *e = [openings objectEnumerator];
    CollectionImage *currentOpening;
    

    Scalinator *scalinator = [[PreCaptureSessionDetails sharedInstance] scalinator];
    NSDecimalNumber *tempDecimal;
    
    while (currentOpening = [e nextObject]) {
        tempDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", currentOpening.frame.origin.x]];
        if ([currentOpening class] == [CollectionFramedImage class]) {
            [(CollectionFramedImage *)currentOpening setFrameX:[tempDecimal decimalNumberByDividingBy:[scalinator getRatio]]];
        } else {
            currentOpening.x = [tempDecimal decimalNumberByDividingBy:[scalinator getRatio]];
        }
        tempDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", currentOpening.frame.origin.y]];
        if ([currentOpening class] == [CollectionFramedImage class]) {
            [(CollectionFramedImage *)currentOpening setFrameY:[tempDecimal decimalNumberByDividingBy:[scalinator getRatio]]];
        } else {
            currentOpening.y = [tempDecimal decimalNumberByDividingBy:[scalinator getRatio]];
        }
    }


}

- (void) setCollectionDefaults
{
    self.collection.file_name = [self createFileName];
    self.collection.groupName = kPrevealMyCollectionsGroupName;
    collection.priceDescription = @"Canvas";
    collection.price2Description = @"Metal";
    collection.price3Description = @"Acrylic";
    collection.price4Description = @"Standout";
    collection.free = @"YES";
    collection.purchased = @"NO";
    collection.type = @"collection";
    
    
    
    collection.price = @"0.00";
    collection.name = @" ";
    collection.order = @"0";
    collection.inAppPrice = @"0";
    collection.show = @"1";
    collection.description = @" ";
    collection.isFavorite = @"0";
    collection.initialRotation = @"0";
    
    NSError *error = nil;
    Collections *myCollections = [[Collections alloc] init];
    [myCollections loadCollectionsFromUserDocuments];
    [myCollections setCurrentGroupName:kPrevealMyCollectionsGroupName error:&error];
    if (error == nil) {
        collection.order = [NSString stringWithFormat:@"%lu", [myCollections.currentGroup count] + 1];
    }
    myCollections.allCollections = nil;
    myCollections.currentGroup = nil;
    myCollections = nil;
    
}
- (NSString *) createFileName
{
    return [NSString stringWithFormat:@"%@_%f.txt", [SecureUDID UDIDForDomain:@"com.chrisandadriennescott.preveal" usingKey:@"secret"], [[NSDate date] timeIntervalSince1970]];
}

@end
