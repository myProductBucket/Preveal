//
//  HelpWebViewController.m
//  precapture
//
//  Created by Randy Crafton on 6/2/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "HelpWebViewController.h"
#import <SafariServices/SafariServices.h>
#import <WebKit/WebKit.h>

@interface HelpWebViewController () <SFSafariViewControllerDelegate>{
    WKWebView *myWebView;
}

@end

@implementation HelpWebViewController

@synthesize webView, activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.contentSizeForViewInPopover = CGSizeMake(800, 650);
}

- (void) viewWillAppear:(BOOL)animated
{
    NSString *URL = @"http://support.getpreveal.com";
    
    [activityView startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.];//NSURLCacheStorageAllowed
    [webView loadRequest:request];
    
    //First try
//    [myWebView setFrame:[[self view] bounds]];
//    [myWebView loadRequest:request];
//    [self.view insertSubview:myWebView aboveSubview:webView];
    
    //Second try
//    if ([SFSafariViewController class] != nil) {
//        SFSafariViewController *mySafari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:URL]];
//        //    [self showViewController:mySafari sender:nil];
//        mySafari.delegate = self;
//        [self presentViewController:mySafari animated:YES completion:nil];
//    }else{
//        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]]) {
//            NSLog(@"Failed to open url: %@", URL);
//        }
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark WebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityView stopAnimating];
    activityView.hidden = YES;
}
@end
