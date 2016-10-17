//
//  HelpWebViewController.h
//  precapture
//
//  Created by Randy Crafton on 6/2/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevealBaseViewController.h"

@interface HelpWebViewController : PrevealBaseViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

@end
