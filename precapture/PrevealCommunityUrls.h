//
//  PrevealCommunityUrls.h
//  precapture
//
//  Created by Randy Crafton on 4/1/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPrevealCommunityAPIKey @"hersetiretwoushoossiongd"
#define kPrevealCommunityAPIPass @"JxOBU1JoHahOebjgY6clEp5R"
#define kPrevealURLCredentials kPrevealCommunityAPIKey @":" kPrevealCommunityAPIPass @"@"
#define kPrevealCommunityBaseUrl kPrevealURLCredentials @"communitydb.getpreveal.com"
#define kPrevealCommunityDbPath @"/preveal"
#define kPrevealViewAllPath @"/_design/preveal_app/_view/byDateCreated"
#define kPrevealMostPopularPath @"/_design/preveal_app/_view/byNumberOfDownloads"
#define kPrevealSortBySizePath @"/_design/preveal_app/_view/byDimensions"
#define kPrevealSortByNumberOfOpenings @"/_design/preveal_app/_view/byNumberOfOpenings"
#define kPrevealViewMyAccountPath @"/preveal"
#define kPrevealDownloadedDocumentPath @"/_design/preveal_app/_update/downloadedDocument"
#define kPrevealFlagDocumentPath @"/_design/preveal_app/_update/flagDocumentWithReason"

@interface PrevealCommunityUrls : NSObject


+ (NSURL *) getNewUserUrl;
+ (NSURL *) getSaveDocumentUrl;
- (NSURL *) getPrevealDocumentsUrl;
- (NSURL *) getMostPopularUrl;
- (NSURL *) getSortBySizeUrl;
- (NSURL *) getSortByNumberOfOpeningsUrl;
- (NSURL *) getCheckMyAccountUrlWithEmail: (NSString *)email;
+ (NSURL *) getDownloadedDocumentPathForDocumentWithId: (NSString *)documentId;
+ (NSURL *) getFlagDocumentPathForDocumentWithId: (NSString *)documentId userName: (NSString *)userName andReason: (NSString *)reason;
+ (NSString *) getUrlEncodedUserString: (NSString *)nsString;
+ (BOOL) canUseCommunity;

@end
