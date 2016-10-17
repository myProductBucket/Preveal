//
//  WelcomeViewController.m
//  precapture
//
//  Created by Randy Crafton on 4/7/15.
//  Copyright (c) 2015 JSA Technologies. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginManager.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize smoochMessageButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)smoochMessageButtonTouchUp:(MIBadgeButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}

#pragma mark -
- (void)setBadgeNumber {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] && [[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] != 0) {
            [smoochMessageButton setBadgeBackgroundColor:[UIColor redColor]];
            [smoochMessageButton setBadgeTextColor:[UIColor whiteColor]];
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] || [[[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] integerValue] == 0) {
                [smoochMessageButton setBadgeString:nil];
            }else{
                [smoochMessageButton setBadgeString:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER]]];
            }
        }
    });
}

@end
