//
//  CommunityEditDetailsViewController.m
//  precapture
//
//  Created by Randy Crafton on 4/5/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "CommunityEditDetailsViewController.h"
#import "CommunityRegisterViewController.h"
#import "LoginManager.h"
#import "PrevealCommunityUrls.h"
#import "PrevealUser.h"
#import "SCSlidingViewController.h"


@interface CommunityEditDetailsViewController ()

@end

@implementation CommunityEditDetailsViewController

@synthesize smoochMessageButton;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[LoginManager sharedInstance] loadUserDocument];
//    PrevealUser *user = [[LoginManager sharedInstance] user];
    self.emailField.text = [[LoginManager sharedInstance] getSavedUserName];
    self.nameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:DISPLAY_NAME];
    self.studioNameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:STUDIO_NAME];
    self.studioUrlField.text = [[NSUserDefaults standardUserDefaults] objectForKey:STUDIO_URL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
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

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}

- (IBAction)submitButtonPressed:(id)sender
{
    if (![self NSStringIsValidEmail:self.emailField.text] || [self.emailField isEqual:@""]) {
        self.errorLabel.text = @"You must enter a valid email address to continue";
        return;
    }

    self.fadedView.hidden = NO;
    [self.activityView startAnimating];
    
    LoginManager *lm = [LoginManager sharedInstance];
    
    

    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [values setObject:[NSString stringWithFormat:@"%@", [lm getSavedUserName]] forKey:@"_id"];
    [values setObject:[NSString stringWithFormat:@"%@", [lm getSavedUserName]] forKey:@"name"];
    [values setObject:[lm.user _rev] forKey:@"_rev"];
    [values setObject:lm.user.salt forKey:@"salt"];
    [values setObject:lm.user.hashedPassword forKey:@"hashedPassword"];
    [values setObject:[NSString stringWithFormat:@"%@", self.nameField.text ] forKey:@"displayName"];
    [values setObject:[NSString stringWithFormat:@"%@", self.studioNameField.text] forKey:@"studioName"];
    [values setObject:[NSString stringWithFormat:@"%@", self.studioUrlField.text] forKey:@"studioUrl"];
    [values setObject:@"user" forKey:@"type"];
    [values setValue:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:@"createdAt"];
    NSArray *roles = [NSArray arrayWithObject:@"prevealAppUser"];
    [values setObject:roles forKey:@"roles"];
    
    
    NSURL *url = [PrevealCommunityUrls getSaveDocumentUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:values
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [request setHTTPBody: jsonData];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (IBAction)resetPasswordTouchUp:(UIButton *)sender {
    UIViewController *viewController;
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityPasswordResetViewController"];
    
    [self.slidingViewController changeTopViewController:viewController];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activityView stopAnimating];
    self.fadedView.hidden = YES;
    
    NSError *error = nil;
    NSDictionary *jsonObject  = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:&error];
    if ([jsonObject objectForKey:@"ok"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self getWelcomeTitle]
                                                        message:[self getWelcomeText]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
        [alert show];
        
        if (self.inLaunchView == NO) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (self.nextButton != nil) {
            self.nextButton.hidden = NO;
        }
        
        [self saveUpdatedData];
        
    } else {
        if ([[jsonObject objectForKey:@"error"] isEqualToString:@"conflict"]) {
            self.errorLabel.text = @"Email address already registered.";
        } else {
            self.errorLabel.text = [NSString stringWithFormat:@"%@: %@", [jsonObject objectForKey:@"error"], [jsonObject objectForKey:@"reason"]];
        }
        
    }
    
}

- (void)saveUpdatedData {
    LoginManager *lm = [LoginManager sharedInstance];
    [lm user].displayName = self.nameField.text;
    [lm user].studioName = self.studioNameField.text;
    [lm user].studioURL = self.studioUrlField.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:DISPLAY_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:self.studioNameField.text forKey:STUDIO_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:self.studioUrlField.text forKey:STUDIO_URL];
}

- (NSString *) getWelcomeTitle
{
    return @"Updated.";
}
- (NSString *) getWelcomeText
{
    return @"You have successfully updated your profile for the preveal community";
}


@end
