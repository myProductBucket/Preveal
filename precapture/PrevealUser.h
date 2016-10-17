//
//  PrevealUser.h
//  precapture
//
//  Created by Randy Crafton on 6/3/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrevealUser : NSObject
{
    NSString *_id;
    NSString *_rev;
    NSString *email;
    NSString *displayName;
    NSString *salt;
    NSString *hashedPassword;
    NSString *password;
    NSString *studioURL;
    NSString *studioName;
}
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *_rev;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *salt;
@property (nonatomic, retain) NSString *hashedPassword;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *studioURL;
@property (nonatomic, retain) NSString *studioName;

@end
