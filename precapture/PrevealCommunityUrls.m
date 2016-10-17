//
//  PrevealCommunityUrls.m
//  precapture
//
//  Created by Randy Crafton on 4/1/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "PrevealCommunityUrls.h"
#import "LoginManager.h"

@implementation PrevealCommunityUrls

+ (NSURL *) getNewUserUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://preveal_new_users:%@@%@/_users", [PrevealCommunityUrls getNewUserPassword], kPrevealCommunityBaseUrl]];
}

+ (NSURL *) getSaveDocumentUrl
{

    NSString *urlString = [NSString stringWithFormat:@"http://%@/preveal",
                           kPrevealCommunityBaseUrl];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *) getDownloadedDocumentPathForDocumentWithId: (NSString *)documentId
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@%@/%@",
                           kPrevealCommunityBaseUrl,
                           kPrevealCommunityDbPath,
                           kPrevealDownloadedDocumentPath,
                           documentId];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *) getFlagDocumentPathForDocumentWithId: (NSString *)documentId userName: (NSString *)userName andReason: (NSString *)reason
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@%@/%@?userName=%@&reason=%@",
                           kPrevealCommunityBaseUrl,
                           kPrevealCommunityDbPath,
                           kPrevealFlagDocumentPath,
                           documentId,
                           [PrevealCommunityUrls getUrlEncodedUserString:userName],
                           [PrevealCommunityUrls getUrlEncodedUserString:reason]];
    return [NSURL URLWithString:urlString];
}

- (NSURL *) getCheckMyAccountUrlWithEmail: (NSString *)email
{
    NSString *viewPath = [NSString stringWithFormat:@"%@/%@", kPrevealViewMyAccountPath, [PrevealCommunityUrls getUrlEncodedUserName:email]];
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@",
                           kPrevealCommunityBaseUrl,
                           viewPath];
    return [NSURL URLWithString:urlString];
}

- (NSURL *) getPrevealDocumentsUrl
{
    return [self getUrlWithPath:kPrevealViewAllPath];
}

- (NSURL *) getMostPopularUrl
{
    return [self getUrlWithPath:kPrevealMostPopularPath];
}

- (NSURL *) getSortBySizeUrl
{
    return [self getUrlWithPath:kPrevealSortBySizePath];
}

- (NSURL *) getSortByNumberOfOpeningsUrl
{
    return [self getUrlWithPath:kPrevealSortByNumberOfOpenings];
}

- (NSURL *) getUrlWithPath: (NSString *) viewPath
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/preveal%@",
                           kPrevealCommunityBaseUrl,
                           viewPath];
    return [NSURL URLWithString:urlString];
}


+ (NSString *) getUrlEncodedUserName: (NSString *)nsUserName
{
    CFStringRef userName = (__bridge CFStringRef) nsUserName;
    CFStringRef urlEncoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                     userName,
                                                                                     CFSTR(""),
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                     kCFStringEncodingUTF8);
    return (__bridge NSString *)urlEncoded;
}

+ (NSString *) getUrlEncodedUserString: (NSString *)nsString
{
    CFStringRef theString = (__bridge CFStringRef) nsString;
    CFStringRef urlEncoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     theString,
                                                                     CFSTR(""),
                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                     kCFStringEncodingUTF8);
    return (__bridge NSString *)urlEncoded;
}

+ (NSString *) getUrlEncodedPassword: (NSString *)nsPassword
{
    CFStringRef password = (__bridge CFStringRef) nsPassword;
    CFStringRef urlEncoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     password,
                                                                     CFSTR(""),
                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                     kCFStringEncodingUTF8);
    return (__bridge NSString *)urlEncoded;
}


+ (NSString *) getNewUserPassword
{
    return @"5aswaPrusaxuprukuhavE52aK4q7xezu";
}

+ (BOOL) canUseCommunity
{
    return ([[LoginManager sharedInstance] getSavedUserName] != nil && [[LoginManager sharedInstance] getSavedPassword] != nil);
}
@end
