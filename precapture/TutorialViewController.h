//
//  TutorialViewController.h
//  precapture
//
//  Created by Randy Crafton on 7/9/12.
//  Copyright (c) 2012 JSA Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeScreenViewController;

@interface TutorialViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    HomeScreenViewController *homeScreen;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) HomeScreenViewController *homeScreen;

- (IBAction)cancelButtonPressed:(id)sender;
@end
