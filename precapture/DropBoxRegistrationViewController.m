//
//  DropBoxRegistrationViewController.m
//  precapture
//
//  Created by Randy Crafton on 2/3/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "DropBoxRegistrationViewController.h"
#import "MyDropbox.h"

@interface DropBoxRegistrationViewController ()

@end

@implementation DropBoxRegistrationViewController

@synthesize nextButton, authorizeDropbox, timer;
@synthesize smoochMessageButton;
@synthesize unuseDropboxButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setDropboxButtonStates];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(setDropboxButtonStates) userInfo:nil repeats:YES];
    
    [self setBadgeNumber];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}

- (IBAction)backTouchUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma mark - dropbox
- (void) setDropboxButtonStates
{
    // No account
//    if ([[DBAccountManager sharedManager] linkedAccount] == nil) {
//        self.authorizeDropbox.hidden = NO;
//        self.deauthorizeDropbox.hidden = YES;
//        [self.unuseDropboxButton setHidden:NO];
//    } else {
//        self.authorizeDropbox.hidden = YES;
//        self.deauthorizeDropbox.hidden = NO;
//        [self.unuseDropboxButton setHidden:YES];
//    }
    if ([[DBSession sharedSession] isLinked]) {
        self.authorizeDropbox.hidden = YES;
        self.deauthorizeDropbox.hidden = NO;
        [self.unuseDropboxButton setHidden:YES];
    }else{
        self.authorizeDropbox.hidden = NO;
        self.deauthorizeDropbox.hidden = YES;
        [self.unuseDropboxButton setHidden:NO];
    }
}

- (IBAction)toggleDropboxConnected:(id)sender
{
//    if ([[DBAccountManager sharedManager] linkedAccount] == nil) {
//
//        [[DBAccountManager sharedManager] linkFromController:self];
//    } else {
//        [[[DBAccountManager sharedManager] linkedAccount] unlink];
//        [MyDropbox sharedInstance].dbFilesystem = nil;
//    }
    if ([[DBSession sharedSession] isLinked]) {//
        [[DBSession sharedSession] unlinkAll];
//        [MyDropbox sharedInstance].dbFilesystem = nil;
    }else{
        [[DBSession sharedSession] linkFromController:self];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:DROPBOX_RECONNECT];
    }
    [self setDropboxButtonStates];
}


@end
