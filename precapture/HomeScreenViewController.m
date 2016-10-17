//
//  ViewController.m
//  precapture
//
//  Created by Randy Crafton on 3/9/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "SetRoomImageViewController.h"


@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

@synthesize helpButton;



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    NSString *seenCommunityWelcome = [[NSUserDefaults standardUserDefaults] objectForKey:@"seenCommunityWelcome"];
//    if (seenCommunityWelcome == nil || YES) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"seenCommunityWelcome"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self performSegueWithIdentifier:@"HomeCommunityWelcomeSeque" sender:self];
//    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSString *firstLaunchKey = @"AppHasBeenLaunched";
    BOOL firstLaunch = ![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunchKey];
    if (firstLaunch) {
        UIStoryboard *launchSB = [UIStoryboard storyboardWithName:@"LaunchStoryBoard" bundle:[NSBundle mainBundle]];
        UINavigationController *nc = [launchSB instantiateViewControllerWithIdentifier:@"LaunchNavController"];
        [nc setNavigationBarHidden:YES];
        [self presentViewController:nc animated:YES completion:nil];
        
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
//
    // Hackity hack hack. Forces the orientation stuff to run on the top view by popping and readding it to the view stack
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIView *view = [window.subviews objectAtIndex:0];
        [view removeFromSuperview];
        [window addSubview:view];
    }
    
    
    [self clearDropboxCache];
}

- (void) clearDropboxCache
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbCacheDir = [documentsDirectory stringByAppendingPathComponent:@"DropboxCache"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbCacheDir] == YES) {
        NSError *error = nil;
        
        if ([[NSFileManager defaultManager] removeItemAtPath:dbCacheDir error:&error] == NO) {
            NSLog(@"Failed clearing dropbox cache");
            NSLog(@"%@", [error localizedDescription]);
            NSLog(@"%@", [error localizedFailureReason]);
        }
        
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dbCacheDir
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
        if (error != nil) {
            NSLog(@"Error creating cache directory");
            NSLog(@"Error description-%@ \n", [error localizedDescription]);
            NSLog(@"Error reason-%@", [error localizedFailureReason]);
        }
    } 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark - MFMailComposeViewControllerDelegate
- (IBAction)requestATemplateButtonTouched:(id)sender
{
    MFMailComposeViewController *emailView;
    if ([MFMailComposeViewController canSendMail]) {
        emailView = [[MFMailComposeViewController alloc] init];
        [emailView setSubject:@"New Template Request"];
        emailView.mailComposeDelegate = self;
        [emailView setToRecipients:[NSArray arrayWithObject:@"templaterequests@getpreveal.com"]];
        [emailView setMessageBody:@"Please specify the size and placement of each image in your template." 
                           isHTML:YES];

        [self presentViewController:emailView animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Not Configured" 
                                                        message:@"This iPad is not configured to send email." 
                                                       delegate:nil 
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeErrorCodeSendFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Sending Mail" 
                                                        message:@"There was a problem delivering your message. Please try again." 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"Ok", nil];
        [alert show];   
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}




@end
