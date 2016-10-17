//
//  DropBoxRegistrationViewController.h
//  precapture
//
//  Created by Randy Crafton on 2/3/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <DropBox/Dropbox.h>
#import "PrevealBaseViewController.h"

@interface DropBoxRegistrationViewController : PrevealBaseViewController
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *authorizeDropbox;
@property (nonatomic, retain) IBOutlet UIButton *deauthorizeDropbox;
@property (nonatomic, retain) NSTimer *timer;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

@property (weak, nonatomic) IBOutlet UIButton *unuseDropboxButton;


- (IBAction)toggleDropboxConnected:(id)sender;
@end
