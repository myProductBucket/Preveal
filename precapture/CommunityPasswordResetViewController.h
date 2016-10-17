//
//  CommunityPasswordResetViewController.h
//  precapture
//
//  Created by Randy Crafton on 4/6/15.
//  Copyright (c) 2015 JSA Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevealBaseViewController.h"
#import "CommunityRegisterViewController.h"

@interface CommunityPasswordResetViewController : CommunityRegisterViewController

@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordField;
@property (nonatomic, retain) IBOutlet UIView *fadedView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;


@property (nonatomic, retain) UITextField *confirmPasswordField;
@property (nonatomic, retain) UILabel *errorLabel;
//@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *passwordField;
//@property (nonatomic, retain) UIView *fadedView;

- (IBAction)sendResetCode:(id)sender;
- (IBAction)resetPassword:(id)sender;


@end
