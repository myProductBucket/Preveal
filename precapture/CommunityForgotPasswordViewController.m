//
//  CommunityForgotPasswordViewController.m
//  precapture
//
//  Created by Urban Drescher on 3/25/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import "CommunityForgotPasswordViewController.h"
#import "PrevealCommunityUrls.h"
#import "LoginManager.h"
#import "PrevealUser.h"
#import "SCSlidingViewController.h"
#import "CommunityLoginViewController.h"

@interface CommunityForgotPasswordViewController() {
    NSString *autoPassword;
    NSString *salt;
    NSString *hashedPassword;
    NSString *_rev;
}

@end

@implementation CommunityForgotPasswordViewController

@synthesize errorLabel, descriptionLabel, smoochMessageButton, emailTextField;
@synthesize activityView, fadedView;
@synthesize stateLabel;

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

#pragma mark - Custom Event

- (IBAction)sendTouchUp:(UIButton *)sender {
    
    if (![self NSStringIsValidEmail:emailTextField.text] || [emailTextField.text isEqual:@""]) {
        errorLabel.text = @"You must enter a valid email address to continue";
        errorLabel.hidden = NO;
        return;
    }
    errorLabel.text = @"";
    errorLabel.hidden = YES;
    stateLabel.text = @"";
    stateLabel.hidden = YES;
    
    fadedView.hidden = NO;
    [activityView startAnimating];

    
    [self addObservers];
    
    [[LoginManager sharedInstance] loadUserDocumentForUser:emailTextField.text];
    
}

- (IBAction)loginTouchUp:(UIButton *)sender {
    
    CommunityLoginViewController *viewController;
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityLoginViewController"];
    
    if ([self.restorationIdentifier isEqualToString:@"Launch_ForgotViewController"]) {
        NSLog(@"This is LaunchStoryboard....");
        [self.navigationController popViewControllerAnimated:YES];
    }else{

        [self.slidingViewController changeTopViewController:viewController];
    }
}

- (IBAction)smoochMessageTouchUp:(MIBadgeButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}

#pragma mark - Custom Method

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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)sendEmailWithNewPassword: (NSString *)newPassword {
    NSString *post = [NSString stringWithFormat:@"email_address=%@&password=%@", emailTextField.text, newPassword];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://getpreveal.com/app_email/send_mail.php"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }

}

- (void)sendNewPassword {
    LoginManager *lm = [LoginManager sharedInstance];
    
    autoPassword = [lm getAutoPassword];
    salt = [lm getSalt];
    hashedPassword = [lm getHashedPassword:autoPassword withSalt:salt];
    
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [values setObject:emailTextField.text forKey:@"_id"];
    [values setObject:emailTextField.text forKey:@"name"];
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

#pragma mark Observer methods

- (void) receiveDocumentDownloadDoneNotification: (NSNotification *) notification
{
    LoginManager *lm = [LoginManager sharedInstance];
    
    if (lm.user != nil) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        [prefs setObject:emailTextField.text forKey:COMMUNITY_USERNAME];
//        [prefs setObject:autoPassword forKey:COMMUNITY_PASSWORD];
        [prefs setObject:lm.user.studioURL forKey:STUDIO_URL];
        [prefs setObject:lm.user.studioName forKey:STUDIO_NAME];
        [prefs setObject:lm.user.displayName forKey:DISPLAY_NAME];
        [prefs synchronize];
        [self removeObservers];
        
//        [self sendEmailWithNewPassword:autoPassword];
        [self sendNewPassword];
    } else {
        self.errorLabel.text = @"Invalid credentials. Please verify your email address.";
        errorLabel.hidden = NO;
        self.fadedView.hidden = YES;
        [self.activityView stopAnimating];
    }
}

- (void) receiveDocumentDownloadErroredNotification: (NSNotification *) notification
{
    [self.errorLabel setHidden:NO];
    self.errorLabel.text = @"Invalid credentials. Please verify your email address.";
    
    [activityView stopAnimating];
    fadedView.hidden = YES;
}

#pragma mark - URLConnection Delegate

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSLog(@"didReciveData...");
    
    NSError *error = nil;
    NSDictionary *jsonObject  = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (jsonObject) {//sending new password to server
        if ([jsonObject objectForKey:@"ok"]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                            message:@"The new password was just reset"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Dismiss"
//                                                  otherButtonTitles: nil];
//            [alert show];
            
            _rev = [jsonObject objectForKey:@"rev"];
            
//            [self saveUpdatedData];
            
            [self sendEmailWithNewPassword:autoPassword];
            
        } else {
            if ([[jsonObject objectForKey:@"error"] isEqualToString:@"conflict"]) {
                self.errorLabel.text = @"Email address already registered.";
            } else {
                self.errorLabel.text = [NSString stringWithFormat:@"%@: %@", [jsonObject objectForKey:@"error"], [jsonObject objectForKey:@"reason"]];
            }
            [self.errorLabel setHidden:NO];
            
            self.fadedView.hidden = YES;
            [self.activityView stopAnimating];
        }
    }else if (str) {//sending email with new password to specific email address
        if ([str isEqualToString:EMAIL_SUCCESS]) {
            [stateLabel setText:@"Your new password has been sent to your email. Please check it!"];
            [stateLabel setHidden:NO];
            
            [descriptionLabel setHidden:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:RESET_EMAIL];
        }else{
            self.errorLabel.text = @"Failure. Please try again!.";
            [self.errorLabel setHidden:NO];
        }
        
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        [prefs setObject:emailTextField.text forKey:COMMUNITY_USERNAME];
//        [prefs setObject:autoPassword forKey:COMMUNITY_PASSWORD];
        
        self.fadedView.hidden = YES;
        [self.activityView stopAnimating];
    }
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError...");
    
    self.fadedView.hidden = YES;
    [self.activityView stopAnimating];
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"didFinishLoading...");
}
@end
