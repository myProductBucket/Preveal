//
//  CommunityPasswordResetViewController.m
//  precapture
//
//  Created by Randy Crafton on 4/6/15.
//  Copyright (c) 2015 JSA Technologies. All rights reserved.
//

#import "CommunityPasswordResetViewController.h"
#import "PrevealCommunityUrls.h"
#import "LoginManager.h"
#import "PrevealUser.h"
#import "SCSlidingViewController.h"

@interface CommunityPasswordResetViewController () {
    NSString *salt;
    NSString *hashedPassword;
    NSString *_rev;
}

@end


@implementation CommunityPasswordResetViewController

@synthesize messageLabel, confirmPasswordField, errorLabel, passwordField, currentPasswordField;
@synthesize fadedView, activityView;
@synthesize smoochMessageButton;


- (IBAction)sendResetCode:(id)sender
{
    
    
}

- (IBAction)resetPassword:(id)sender
{
    if (![self checkTextFields]) {//If No, it means there is empty field.
        return;
    }
    
    NSString *currentPwd = [[LoginManager sharedInstance] getSavedPassword];
    if (![currentPwd isEqualToString:currentPasswordField.text]) {
        [errorLabel setText:@"Invalid Current Password! Please try again!"];
        [errorLabel setHidden:NO];
        [currentPasswordField setText:@""];
        return;
    }
    
    if (![passwordField.text isEqualToString:confirmPasswordField.text]) {
        [errorLabel setText:@"Confirm New Password is incorrect!"];
        [errorLabel setHidden:NO];
        [confirmPasswordField setText:@""];
        return;
    }
    
    [errorLabel setText:@""];
    [errorLabel setHidden:YES];
    
    self.fadedView.hidden = NO;
    [self.activityView startAnimating];
    
    LoginManager *lm = [LoginManager sharedInstance];
    salt = [lm getSalt];
    hashedPassword = [lm getHashedPassword:passwordField.text withSalt:salt];
    
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [values setObject:[lm getSavedUserName] forKey:@"_id"];
    [values setObject:[lm getSavedUserName] forKey:@"name"];
    [values setObject:[lm.user _rev] forKey:@"_rev"];
    [values setObject:salt forKey:@"salt"];
    [values setObject:hashedPassword forKey:@"hashedPassword"];
    [values setObject:[[NSUserDefaults standardUserDefaults] objectForKey:DISPLAY_NAME] forKey:@"displayName"];
    [values setObject:[[NSUserDefaults standardUserDefaults] objectForKey:STUDIO_NAME] forKey:@"studioName"];
    [values setObject:[[NSUserDefaults standardUserDefaults] objectForKey:STUDIO_URL] forKey:@"studioUrl"];
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

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activityView stopAnimating];
    self.fadedView.hidden = YES;
    
    NSError *error = nil;
    NSDictionary *jsonObject  = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:&error];
    if ([jsonObject objectForKey:@"ok"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"The new password was just reset"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
        [alert show];
        
//        if (self.inLaunchView == NO) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//        if (self.nextButton != nil) {
//            self.nextButton.hidden = NO;
//        }
        
        _rev = [jsonObject objectForKey:@"rev"];
        
        [self saveUpdatedData];
        
    } else {
        if ([[jsonObject objectForKey:@"error"] isEqualToString:@"conflict"]) {
            self.errorLabel.text = @"Email address already registered.";
        } else {
            self.errorLabel.text = [NSString stringWithFormat:@"%@: %@", [jsonObject objectForKey:@"error"], [jsonObject objectForKey:@"reason"]];
        }
        [self.errorLabel setHidden:NO];
    }
    
}

- (void)saveUpdatedData {
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:COMMUNITY_PASSWORD];
    LoginManager *lm = [LoginManager sharedInstance];
    [lm user].salt = salt;
    [lm user].hashedPassword = hashedPassword;
    [lm user]._rev = _rev;
}


#pragma mark - check text field

- (BOOL)checkTextFields {
    if ([currentPasswordField.text isEqualToString:@""]) {
        [errorLabel setText:@"Please input the current password!"];
        return NO;
    }
    if ([passwordField.text isEqualToString:@""]) {
        [errorLabel setText:@"Please input the new password!"];
        return NO;
    }
    if ([confirmPasswordField.text isEqualToString:@""]) {
        [errorLabel setText:@"Please input the confirm new password!"];
        return NO;
    }
    return YES;
}


@end
