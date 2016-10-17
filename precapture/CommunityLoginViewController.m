//
//  CommunityLoginViewController.m
//  precapture
//
//  Created by Randy Crafton on 4/20/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "CommunityLoginViewController.h"
#import "PrevealCommunityUrls.h"
#import "LoginManager.h"
#import "PrevealUser.h"
#import "SCSlidingViewController.h"
#import "CommunityRegisterViewController.h"

@interface CommunityLoginViewController ()

@end

@implementation CommunityLoginViewController

@synthesize passwordField, emailField, fadedView, activityView, errorLabel, nextButton, successLabel;
@synthesize smoochMessageButton;
@synthesize forgotPasswordButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RESET_EMAIL]) {
        [emailField setText:[[NSUserDefaults standardUserDefaults] objectForKey:RESET_EMAIL]];
    }
}

- (void) addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDocumentDownloadDoneNotification:)
                                                 name:kPrevealUserDocumentDownloadDone
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDocumentDownloadErroredNotification:)
                                                 name:kPrevealUserDocumentDownloadError
                                               object:nil];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPrevealUserDocumentDownloadError object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPrevealUserDocumentDownloadDone object:nil];
}
- (IBAction)submitButtonPressed:(id)sender
{
    if (![self NSStringIsValidEmail:emailField.text] || [emailField.text isEqual:@""]) {
        errorLabel.text = @"You must enter a valid email address to continue";
        errorLabel.hidden = NO;
        return;
    }
    errorLabel.text = @"";
    errorLabel.hidden = YES;

    fadedView.hidden = NO;
    [activityView startAnimating];

    [self addObservers];
    [[LoginManager sharedInstance] loadUserDocumentForUser:emailField.text];  
}

- (IBAction)backTouchUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createAccountTouchUp:(UIButton *)sender {
    if ([self.restorationIdentifier isEqualToString:@"CommunityLoginViewController_Main"]) {
        
        CommunityRegisterViewController *viewController;
        
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityRegisterViewController"];
        
        [self.slidingViewController changeTopViewController:viewController forceReload:YES];
    }
}

- (IBAction)forgotPasswordTouchUp:(UIButton *)sender {
    if (self.nextButton == NULL) {
        UIViewController *viewController;
        
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityForgotPasswordViewController"];
        
        [self.slidingViewController changeTopViewController:viewController];
    }else{
        UIViewController *viewController;
        
        UIStoryboard *launchStoryboard = [UIStoryboard storyboardWithName:@"LaunchStoryBoard" bundle:nil];
        viewController = [launchStoryboard instantiateViewControllerWithIdentifier:@"CommunityForgotPasswordViewController"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (IBAction)cancelButtonPressed:(id)sender
{
    [self removeObservers];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}

#pragma mark Observer methods

- (void) receiveDocumentDownloadDoneNotification: (NSNotification *) notification
{
    LoginManager *lm = [LoginManager sharedInstance];
    
    if (lm.user != nil &&
        [lm password:passwordField.text withSalt:lm.user.salt matchesHashedPassword:lm.user.hashedPassword]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:emailField.text forKey:COMMUNITY_USERNAME];
        [prefs setObject:passwordField.text forKey:COMMUNITY_PASSWORD];
        [prefs setObject:lm.user.studioURL forKey:STUDIO_URL];
        [prefs setObject:lm.user.studioName forKey:STUDIO_NAME];
        [prefs setObject:lm.user.displayName forKey:DISPLAY_NAME];
        [prefs synchronize];
        [self removeObservers];
        
        self.fadedView.hidden = YES;
        [self.activityView stopAnimating];
        if (self.nextButton == nil) {
            UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityEditDetailsViewController"];
            [self.slidingViewController setTopViewController:newViewController];

        } else {
            self.nextButton.hidden = NO;
            self.successLabel.hidden = NO;
            [forgotPasswordButton setHidden:YES];
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RESET_EMAIL];
        
        //login Smooch
        [Smooch login:[lm getSavedUserName] jwt:nil];
        
        AppDelegate *del = [[UIApplication sharedApplication] delegate];
        [del setInfoForSmoochConversation];
    } else {
        self.errorLabel.text = @"Invalid credentials. Please verify your email address and password.";
        errorLabel.hidden = NO;
        [activityView stopAnimating];
        fadedView.hidden = YES;
    }
}

- (void) receiveDocumentDownloadErroredNotification: (NSNotification *) notification
{
    self.errorLabel.text = @"Invalid credentials. Please verify your email address and password.";
    [activityView stopAnimating];
    fadedView.hidden = YES;
}



@end
