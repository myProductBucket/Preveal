//
//  MIBadgeButton.h
//  Elmenus
//
//  Created by Urban Drescher on 2/1/14.
//  Copyright (c) 2014 Mustafa Ibrahim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIBadgeButton : UIButton

@property (nonatomic, strong) NSString *badgeString;
@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic) UIEdgeInsets badgeEdgeInsets;

@end