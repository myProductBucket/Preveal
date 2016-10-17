//
//  HamburglerMenuViewController.h
//  precapture
//
//  Created by Randy Crafton on 3/19/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburglerMenuViewController : UITableViewController <UITextFieldDelegate, NSURLConnectionDelegate>

@property (nonatomic, retain) UIStoryboard *launchStoryBoard;


@property (nonatomic, retain) IBOutlet UIImageView *dropboxArrow;
@property (nonatomic, retain) IBOutlet UIImageView *communityArrow;
@property (nonatomic, retain) IBOutlet UIImageView *measurementArrow;

@property (nonatomic, retain) IBOutlet UITableViewCell *dropboxCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *communityCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *measurementCell;


@property (nonatomic, assign) CGFloat dropboxRowHeight;
@property (nonatomic, assign) CGFloat communityRowHeight;
@property (nonatomic, assign) CGFloat measurementRowHeight;








@property (nonatomic, assign) NSInteger lastSelectedIndexRow;

@property (nonatomic, retain) IBOutlet UIView *homeBackground;
@property (nonatomic, retain) IBOutlet UIView *communityBackground;
@property (nonatomic, retain) IBOutlet UIView *dropBoxBackground;
@property (nonatomic, retain) IBOutlet UIView *measurementBackground;
@property (nonatomic, retain) IBOutlet UIView *manageBackground;
@property (nonatomic, retain) IBOutlet UIView *helpBackground;


- (void) reloadData;
- (void) resetBackgroundViews;



@end
