//
//  ViewController.h
//  precapture
//
//  Created by Randy Crafton on 3/9/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SCSlidingViewController.h"
#import "PrevealBaseViewController.h"

@interface HomeScreenViewController : PrevealBaseViewController <MFMailComposeViewControllerDelegate>
{
    IBOutlet UIButton *helpButton;
}

@property (nonatomic, retain) IBOutlet UIButton *helpButton;

- (IBAction)requestATemplateButtonTouched:(id)sender;
@end
