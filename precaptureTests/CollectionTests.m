//
//  CollectionTests.m
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "CollectionTests.h"
#import "Collection.h"
#import "Collections.h"
#import "CollectionImage.h"
#import "CollectionInstallationManager.h"
#import "PreCaptureSessionDetails.h"
#import "Scalinator.h"

@implementation CollectionTests

@synthesize collection;

- (void) setUp 
{
    self.collection = [[Collection alloc] init];
    [self deleteAllUserCollectionFiles];
    [CollectionInstallationManager copyCollectionsIfNeeded];
}

- (void)tearDown 
{
    [self deleteAllUserCollectionFiles];
    [CollectionInstallationManager copyCollectionsIfNeeded];
    
}

- (void)deleteAllUserCollectionFiles
{
    NSError *error = nil;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *userCollectionsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Collections"];

    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:userCollectionsDirectory];
    NSString *filePath;
    while (filePath = [dirEnum nextObject]) {
        if ([[filePath pathExtension] isEqualToString: @"txt"]) {
            [[NSFileManager defaultManager] removeItemAtPath:[userCollectionsDirectory stringByAppendingPathComponent:filePath] error:&error];
        }
    }
}

- (void)testEmptyCollectionIsEmpty
{
    STAssertTrue([collection.subviews isEqualToArray:[[NSArray alloc] init]], 
                 @"Empty collection should have no subviews");
}

- (void)testSavesPriceCorrectly
{
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    self.collection = (Collection *)[[collections currentGroup] objectAtIndex:0];
    STAssertTrue([collection.price isEqualToString:@"0.00"], 
                 @"Collection already has price");
    collection.price = @"1000.00";
    [collection saveToFile];
    
    [collections loadCollectionsFromUserDocuments];
    self.collection = (Collection *)[[collections currentGroup] objectAtIndex:0];
    STAssertTrue([collection.price isEqualToString:@"1000.00"],
                 @"Collection price not set when reloaded from filesystem");
}

- (void)testIncludesImagesAndSpacesInView
{
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    self.collection = (Collection *)[[collections currentGroup] objectAtIndex:0];
    STAssertTrue([collection.subviews count] > 0,
                 @"No subviews in collection");
}

- (void)testFrameIsSizedBasedOnTheSizeOfImageInLayout
{
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    self.collection = (Collection *)[[collections currentGroup] objectAtIndex:0];
    STAssertTrue(collection.frame.size.width == 52.0,
                 @"Collection (%@) width does not match the accumulated sizes of images and space (Expected 52, Actual %f", 
                  collection.name, collection.frame.size.width);
    STAssertTrue(collection.frame.size.height == 24,
                 @"Collection (%@) height does not match the accumulated sizes of images and space (Expected 24, Actual %f)",
                 collection.name, collection.frame.size.height);

}

- (void)testCanRenderSelfInScaleToRoom
{
    [[[PreCaptureSessionDetails sharedInstance] scalinator] setActualSize:[NSDecimalNumber decimalNumberWithString:@"8.5"]];
    [[[PreCaptureSessionDetails sharedInstance] scalinator] setReferenceSize:[NSDecimalNumber decimalNumberWithString:@"85"]];
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    self.collection = (Collection *)[[collections currentGroup] objectAtIndex:0];
    [collection scaleViewToRoom];
    STAssertTrue(collection.frame.size.width == 520.0,
                 @"Scaled view does not match 10 times original. (Expected 520, Actual %f)",
                 collection.frame.size.width);
}

@end
