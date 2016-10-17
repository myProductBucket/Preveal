//
//  Collections.m
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "Collections.h"
#import "Collection.h"
#import "Collections.h"
#import "Scalinator.h"
#import "PreCaptureSessionDetails.h"
#import "PrevealCommunityUrls.h"


#include <malloc/malloc.h>

@implementation Collections

@synthesize currentGroup, forPurchase, allCollections, currentCommunityUrl, collectionsData;
@synthesize inCommunityView, totalNumberOfRowsInCommunityView, currentFirstRowLoaded, currentLastRowLoaded, currentConnection;
@synthesize currentBaseUrl, currentEndTarget, currentFrontTarget, currentlyDescending, focusOnFrontOfStack, currentlyDownloading;

+ (Collection *) loadCollectionFromFileNamed:(NSString *)fileName
{
    NSError *error = nil;

    NSString *userCollectionsDirectory = [Collections getUserCollectionsDirectory];
    NSString *collectionFilePath = [userCollectionsDirectory stringByAppendingPathComponent:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:collectionFilePath];
    NSDictionary *jsonObject  = [NSJSONSerialization JSONObjectWithData:jsonData 
                                                                options:NSJSONReadingMutableLeaves 
                                                                  error:&error];
    Collection *collection = [[Collection alloc] init];
    [collection loadFromDictionary:jsonObject];
    return collection;
    
}

- (void) incrementEndTarget: (NSInteger)target
{
//    NSLog(@"Starting endTarget: %@", currentEndTarget);
    self.focusOnFrontOfStack = NO;
    self.currentEndTarget = [NSNumber numberWithInteger:[currentEndTarget integerValue] + target];
//    NSLog(@"Setting endTarget to: %@", currentEndTarget);

    if ([currentEndTarget compare:currentLastRowLoaded] == NSOrderedDescending && currentlyDownloading == NO) {
        [self loadCommunityCollectionsUsingUrl:currentBaseUrl descending:currentlyDescending];
    }
}
- (void) decrementFrontTarget: (NSInteger)target
{
//    NSLog(@"Starting frontTarget: %@", currentFrontTarget);

    self.focusOnFrontOfStack = YES;
    
    // Validate we don't go below zero.
    if ([currentFrontTarget intValue] > target) {
        self.currentEndTarget = [NSNumber numberWithInteger:[currentEndTarget integerValue] - target];
    } else {
        self.currentFrontTarget =[NSNumber numberWithInt:0];
    }
    
    
    if ([currentFrontTarget compare:currentFirstRowLoaded] == NSOrderedAscending & currentlyDownloading == NO) {
        [self loadCommunityCollectionsUsingUrl:currentBaseUrl descending:currentlyDescending];
    }
 //   NSLog(@"Setting frontTarget to: %@", currentFrontTarget);

}

+ (NSString *) getUserCollectionsDirectory
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Collections"];
}

- (void)loadCollectionsFromUserDocuments 
{
    self.inCommunityView = NO;
    NSError *error = nil;
    NSString *userCollectionsDirectory = [Collections getUserCollectionsDirectory];
    NSDirectoryEnumerator *dirEnum =   [[NSFileManager defaultManager] enumeratorAtPath:userCollectionsDirectory];
    
    NSString *filePath;
    self.allCollections = [NSMutableArray array];
    NSData *jsonData;
    NSDictionary *jsonObject;
    Collection *collection;

    while (filePath = [dirEnum nextObject]) {
        if ([[filePath pathExtension] isEqualToString: @"txt"]) {
            // process the document
            jsonData = [NSData dataWithContentsOfFile:[userCollectionsDirectory stringByAppendingPathComponent:filePath]];
            jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData 
                                              options:NSJSONReadingMutableLeaves 
                                                error:&error];

            if (error != nil) {
                NSLog(@"Error Loading JSON description for file at: %@", filePath);
                NSLog(@"Error description-%@ \n", [error localizedDescription]);
                NSLog(@"Error reason-%@", [error localizedFailureReason]);
            }
            collection = [[Collection alloc] init];
            [collection loadFromDictionary:jsonObject];
            [allCollections addObject:collection];
        }
    }

    [allCollections sortUsingComparator: ^(id obj1, id obj2) {
        int first = [[(Collection*)obj1 order] intValue];
        int second = [[(Collection*)obj2 order] intValue];
        if (first > second) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        
        if (first < second) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        return (NSComparisonResult) NSOrderedSame;
    }];

    self.currentGroup = [NSMutableArray arrayWithArray:allCollections];
}

- (void) cancelWaitAndRerunConnection
{
    NSLog(@"canceling connection.");
    [self.currentConnection cancel];
    self.currentConnection = nil;
    
    // Fuck this is ugly. The cancel call on the connection object above doesn't really work or doesn't work immediately
    // So wait a few seconds before we try to get more data so the current request has time to piss off.
    [self performSelector:@selector(loadCurrentURL) withObject:nil afterDelay:0.5];
}

- (void)filterAvailable
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"show == %@", @"1"];
    self.currentGroup = [NSMutableArray arrayWithArray:[currentGroup filteredArrayUsingPredicate:predicate]];
}

- (void)scaleAllAvailable
{
    Scalinator *scalinator = [[PreCaptureSessionDetails sharedInstance] scalinator];

    NSEnumerator *e = [currentGroup objectEnumerator];
    Collection *collection;
    while (collection = [e nextObject]) {
        [collection scaleViewToRoom:scalinator];
    }
}


- (void) loadCurrentURL
{
    [self loadCommunityCollectionsUsingUrl:currentBaseUrl descending:currentlyDescending];
}



- (void) loadCommunityCollectionsUsingUrl:(NSURL *) url descending:(BOOL)isDescending
{
    if (![[url absoluteString] isEqualToString:[currentBaseUrl absoluteString]]) {
        
        NSLog(@"New URL");
        
        self.currentGroup = [[NSMutableArray alloc] init];
        self.currentLastRowLoaded = [NSNumber numberWithInt:0];
        self.currentFirstRowLoaded = [NSNumber numberWithInt:0];
        if (self.currentConnection != nil) {
            NSLog(@"canceling connection.");
            self.currentBaseUrl = url;
            [self cancelWaitAndRerunConnection];
            return;
        }
    } else if (isDescending != currentlyDescending) {
        
        self.currentGroup = [[NSMutableArray alloc] init];
        self.currentBaseUrl = url;
        self.currentlyDescending = isDescending;
        
        [self cancelWaitAndRerunConnection];
        return;
    }
    self.currentBaseUrl = url;
    self.currentlyDescending = isDescending;
    self.currentlyDownloading = YES;
    if (self.currentLastRowLoaded == nil) {
        self.currentLastRowLoaded = [NSNumber numberWithInt:0];
        self.currentFirstRowLoaded = [NSNumber numberWithInt:0];
    }
    if (focusOnFrontOfStack) {
        if (isDescending) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?descending=true&skip=%d&limit=%d", [url absoluteString], [currentFirstRowLoaded intValue] - kPrevealCommunityRecordsPerRequest, kPrevealCommunityRecordsPerRequest]];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?skip=%d&limit=%d", [url absoluteString], [currentFirstRowLoaded intValue] - kPrevealCommunityRecordsPerRequest, kPrevealCommunityRecordsPerRequest]];
        }
    } else {
        if (isDescending) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?descending=true&skip=%@&limit=%d", [url absoluteString], currentLastRowLoaded, kPrevealCommunityRecordsPerRequest]];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?skip=%@&limit=%d", [url absoluteString], currentLastRowLoaded, kPrevealCommunityRecordsPerRequest]];
        }

    }
    NSLog( @"%@", url);
   
    self.collectionsData = [[NSMutableData alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    self.currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [currentConnection start];
    
    
}

- (void) updateCollection: (Collection *)newCollection
{
    [self updateCollection:newCollection inArray:allCollections];
    [self updateCollection:newCollection inArray:currentGroup];
}

-(void) updateCollection: (Collection *)newCollection inArray: (NSMutableArray *)collections
{    
    if (collections == nil || collections.count == 0 || newCollection == nil) {
        return;
    }
    
    int count = 0;
    NSEnumerator *e = [collections objectEnumerator];
    Collection *currentCollection;
    while (currentCollection = [e nextObject]) {
        if ([currentCollection.file_name isEqualToString:newCollection.file_name]) {
            break;
        }
        count++;
    }
    [collections replaceObjectAtIndex:count withObject:newCollection];
}


- (void) trimCommunityArray
{
    NSIndexSet *indexesToRemove;
    if (focusOnFrontOfStack) {
        // trim from end
        indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([currentLastRowLoaded intValue] - kPrevealCommunityRecordsPerRequest, kPrevealCommunityRecordsPerRequest)];
        self.currentLastRowLoaded = [NSNumber numberWithInt:[currentLastRowLoaded intValue] - kPrevealCommunityRecordsPerRequest];
    } else {
        indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([currentFirstRowLoaded intValue], kPrevealCommunityRecordsPerRequest)];
        self.currentFirstRowLoaded = [NSNumber numberWithInt:[currentFirstRowLoaded intValue] + kPrevealCommunityRecordsPerRequest];
        self.currentFrontTarget = currentFirstRowLoaded;
    }
    @try {
        [currentGroup removeObjectsAtIndexes:indexesToRemove];
    }
    @catch (NSException *exception) {
        if (exception.name != NSRangeException) {
            @throw;
        }
    }
    @finally {
        
    }
    
}

- (void)setCurrentGroupName: (NSString *) currentGroupName error:(NSError * __autoreleasing *)error
{
    if ([currentGroupName isEqualToString:kPrevealCommunityGroupName]) {
        self.currentGroup = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPrevealCollectionsDownloadStarting
                                                            object:self];
        PrevealCommunityUrls *urls = [[PrevealCommunityUrls alloc] init];
        NSURL *url = [urls getMostPopularUrl];
        self.currentEndTarget = [NSNumber numberWithInteger:kPrevealCommunityRecordsPerRequest];
        self.currentFrontTarget = [NSNumber numberWithInt:0];
        [self loadCommunityCollectionsUsingUrl:url descending:YES];
    } else {
        self.inCommunityView = NO;
        
        NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"groupName == %@", currentGroupName];
        if ([currentGroupName isEqualToString:@"favorites"]) {
            groupPredicate = [NSPredicate predicateWithFormat:@"isFavorite == %@", @"1"];
        }
        self.currentGroup = [NSMutableArray arrayWithArray:[allCollections filteredArrayUsingPredicate:groupPredicate]];
        if ([currentGroup count] == 0) {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:@"Group has no collections" forKey:NSLocalizedDescriptionKey];
            
            *error = [NSError errorWithDomain:@"preveal" code:9 userInfo:@{NSLocalizedDescriptionKey:@"Group has no collections"} ];
        }
        [currentGroup sortUsingComparator: ^(id obj1, id obj2) {
            int first = [[(Collection*)obj1 order] intValue];
            int second = [[(Collection*)obj2 order] intValue];
            if (first > second) {
                return (NSComparisonResult) NSOrderedDescending;
            }
            
            if (first < second) {
                return (NSComparisonResult) NSOrderedAscending;
            }
            return (NSComparisonResult) NSOrderedSame;
        }];
    }
}

#pragma mark - NSURLConnection Delegate


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == currentConnection) {
        [collectionsData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection != currentConnection) {
        return;
    }
    self.currentConnection = nil;
    NSError *error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:collectionsData options:kNilOptions error:&error];
    if (error != nil) {
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to communicate with Preveal Community server" forKey:NSLocalizedDescriptionKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPrevealCollectionsDownloadError
                                                            object:self
                                                          userInfo:errorDetails];
        return;
    }
    
    if ([json objectForKey:@"rows"] != nil) {
        NSMutableArray *newSet =  [[NSMutableArray alloc] init];
        self.totalNumberOfRowsInCommunityView = [NSNumber numberWithInteger:[[json objectForKey:@"total_rows"] integerValue]];
        if (focusOnFrontOfStack) {
            self.currentFirstRowLoaded = [NSNumber numberWithInt:[currentFirstRowLoaded intValue] - kPrevealCommunityRecordsPerRequest];
//            NSLog(@"Finished downloading  %@ through: %ud", currentFirstRowLoaded, [currentFirstRowLoaded intValue] + kPrevealCommunityRecordsPerRequest);

        } else {
            self.currentLastRowLoaded = [NSNumber numberWithInt:[currentLastRowLoaded intValue]+kPrevealCommunityRecordsPerRequest];
//            NSLog(@"Finished downloading through: %@", currentLastRowLoaded);

        }
        self.inCommunityView = YES;
        NSArray *rows =  (NSArray *)[json objectForKey:@"rows"];
        NSDictionary *row;
        Collection *collection;
        
        NSUInteger count = [rows count];
        for (int i=0; i<count; i++) {
            row = [[rows objectAtIndex:i] objectForKey:@"value"];
            //NSLog(@"%@", row);
            @try {
                collection = [[Collection alloc] init];
                [collection loadFromDictionary:row];
                [newSet addObject:collection];
            }
            @catch (NSException *exception) {
                // Generally speaking this is a pretty bad idea. But user experience over good ideas.
                NSLog(@"%@", exception);
            }
        }
        if (focusOnFrontOfStack) {
            [newSet addObjectsFromArray:currentGroup];
            self.currentGroup = newSet;
        } else {
            [self.currentGroup addObjectsFromArray:newSet];
        }
    }
    /*
     intentionally leaving this here. It filters out templates you already have loaded.

    NSPredicate *alreadyHaveItPredicate = [NSPredicate predicateWithBlock:^BOOL (id evaluatedObject, NSDictionary *bindings) {
        Collection *incomingCollection = (Collection *) evaluatedObject;
        NSPredicate *filenamePredicate = [NSPredicate predicateWithFormat:@"file_name == %@", incomingCollection.file_name];
        NSArray *array = [allCollections filteredArrayUsingPredicate:filenamePredicate];
        return [array count] == 0;
    }];
    self.currentGroup = [NSMutableArray arrayWithArray:[currentGroup filteredArrayUsingPredicate:alreadyHaveItPredicate]];
     */
    self.currentlyDownloading = NO;
    if (focusOnFrontOfStack) {
        if ([currentFrontTarget compare:currentFirstRowLoaded] == NSOrderedAscending) {
            [self loadCommunityCollectionsUsingUrl:currentBaseUrl descending:currentlyDescending];
        }
    } else {
        if ([currentEndTarget compare:currentLastRowLoaded] == NSOrderedDescending) {
         
            [self loadCommunityCollectionsUsingUrl:currentBaseUrl descending:currentlyDescending];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPrevealCollectionsDownloadDone
                                                        object:self];    
}



    
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection != currentConnection) {
        return;
    }
    NSLog(@"%@", [error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kPrevealCollectionsDownloadError
                                                        object:error];
    
}



+ (void) permanentlyDeleteCollectionWithFileName: (NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[Collections getUserCollectionsDirectory] stringByAppendingPathComponent:fileName];
    NSLog(@"Actually Deleting%@", filePath);
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (!success) {
        NSLog(@"%@", filePath);
        NSLog(@"%@", error.localizedDescription);
        UIAlertView *removeFailed=[[UIAlertView alloc]initWithTitle:@"Error:" message:@"Failed removing collection." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeFailed show];
    }
    
}

@end
