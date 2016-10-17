//
//  CollectionsTests.m
//  precapture
//
//  Created by Randy Crafton on 3/11/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "CollectionsTests.h"
#import "Collections.h"
#import "Collection.h"
#import "CollectionInstallationManager.h"


@implementation CollectionsTests

@synthesize userCollectionsDirectory;

- (void)setUp
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.userCollectionsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Collections"];
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
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:userCollectionsDirectory];
    NSString *filePath;
    while (filePath = [dirEnum nextObject]) {
        if ([[filePath pathExtension] isEqualToString: @"txt"]) {
            [[NSFileManager defaultManager] removeItemAtPath:[userCollectionsDirectory stringByAppendingPathComponent:filePath] error:&error];
        }
    }
}

- (void)testLoadCollectionsFromUserDocuments
{
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    STAssertNotNil([collections available], @"Should have loaded some collections that were available");
    STAssertTrue([[[collections available] objectAtIndex:0] isKindOfClass:[Collection class]],
                 @"Available array should contain valid collection objects");
}

- (void)testLoadAvailableCollections
{
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    STAssertTrue([[collections available] count] == 3,
                 @"Expected number of available collections does not match actual");

}

- (void)testLoadCollectionsForSale
{
    Collections *collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    STAssertTrue([[collections forPurchase] count] == 0,
                 @"Expected number of purchasable collections does not match actual");    
}

@end
