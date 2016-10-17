//
//  WebVideoViewController.m
//  precapture
//
//  Created by Randy Crafton on 6/8/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "WebVideoViewController.h"
#import "LoginManager.h"
#import "YTVimeoExtractor.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VIMVideoPlayer-Source/VIMVideoPlayerView.h"
#import "VIMVideoPlayer-Source/VIMVideoPlayer.h"
#import <AVKit/AVKit.h>

@interface WebVideoViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoPlayerView;

@end

@implementation WebVideoViewController

@synthesize webView, activityView, url;
@synthesize smoochMessageButton;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
    
//    [self playVimeoForPreveal];
}

- (void) viewWillAppear:(BOOL)animated
{
    [activityView startAnimating];
    url = [NSURL URLWithString:@"https://player.vimeo.com/video/133722410"];//?title=0&byline=0&portrait=0
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.];
    [webView loadRequest:request];
    
    [self setBadgeNumber];
}


- (IBAction)backTouchUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonPressed:(id)sender
{
    LoginManager *lm = [LoginManager sharedInstance];
    [lm loadUserDocument];
    if ([lm getSavedUserName] != nil) {
        [self performSegueWithIdentifier:@"segueToDropBox" sender:self];
    } else {
        [self performSegueWithIdentifier:@"segueToCommunity" sender:self];
        
    }
}

- (IBAction)smoochMessageButtonTouchUp:(MIBadgeButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}


#pragma mark -
- (void)setBadgeNumber {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] && [[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] != 0) {
            [smoochMessageButton setBadgeBackgroundColor:[UIColor redColor]];
            [smoochMessageButton setBadgeTextColor:[UIColor whiteColor]];
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] || [[[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] integerValue] == 0) {
                [smoochMessageButton setBadgeString:nil];
            }else{
                [smoochMessageButton setBadgeString:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER]]];
            }
        }
    });
}
#pragma mark WebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityView stopAnimating];
    activityView.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark Play Vimeo Video

- (void)playVimeoForPreveal {
    [activityView startAnimating];
    
//    NSString *embedHTML = @"\
//    <html><head>\
//    <style type=\"text/css\">\
//    body {\
//    background-color: transparent;\
//    color: white;\
//    }\
//    </style>\
//    </head><body style=\"margin:0\">\
//    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockware-flash\" \
//    width=\"%0.0f\" height=\"%0.0f\"></embed>\
//    </body></html>";
//    NSString *html = [NSString stringWithFormat:embedHTML, @"https://www.youtube.com/watch?v=WL2l_Q1AR_Q", self.webView.frame.size.width, self.webView.frame.size.height];
//    NSString *html = @"<html><body><iframe src=\"https://player.vimeo.com/video/133722410?title=0&byline=0&portrait=0\" width=\"500\" height=\"281\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></body></html>";
//    [self.webView setBackgroundColor:[UIColor blackColor]];
//    [self.webView loadHTMLString:html baseURL:nil];
//    [self.webView setDelegate:self];

//    [[YTVimeoExtractor sharedExtractor] fetchVideoWithVimeoURL:@"https://vimeo.com/133722410" withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
//        if (video) {
//            NSURL *highQualityURL = [video highestQualityStreamURL];
//            
////            if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
//                MPMoviePlayerController *moviePlayerVC = [[MPMoviePlayerController alloc] initWithContentURL:highQualityURL];
//                [moviePlayerVC.view setFrame:self.videoPlayerView.bounds];
//            [moviePlayerVC setControlStyle:MPMovieControlStyleDefault];
//            [moviePlayerVC setShouldAutoplay:YES];
//
//                [self.videoPlayerView addSubview:moviePlayerVC.view];
//            [moviePlayerVC setFullscreen:YES animated:YES];
////                [self presentMoviePlayerViewControllerAnimated:moviePlayerVC];
////            }else{
////                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
////                playerVC.player = [AVPlayer playerWithURL:highQualityURL];
////                [playerVC.view setFrame:self.videoPlayerView.bounds];
////                [self.videoPlayerView addSubview:playerVC.view];
////                [self presentViewController:playerVC animated:YES completion:nil];
////            }
//////            [self.videoPlayerView.player setLooping:YES];
//////            [self.videoPlayerView.player disableAirplay];
//////            [self.videoPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
//////            [self.videoPlayerView.player setURL:highQualityURL];
////            
//
//        }else{
//            UIAlertView *alertView = [[UIAlertView alloc] init];
//            [alertView setTitle:error.localizedDescription];
//            [alertView setMessage:error.localizedFailureReason];
//            [alertView addButtonWithTitle:@"OK"];
//            [alertView setDelegate:self];
//            [alertView show];
//        }
//        
//        [activityView stopAnimating];
//        activityView.hidden = YES;
//    }];
}

@end
