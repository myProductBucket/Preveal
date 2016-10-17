//
//  WebVideoViewController.h
//  precapture
//
//  Created by Randy Crafton on 6/8/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVideoViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityView;
    NSURL *url;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain)  NSURL *url;

@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

- (IBAction)nextButtonPressed:(id)sender;
@end
