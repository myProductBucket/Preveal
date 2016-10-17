//
//  CommunityRegisterViewController.h
//  precapture
//
//  Created by Randy Crafton on 3/24/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevealBaseViewController.h"

@interface CommunityRegisterViewController : PrevealBaseViewController <NSURLConnectionDelegate>

@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *confirmPasswordField;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *studioNameField;
@property (nonatomic, retain) IBOutlet UITextField *studioUrlField;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) IBOutlet UIView *fadedView;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

@property (nonatomic, assign) BOOL inLaunchView;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)submitButtonPressedFromLaunchView:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

- (IBAction)tosButtonPressed:(id)sender;


- (BOOL) NSStringIsValidEmail:(NSString *)checkString;
- (NSString *) getWelcomeTitle;
- (NSString *) getWelcomeText;


@end
