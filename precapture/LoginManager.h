//
//  LoginManager.h
//  precapture
//
//  Created by Randy Crafton on 6/3/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kPrevealUserDocumentDownloadError @"kPrevealUserDocumentDownloadError"
#define kPrevealUserDocumentDownloadDone @"kPrevealUserDocumentDownloadDone"


@class PrevealUser;

@interface LoginManager : NSObject <NSURLConnectionDelegate> {
    PrevealUser *user;
    BOOL authorized;
    NSMutableData *userData;
}

@property (nonatomic, retain) PrevealUser *user;
@property (nonatomic, retain) NSMutableData *userData;
@property (nonatomic, assign) BOOL authorized;

+ (LoginManager *)sharedInstance;
- (BOOL) isAuthorized;

- (NSString *) getSavedUserName;
- (NSString *) getSavedPassword;
- (NSString *) getSalt;
- (NSString *) getAutoPassword;

- (BOOL) password: (NSString *) password withSalt: (NSString *)salt matchesHashedPassword: (NSString *) hashedPassword;
- (NSString *) getHashedPassword: (NSString *) password withSalt: (NSString *) salt;
- (void) loadUserDocumentForUser: (NSString *)userName;
- (void) loadUserDocument;

@end
