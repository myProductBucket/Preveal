//
//  CommunityLoginViewController.h
//  precapture
//
//  Created by Randy Crafton on 4/20/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevealBaseViewController.h"

@interface CommunityLoginViewController : PrevealBaseViewController <UITextFieldDelegate, NSURLConnectionDelegate>


@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) IBOutlet UIView *fadedView;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

//@property BOOL isReset;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;

@end
