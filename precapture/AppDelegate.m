//
//  AppDelegate.m
//  precapture
//
//  Created by Randy Crafton on 3/9/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "AppDelegate.h"
#import "CollectionInstallationManager.h"
#import "VersionManager.h"
//#import <Dropbox/Dropbox.h>
#import "InAppPurchaseController.h"
//#import <NUI/NUISettings.h>
#import "HamburglerMenuViewController.h"
#import "LoginManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <HockeySDK/HockeySDK.h>
#import "LoginManager.h"
#import "PrevealUser.h"
#import "HomeScreenViewController.h"

#import <Smooch/Smooch.h>

@implementation AppDelegate

@synthesize window = _window;


-(NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  return (NSUInteger)[application supportedInterfaceOrientationsForWindow:window] | UIInterfaceOrientationMaskLandscape;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Push Notification Setting
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //Setting Info for Smooch Conversation
    [self setInfoForSmoochConversation];
    
//    [Smooch show];
    
//    [NUISettings initWithStylesheet:@"PrevealStyle"];
    [[LoginManager sharedInstance] loadUserDocument];
    [VersionManager performUpdates];
    
    //Dropbox
//    DBAccountManager *accountManager = [[DBAccountManager alloc] initWithAppKey:@"0umw9jyg5z0npuc" secret:@"nplqy3e363ztvvq"];
//    [DBAccountManager setSharedManager:accountManager];
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:@"0umw9jyg5z0npuc" appSecret:@"nplqy3e363ztvvq" root:kDBRootAppFolder];
    [DBSession setSharedSession:dbSession];

    //In app purchase controller for preveal community
    InAppPurchaseController *inAppStore = [InAppPurchaseController sharedInstance];
    if (inAppStore.purchasesAllowed && inAppStore.purchasesAvailable) {
        [inAppStore requestAllProductData];
    }
    [FBSDKSettings setAppID:@"1635062913446993"];
    [FBSDKAppEvents activateApp];

    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"9ec849ad298e45d38f0294ac93b8c7ae"];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
//    [[BITHockeyManager sharedHockeyManager].authenticator
//     authenticateInstallation];
    
    
    NSString *firstLaunchKey = @"AppHasBeenLaunched";
    BOOL firstLaunch = ![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunchKey];
    if (firstLaunch) {
        UIStoryboard *launchSB = [UIStoryboard storyboardWithName:@"LaunchStoryBoard" bundle:nil];
        UINavigationController *nc = [launchSB instantiateViewControllerWithIdentifier:@"LaunchNavController"];
        [nc setNavigationBarHidden:YES];
//        [self presentViewController:nc animated:YES completion:nil];
        
//        HomeScreenViewController *homeVC = [[HomeScreenViewController alloc] init];
        
        self.window.rootViewController = nc;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Did Receive Remote Notification");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"----%@", userInfo);
    if (userInfo[@"aps"]) {
        NSDictionary *notificationDic = [[NSDictionary alloc] init];
        notificationDic = userInfo[@"aps"];
        
        if (notificationDic[@"badge"]) {
            [[NSUserDefaults standardUserDefaults] setObject:notificationDic[@"badge"] forKey:BADGE_NUMBER];
            NSLog(@"Notification Badge Number: %@", notificationDic[@"badge"]);
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = [notificationDic[@"badge"] integerValue];
        }
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
//    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
//    if (account) {
//        NSLog(@"App linked successfully to dropbox");
//        return YES;
//    }
    
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully to dropbox!");
            // At this point you can start making API calls
        }
        return YES;
    }
    
    return NO;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setInfoForSmoochConversation {
    [Smooch initWithSettings: [SKTSettings settingsWithAppToken:SMOOCH_TOKEN]];
    
    
    if ([[LoginManager sharedInstance] getSavedUserName]) {
        [[SKTUser currentUser] setEmail:[[LoginManager sharedInstance] getSavedUserName]];
        
        SKTSettings *setting = [SKTSettings settingsWithAppToken:SMOOCH_TOKEN];
        [setting setUserId:[[LoginManager sharedInstance] getSavedUserName]];
        [Smooch initWithSettings:setting];
        
//        PrevealUser *myPreveal = [[LoginManager sharedInstance] user];
        NSString *displayName = [[NSUserDefaults standardUserDefaults] objectForKey:DISPLAY_NAME];
        if (displayName) {
            [[SKTUser currentUser] setFirstName:[self getFirstNameWithFullName:displayName]];
            [[SKTUser currentUser] setLastName:[self getLastNameWithFullName:displayName]];
        }
    }
}

- (NSString *)getFirstNameWithFullName: (NSString *)fullName {
    NSArray *names = [fullName componentsSeparatedByString:@" "];
    for (NSString *subStr in names) {
        if ([subStr checkText]) {
            return subStr;
        }
    }
    return @"";
}

- (NSString *)getLastNameWithFullName: (NSString *)fullName {
    NSArray *names = [fullName componentsSeparatedByString:@" "];
    for (NSInteger i = names.count - 1; i >= 0; i--) {
        NSString *subStr = names[i];
        if ([subStr checkText]) {
            return subStr;
        }
    }
    return @"";
}

@end
