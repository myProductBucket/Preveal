//
//  CommunityForgotPasswordViewController.h
//  precapture
//
//  Created by Urban Drescher on 3/25/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import "PrevealBaseViewController.h"

@interface CommunityForgotPasswordViewController : PrevealBaseViewController<UITextFieldDelegate, NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) IBOutlet UIView *fadedView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
