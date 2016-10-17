//
//  HamburglerMenuViewController.m
//  precapture
//
//  Created by Randy Crafton on 3/19/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "HamburglerMenuViewController.h"
#import "SCSlidingViewController.h"
#import "LoginManager.h"
#import "PrevealCommunityUrls.h"
#import "PrevealBaseViewController.h"
#import "CommunityRegisterViewController.h"
#import "MeasurementSettingsViewController.h"
#import "DropBoxRegistrationViewController.h"

//#import <DropBox/Dropbox.h>

@interface HamburglerMenuViewController ()

@end
@implementation HamburglerMenuViewController

@synthesize launchStoryBoard;
@synthesize dropboxArrow, communityArrow, measurementArrow;
@synthesize dropboxCell, communityCell, measurementCell;
@synthesize dropboxRowHeight, communityRowHeight, measurementRowHeight;
@synthesize lastSelectedIndexRow;
@synthesize homeBackground, dropBoxBackground, measurementBackground, manageBackground, helpBackground, communityBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.launchStoryBoard = [UIStoryboard storyboardWithName:@"LaunchStoryBoard" bundle:nil];
    self.view.backgroundColor = [UIColor colorWithRed:90/255. green:124/255. blue:156/255. alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:90/255. green:124/255. blue:156/255. alpha:1];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self resetRowHeights];
    [self resetBackgroundViews];

}


- (void) resetRowHeights
{
    self.measurementRowHeight = 44;
    self.dropboxRowHeight = 44;
    self.communityRowHeight = 44;
    self.communityArrow.image = [UIImage imageNamed:@"arrow-right-1.png"];
    self.measurementArrow.image = [UIImage imageNamed:@"arrow-right-1.png"];
    self.dropboxArrow.image = [UIImage imageNamed:@"arrow-right-1.png"];

}

- (void) resetBackgroundViews
{
    homeBackground.hidden = YES;
    dropBoxBackground.hidden = YES;
    measurementBackground.hidden = YES;
    manageBackground.hidden = YES;
    helpBackground.hidden = YES;
    communityBackground.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    switch (indexPath.row) {
        case 2:
            height = communityRowHeight;
            break;
        case 3:
            height = dropboxRowHeight;
            break;
        case 4:
            height = measurementRowHeight;
            break;
        default:
            break;
    }
    return height;
}

/**
 *
 *  Handle Menu Selections
 *      0 -
 *      1 - Home
 *      2 - Community Profile
 *      3 - Dropbox
 *      4 - Measurement Unit
 *      5 - Manage Templates
 *      6 - Help
 */


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resetRowHeights];
    [self resetBackgroundViews];
    PrevealBaseViewController *newViewController;
    
    if (lastSelectedIndexRow == indexPath.row) {
        lastSelectedIndexRow = -1;
    } else {
        lastSelectedIndexRow = indexPath.row;
        switch (indexPath.row) {
            case 1:
                self.homeBackground.hidden = NO;
                newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
                break;
            case 2: // Community
                self.communityBackground.hidden = NO;

                if ([[LoginManager sharedInstance] getSavedUserName] == nil) {
                    newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityRegisterViewController"];
                } else {
                    newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityEditDetailsViewController"];
                }
                break;
            case 3: // Dropbox
                dropBoxBackground.hidden = NO;
                newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DropBoxRegistrationViewController"];

                break;
            case 4: // Measurement
                measurementBackground.hidden = NO;
                newViewController = [launchStoryBoard instantiateViewControllerWithIdentifier:@"MeasurementSettingsViewController"];
                [self addHamburglerToViewController:newViewController];
                [(MeasurementSettingsViewController *)newViewController nextButton].hidden = YES;
                [(MeasurementSettingsViewController *)newViewController saveButton].hidden = NO;
                [[(MeasurementSettingsViewController *)newViewController backButton] setHidden:YES];

                break;
            case 5:
                manageBackground.hidden = NO;
                newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageTemplatesViewController"];
                break;
                
            case 6:
                helpBackground.hidden = NO;
//                newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpWebViewController"];
//                
                NSString *URL = @"http://support.getpreveal.com";
                if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]]) {
                    NSLog(@"Failed to open url: %@", URL);
                }
                
                break;
//            default:
//                break;
        }
    }
    if (newViewController) {
        [self.slidingViewController changeTopViewController:newViewController forceReload:NO];
    } else {
       // [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
    }
    
    
}

- (void) addHamburglerToViewController: (PrevealBaseViewController *)viewController
{
    UIButton *hamburgler = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 62, 62)];
    [hamburgler setImage:[UIImage imageNamed:@"btn-hamburger-off.png"] forState:UIControlStateNormal];
    [hamburgler setImage:[UIImage imageNamed:@"btn-hamburger-on.png"] forState:UIControlStateSelected];
    [hamburgler addTarget:viewController action:@selector(toggleHamburgler:) forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:hamburgler];
}

- (void) reloadData
{
    [self resetRowHeights];
    [self.tableView reloadData];
}




@end
