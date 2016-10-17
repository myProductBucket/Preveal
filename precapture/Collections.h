//
//  Collections.h
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPrevealCollectionsDownloadStarting @"kPrevealCollectionsDownloadStarting"
#define kPrevealCollectionsDownloadDone @"kPrevealCollectionsDownloadDone"
#define kPrevealCollectionsDownloadTimedOut @"kPrevealCollectionsDownloadTimedOut"
#define kPrevealCollectionsDownloadError @"kPrevealCollectionsDownloadError"

#define kPrevealMyCollectionsGroupName @"myCreatedGroups"
#define kPrevealCommunityGroupName @"toTheCloud"
#define kPrevealDA1Name @"com.chrisandadriennescott.preveal.dacollectiononenew"
#define kDesignAglowInspireGuideBundle @"com.chrisandadriennescott.preveal.inspireguide.canvas"

#define kPrevealCommunityRecordsPerRequest 50

@class Collection;

@interface Collections : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableArray *currentGroup;
@property (nonatomic, retain) NSArray *forPurchase;
@property (nonatomic, retain) NSMutableArray *allCollections;
@property (nonatomic, retain) NSURL *currentCommunityUrl;
@property (nonatomic, retain) NSMutableData *collectionsData;
@property (nonatomic, assign) BOOL inCommunityView;
@property (nonatomic, retain) NSNumber *totalNumberOfRowsInCommunityView;
@property (nonatomic, retain) NSNumber *currentLastRowLoaded;
@property (nonatomic, retain) NSNumber *currentFirstRowLoaded;
@property (nonatomic, retain) NSNumber *currentEndTarget;
@property (nonatomic, retain) NSNumber *currentFrontTarget;
@property (nonatomic, assign) BOOL focusOnFrontOfStack;
@property (nonatomic, assign) BOOL currentlyDownloading;

@property (nonatomic, retain) NSURL *currentBaseUrl;
@property (nonatomic, assign) BOOL currentlyDescending;
@property (nonatomic, retain) NSURLConnection *currentConnection;

- (void)loadCollectionsFromUserDocuments;
- (void)filterAvailable;
- (void)scaleAllAvailable;
- (void)setCurrentGroupName: (NSString *) currentGroupName error:(NSError **)error;
+ (NSString *) getUserCollectionsDirectory;
+ (Collection *) loadCollectionFromFileNamed:(NSString *)fileName;
- (void) updateCollection: (Collection *)newCollection;
- (void) loadCommunityCollectionsUsingUrl:(NSURL *) url descending:(BOOL)isDescending;
- (void) incrementEndTarget: (NSInteger)target;
- (void) decrementFrontTarget: (NSInteger)target;
- (void) trimCommunityArray;
+ (void) permanentlyDeleteCollectionWithFileName: (NSString *) fileName;

@end
