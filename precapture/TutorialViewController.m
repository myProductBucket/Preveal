//
//  TutorialViewController.m
//  precapture
//
//  Created by Randy Crafton on 7/9/12.
//  Copyright (c) 2012 JSA Technologies. All rights reserved.
//

#import "TutorialViewController.h"
#import "HomeScreenViewController.h"


@interface TutorialViewController ()

@end

@implementation TutorialViewController

@synthesize webView, homeScreen;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(900, 725);

	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *videoID = @"45337572";
    NSString *httpPath = [NSString stringWithFormat:@"http://player.vimeo.com/video/%@?title=0&amp;byline=0&amp;portrait=0\%%22%%20width=\%%22%0.0f\%%22%%20height=\%%22%0.0f\%%22%%20frameborder=\%%230\%%22", videoID];
    NSURL *url = [NSURL URLWithString:httpPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.getpreveal.com"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webView stopLoading];
    [homeScreen dismissTutorialVideo];
}

@end
