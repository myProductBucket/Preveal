//
//  ActivityAlertView.h
//  precapture
//
//  Created by Randy Crafton on 7/7/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityAlertView : UIAlertView
{
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (void) close;

@end
