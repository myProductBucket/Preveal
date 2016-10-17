//
//  LoginManager.m
//  precapture
//
//  Created by Randy Crafton on 6/3/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "LoginManager.h"
#import "PrevealCommunityUrls.h"
#import "PrevealUser.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation LoginManager

static LoginManager *sharedInstance = nil;

@synthesize user, authorized, userData;

+ (LoginManager *) sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[LoginManager alloc] init];
        sharedInstance.authorized = NO;
        

    }
    return sharedInstance;
}



- (BOOL) isAuthorized
{
    return authorized;
}

- (NSString *) getSavedUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:COMMUNITY_USERNAME];
    return userName;
}

- (NSString *) getSavedPassword
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaults objectForKey:COMMUNITY_PASSWORD];
    return password;
}

- (void) loadUserDocument
{
    
    [self loadUserDocumentForUser:[self getSavedUserName]];
}

- (void) loadUserDocumentForUser: (NSString *)userName
{
    self.userData = [[NSMutableData alloc] init];
    
    PrevealCommunityUrls *urls = [[PrevealCommunityUrls alloc] init];
    NSURL *userDocUrl = [urls getCheckMyAccountUrlWithEmail:userName];

    NSURLRequest *request = [NSURLRequest requestWithURL:userDocUrl];
    [NSURLConnection connectionWithRequest:request delegate:self];

}


#pragma mark -
#pragma mark hashing

- (BOOL) password: (NSString *) password withSalt: (NSString *)salt matchesHashedPassword: (NSString *) hashedPassword
{
    NSString *freshlyHashed = [self getHashedPassword: password withSalt: salt];
    return [freshlyHashed isEqualToString:hashedPassword];
}

- (NSString *) getHashedPassword: (NSString *) password withSalt: (NSString *) salt
{
    NSString *str = [NSString stringWithFormat:@"%@:%@", password, salt];
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}



- (NSString *) getSalt
{
    int len = 10;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

- (NSString *) getAutoPassword
{
    int len = 5;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate jazz

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [userData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:userData options:kNilOptions error:&error];

    if (error != nil || [json objectForKey:@"error"]) {
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to communicate with Preveal Community server" forKey:NSLocalizedDescriptionKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPrevealUserDocumentDownloadError
                                                            object:self
                                                          userInfo:errorDetails];
        return;
    }
    if ([json objectForKey:@"_id"] != nil) {
        self.user = [[PrevealUser alloc] init];

        user._id = [json objectForKey:@"_id"];
        user._rev = [json objectForKey:@"_rev"];
        user.displayName = [json objectForKey:@"displayName"];
        user.studioName = [json objectForKey:@"studioName"];
        user.studioURL = [json objectForKey:@"studioUrl"];
        user.hashedPassword = [json objectForKey:@"hashedPassword"];
        user.salt = [json objectForKey:@"salt"];
        self.authorized = YES;        
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kPrevealUserDocumentDownloadDone
                                                        object:self];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kPrevealUserDocumentDownloadError
                                                        object:error];
}


@end
