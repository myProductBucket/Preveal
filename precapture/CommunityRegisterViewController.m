//
//  CommunityRegisterViewController.m
//  precapture
//
//  Created by Randy Crafton on 3/24/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "CommunityRegisterViewController.h"
#import "KeyboardToolbarHelper.h"
#import "PrevealCommunityUrls.h"
#import "LoginManager.h"
#import "PrevealBaseViewController.h"
#import "SCSlidingViewController.h"

@interface CommunityRegisterViewController ()

@end

@implementation CommunityRegisterViewController

@synthesize emailField, passwordField, confirmPasswordField, nameField, studioNameField, studioUrlField, errorLabel;
@synthesize originalCenter, activityView, fadedView, inLaunchView, nextButton;
@synthesize smoochMessageButton;

- (void)viewDidLoad
{
    inLaunchView = NO;
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backTouchUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(id)sender
{
    if (![self NSStringIsValidEmail:emailField.text] || [emailField isEqual:@""]) {
        errorLabel.text = @"You must enter a valid email address to continue";
        return;
    }
    if (![passwordField.text isEqualToString:confirmPasswordField.text]) {
        errorLabel.text = @"Passwords do not match!";
        return;
    }
    fadedView.hidden = NO;
    [activityView startAnimating];
    
    
    LoginManager *lm = [LoginManager sharedInstance];
    NSString *salt = [lm getSalt];
    NSString *hashedPassword = [lm getHashedPassword:passwordField.text withSalt:salt];
    
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [values setObject:[NSString stringWithFormat:@"%@", emailField.text] forKey:@"_id"];
    [values setObject:[NSString stringWithFormat:@"%@", emailField.text] forKey:@"name"];
    [values setObject:salt forKey:@"salt"];
    [values setObject:hashedPassword forKey:@"hashedPassword"];
    [values setObject:[NSString stringWithFormat:@"%@", nameField.text ] forKey:@"displayName"];
    [values setObject:[NSString stringWithFormat:@"%@", studioNameField.text] forKey:@"studioName"];
    [values setObject:[NSString stringWithFormat:@"%@", studioUrlField.text] forKey:@"studioUrl"];
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

- (IBAction)submitButtonPressedFromLaunchView:(id)sender
{
    self.inLaunchView = YES;
    [self submitButtonPressed:sender];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"launchCommunityExit"]) {
        self.inLaunchView = YES;
        [self submitButtonPressed:sender];
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [activityView stopAnimating];
    fadedView.hidden = YES;
    
    NSError *error = nil;
    NSDictionary *jsonObject  = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:&error];
    if ([jsonObject objectForKey:@"ok"]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:emailField.text forKey:COMMUNITY_USERNAME];
        [prefs setObject:passwordField.text forKey:COMMUNITY_PASSWORD];
        [prefs setObject:studioNameField.text forKey:STUDIO_NAME];
        [prefs setObject:studioUrlField.text forKey:STUDIO_URL];
        [prefs setObject:nameField.text forKey:DISPLAY_NAME];
        [prefs synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self getWelcomeTitle]
                                                        message:[self getWelcomeText]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
        [alert show];
        
        if (inLaunchView == NO) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (nextButton != nil) {
            nextButton.hidden = NO;
        }
        
        //--- Smooch Login
        [Smooch login:emailField.text jwt:nil];
        
        AppDelegate *del = [[UIApplication sharedApplication] delegate];
        [del setInfoForSmoochConversation];
        
        //--- send email address to Getdrip as a subscriber
        [self sendEmailToGetdrip:emailField.text];
        ////////////////////////////////////////////////////
        
    } else {
        if ([jsonObject objectForKey:@"error"]) {
            if ([[jsonObject objectForKey:@"error"] isEqualToString:@"conflict"]) {
                self.errorLabel.text = @"Email address already registered.";
            } else {
                self.errorLabel.text = [NSString stringWithFormat:@"%@: %@", [jsonObject objectForKey:@"error"], [jsonObject objectForKey:@"reason"]];
            }
        }
    }

}

- (void)sendEmailToGetdrip: (NSString *)subscriberEmail{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/subscribers", GETDRIPAPI_ENDPOINT, GETDRIP_ACCOUNTID]];
    
    NSMutableDictionary *subscribers = [NSMutableDictionary dictionary];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    [tags addObject:GETDRIP_TAG];
    
    [values addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"email":subscriberEmail, @"tags":tags}]];
//    NSDictionary *values = @{@"email":subscriberEmail};
//    [values setObject:[NSString stringWithFormat:@"%@", subscriberEmail] forKey:@"email"];
    [subscribers setObject:values forKey:@"subscribers"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiToken = [self encodeStringTo64: [NSString stringWithFormat:@"%@:", GETDRIP_APITOKEN]];
    [request setValue:[NSString stringWithFormat:@"Basic %@", apiToken] forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPMethod:@"POST"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subscribers options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSString *)encodeStringTo64: (NSString *)fromString {
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];//iOS 7+
    }else{
        base64String = [plainData base64Encoding];//pre iOS 7
    }
    
    return base64String;
}

#pragma mark -
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)tosButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://getpreveal.com/tos"]];
}

- (IBAction)loginButtonPressed:(id)sender
{
    UIViewController *viewController;
    if (self.nextButton == nil) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityLoginViewController"];
    } else {
        UIStoryboard *launchStoryBoard =  [UIStoryboard storyboardWithName:@"LaunchStoryBoard" bundle:nil];
        viewController = [launchStoryBoard instantiateViewControllerWithIdentifier:@"CommunityLoginViewController"];
    }
    [self.slidingViewController changeTopViewController:viewController];
}

- (NSString *) getWelcomeTitle
{
    return @"Welcome!";
}
- (NSString *) getWelcomeText
{
    return @"You have successfully registered with the preveal community";
}

@end
