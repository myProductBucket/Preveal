//
//  CollectionManagementViewController.m
//  precapture
//
//  Created by Randy Crafton on 7/3/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionManagementViewController.h"
#import "Collections.h"
#import "Collection.h"
#import "Scalinator.h"
#import "CollectionDetailEditViewController.h"
#import "InAppPurchaseController.h"
#import "PrevealCommunityUrls.h"
#import <QuartzCore/QuartzCore.h>
#import "DemoRoomViewController.h"
#import "ManageTemplateCollectionViewCell.h"
#import "CloudManageTemplateCollectionViewCell.h"
#import "PrevealSlidingViewController.h"

@interface CollectionManagementViewController ()

@end

@implementation CollectionManagementViewController

@synthesize templateScrollView, collections, currentlyEditing, purchaser, homeButton;
@synthesize singlesPageControl, singlesPageControlBackground, textPageRepresentaion, selectedBundleIdentifier, groupIndexes, groupRibbon;
@synthesize prevealGroupButton, prodpiGroupButton, bayphotoGroupButton, dagBundle1GroupButton, dagCollectionOneGroupButton, favoritesGroupButton;
@synthesize lastGroupButton, singleImageGroupButton, quickView, manageTitle, manageTitleIndexes, shouldLoadLastMyCollectionsWhenExiting;
@synthesize communitySortOptions, currentGroupName, currentCommunitySortIndex, reverseCommunitySortDirection;
@synthesize activityIndicator, communityGroupButton, myTemplatesGroupButton, communityOnlyMode;
@synthesize collectionView, mostRecentIndexPath, backButton, timer;

@synthesize smoochMessageButton;
@synthesize fadeView, activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
    
    currentCommunitySortIndex = 0;
    [self registerObservers];
    homeButton.hidden = NO;
    backButton.hidden = YES;
    if (communityOnlyMode == YES)
    {
        [self.manageTitle setImage:[UIImage imageNamed:[self.manageTitleIndexes objectAtIndex:communityGroupButton.tag]]];
        self.groupRibbon.hidden = YES;
        [self.groupRibbon removeFromSuperview];
        [self loadGroupButtons];
        homeButton.hidden = YES;
        backButton.hidden = NO;
        [self.manageTitle setImage:[UIImage imageNamed:@"title-community.png"]];
        self.currentGroupName = kPrevealCommunityGroupName;
        [self groupButtonPressed:communityGroupButton];
    
        return;
    }else{
        [self.view addSubview:self.groupRibbon];
    }
    [self showPrevealGroup];


}



- (void)viewWillAppear:(BOOL)animated
{
    [self reloadCollections];
    [self loadGroupButtons];
    if ([self.currentGroupName isEqualToString:kPrevealCommunityGroupName]) {
        [self startTimer];
    }
    [self.collectionView reloadData];
    if (communityOnlyMode == YES)
    {
        CGRect newCollectionViewFrame = CGRectMake(collectionView.frame.origin.x, collectionView.frame.origin.y, collectionView.frame.size.width, collectionView.frame.size.height + groupRibbon.frame.size.height);
        [collectionView setFrame:newCollectionViewFrame];
        
        [self.fadeView setFrame:CGRectMake(self.fadeView.frame.origin.x, self.fadeView.frame.origin.y, self.fadeView.frame.size.width, self.fadeView.frame.size.height + self.groupRibbon.frame.size.height)];
    }
    
    [self setBadgeNumber];
}

- (void) startTimer
{
    if (timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2. target:self.collectionView selector:@selector(reloadData) userInfo:nil repeats:YES];
    } else {
        [timer fire];
        timer = nil;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void) loadGroupButtons
{

    self.groupIndexes = [NSArray arrayWithObjects:@"preveal", @"prodpi", @"bayphoto", @"singles", @"favorites",
                             @"com.chrisandadriennescott.preveal.inspireguide.canvas", @"singlesFramed", kPrevealMyCollectionsGroupName,
                             kPrevealCommunityGroupName, kPrevealDA1Name, nil];
    self.manageTitleIndexes = [NSArray arrayWithObjects:@"text-manage-title-preveal.png", @"text-manage-title-prodpi.png",
                               @"text-manage-title-bayphoto.png", @"text-manage-title-singles.png", @"text-manage-title-faves.png",
                               @"text-manage-title-da1.png", @"text-manage-title-framed.png", @"text-manage-title-mine.png",
                               @"text-manage-title-community.png", @"text-manage-title-da1.png", nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



- (void)showEditViewForCollection
{
    [self performSegueWithIdentifier:@"editDetailsModal" sender:self.currentlyEditing];
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

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}


#pragma mark  ManageTemplateCollectionDelegate methods
- (void)showEditViewForCollection: (Collection *) collection
{
    self.currentlyEditing = collection;
    [self performSegueWithIdentifier:@"editDetailsModal" sender:self.currentlyEditing];
}

- (void) reload
{
    self.collections = nil;
    [self loadCollections];
    [self groupButtonPressed:self.lastGroupButton];
    [self.collectionView reloadData];
}

- (void) reloadData
{
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark Navigation / Interactions

- (IBAction)didPressBackButton:(id)sender
{
    PrevealSlidingViewController *slidingViewController = [self.navigationController.viewControllers objectAtIndex:0];
    [(DemoRoomViewController *)slidingViewController.topViewController setShouldLoadLastMyTemplate:shouldLoadLastMyCollectionsWhenExiting];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showInfoForCommunityCollection:(Collection *)collection
{
    self.currentlyEditing = collection;
    [self performSegueWithIdentifier:@"communityCollectionInfoSegue" sender:self.currentlyEditing];
}

- (void) downloadCollection: (Collection *)collection;
{
    collection.groupName = kPrevealMyCollectionsGroupName;
    collection.order = @"0";
    NSError *error = nil;
    
    Collections *myCollections = [[Collections alloc] init];
    [myCollections setAllCollections:collections.allCollections];
    [myCollections setCurrentGroupName:kPrevealMyCollectionsGroupName error:&error];
    if (error == nil) {
        collection.order = [NSString stringWithFormat:@"%lu", [myCollections.currentGroup count] + 1];
    }
    myCollections.allCollections = nil;
    myCollections.currentGroup = nil;
    myCollections = nil;
    [collection saveToFile];
    [collections.allCollections addObject:collection];
    
    // Increment the download count for popularity rankings.
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [PrevealCommunityUrls getDownloadedDocumentPathForDocumentWithId:currentlyEditing.file_name];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"PUT"];
        
        [NSURLConnection connectionWithRequest:request delegate:nil];
    });
    
    if (communityOnlyMode == YES) {
        [self setShouldLoadLastTemplateInPreviousViewController];
    }
}

- (void) setShouldLoadLastTemplateInPreviousViewController
{
    self.shouldLoadLastMyCollectionsWhenExiting = YES;
//    DemoRoomViewController *dr = (DemoRoomViewController *)[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
//    if ([dr respondsToSelector:@selector(setShouldLoadLastMyTemplate:)]) {
//        dr.shouldLoadLastMyTemplate = YES;
//    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editDetailsModal"]) {
        Collection *newCopyOfCollection = [Collections loadCollectionFromFileNamed:currentlyEditing.file_name];
        [(CollectionDetailEditViewController *)[segue destinationViewController] setCurrentCollection:newCopyOfCollection];
    } else if ([segue.identifier isEqualToString:@"communityCollectionInfoSegue"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        [(CollectionDetailEditViewController *)[nc topViewController] setCurrentCollection:[currentlyEditing copy]];
        [(CollectionDetailEditViewController *)[nc topViewController] setPreviousViewController:self];
    }
    
}

 
#pragma mark - Collection stuff

- (void) loadCollections
{
    if (self.collections == nil) {
        self.collections = [[Collections alloc] init];

        if ([currentGroupName isEqualToString:kPrevealCommunityGroupName]) {
            [self groupButtonPressed:self.communityGroupButton];
        } else {
            [collections loadCollectionsFromUserDocuments];
            //[self showPrevealGroup];
        }
        [self toggleSortOptionsViewable];
    }
}

- (void) showPrevealGroup
{
    NSError *error = nil;
    self.currentGroupName = @"preveal";
    [collections setCurrentGroupName:@"preveal" error:&error];
    self.lastGroupButton = self.prevealGroupButton;
    prevealGroupButton.selected = YES;
    [self.manageTitle setImage:[UIImage imageNamed:@"text-manage-title-preveal.png"]];
}

- (void) reloadCollections
{
    self.collections = nil;
    self.collections = [[Collections alloc] init];
    [collections loadCollectionsFromUserDocuments];
    NSError *error = nil;
    [collections setCurrentGroupName:self.currentGroupName error:&error];

}

#pragma mark -
#pragma mark  groupButtonPressed

- (IBAction)groupButtonPressed:(id)sender
{
    NSError *error = nil;
    UIButton *pressedButton = (UIButton *) sender;
    NSString *groupName = [groupIndexes objectAtIndex:pressedButton.tag];

//    if ([groupName isEqualToString:kPrevealMyCollectionsGroupName]) {
//        [self reloadCollections];
//    }

    [self.collectionView setContentOffset:CGPointZero animated:YES];

    
//    NSMutableArray *oldGroup = collections.currentGroup;
    
    if ([groupName isEqualToString:kPrevealCommunityGroupName]) {
        
        if (![PrevealCommunityUrls canUseCommunity]) {
            UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityRegisterViewController"];
            [self.slidingViewController setTopViewController:newViewController];

        } else {
            [self reloadCollections];
            [self willStartCommunityRequest];
            [self.collections setCurrentGroupName:groupName error:&error];
        }
        [self startTimer];
        return;
    }
    [self.collections setCurrentGroupName:groupName error:&error];
    UIAlertView *alert;

    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        if ([groupName isEqualToString:@"favorites"]) {
            alert = [[UIAlertView alloc] initWithTitle:@"No favorites!"
                                                            message:@"Please visit the Manage Templates section to set some favorite templates!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
            [alert show];
        } else if ([groupName isEqualToString:kPrevealMyCollectionsGroupName]) {
            alert = [[UIAlertView alloc] initWithTitle:@"No templates"
                                               message:@"You haven't created or downloaded any templates!"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        // Fail gracefully back to previous screen, but don't reset Templates
        if ([groupName isEqualToString:currentGroupName]) {
            [self groupButtonPressed:prevealGroupButton];
        } else {
            [self groupButtonPressed:lastGroupButton];
        }
        return;
    }

    
    if (lastGroupButton != nil) {
        lastGroupButton.selected = NO;
    }
    self.lastGroupButton = pressedButton;
    pressedButton.selected = YES;
    [self.manageTitle setImage:[UIImage imageNamed:[self.manageTitleIndexes objectAtIndex:lastGroupButton.tag]]];
    self.currentGroupName = groupName;
    [self.collectionView reloadData];
    [self toggleSortOptionsViewable];
}


#pragma mark -
#pragma mark Community Sort Options

- (void) toggleSortOptionsViewable
{
    communitySortOptions.hidden = ![collections inCommunityView];
}

- (IBAction)sortOptionsChanged:(id)sender
{
    [self.collectionView setContentOffset:CGPointZero animated:YES];

    BOOL isDescendingOriginally = YES;
    BOOL isDescending = NO;
    NSURL *url;
    PrevealCommunityUrls *urls = [[PrevealCommunityUrls alloc] init];
    switch (communitySortOptions.selectedSegmentIndex) {
        case 1: // mostRecent
            url = [urls getPrevealDocumentsUrl];
            isDescendingOriginally = YES;

            break;
        case 0: // most popular
            url = [urls getMostPopularUrl];
            isDescendingOriginally = YES;            
            break;
        case 2: // total size
            url = [urls getSortBySizeUrl ];
            break;
        case 3: // number of openings
            url = [urls getSortByNumberOfOpeningsUrl];
            break;
        default:
            break;
    }
    
    collections.currentLastRowLoaded = [NSNumber numberWithInt:0];
    collections.currentFirstRowLoaded = [NSNumber numberWithInt:0];
    collections.currentFrontTarget = [NSNumber numberWithInt:0];
    collections.currentEndTarget = [NSNumber numberWithInt:0];
    
    if (currentCommunitySortIndex == communitySortOptions.selectedSegmentIndex) {
        self.reverseCommunitySortDirection = !reverseCommunitySortDirection;
        if (reverseCommunitySortDirection == YES && isDescendingOriginally == YES) {
            isDescending = NO;
        } else {
            isDescending = YES;
        }
        [collections loadCommunityCollectionsUsingUrl:url descending:isDescending];
    } else {
        self.reverseCommunitySortDirection = NO;
        [collections loadCommunityCollectionsUsingUrl:url descending:isDescendingOriginally];
        currentCommunitySortIndex = communitySortOptions.selectedSegmentIndex;
    }
    [self willStartCommunityRequest];
}


#pragma mark -
#pragma mark Observer methods
- (void) registerObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCollectionCommunicationCompleteNotification:)
                                                 name:kPrevealCollectionsDownloadDone
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCollectionCommunicationErroredNotification:)
                                                 name:kPrevealCollectionsDownloadError
                                               object:nil];
}
- (void) willStartCommunityRequest
{
    self.manageTitle.image = [UIImage imageNamed:@"text-manage-title-community.png"];
//    [self.view bringSubviewToFront:activityIndicator];
//    activityIndicator.hidden = NO;
//    [activityIndicator startAnimating];
    [self.view bringSubviewToFront:self.fadeView];
    [self.fadeView setHidden:NO];
    [self.activityView startAnimating];
}

- (void)enableActivityView {
    
}

- (void) receiveCollectionCommunicationCompleteNotification: (NSNotification *) notification
{
//    if (activityIndicator.hidden == NO) {
//        [activityIndicator stopAnimating];
//        [activityIndicator setHidden:YES];
//    }
    if (self.activityView.hidden == NO) {
        [self.activityView stopAnimating];
        [self.fadeView setHidden:YES];
    }

    if (lastGroupButton != nil && lastGroupButton != communityGroupButton) {
        lastGroupButton.selected = NO;
    }
    self.lastGroupButton = communityGroupButton;
    communityGroupButton.selected = YES;
    [self.manageTitle setImage:[UIImage imageNamed:@"text-manage-title-community.png"]];
    self.currentGroupName = kPrevealCommunityGroupName;
    [self toggleSortOptionsViewable];
    [self.collectionView reloadData];
}

- (void) receiveCollectionCommunicationErroredNotification: (NSNotification *) notification
{
//    [activityIndicator stopAnimating];
    [self.activityView stopAnimating];
    [self.fadeView setHidden:YES];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communications Problem"
                                                    message:@"We are unable to communicate with the Preveal Community servers at this time"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];

}

- (void) receiveCollectionCommunicationTimedOutNotification: (NSNotification *) notification
{
//    [activityIndicator stopAnimating];
    [self.activityView stopAnimating];
    [self.fadeView setHidden:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communications Problem"
                                                    message:@"We are unable to communicate with the Preveal Community servers at this time"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}



#pragma mark - UICollectionView Datasource


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (collections.inCommunityView) {
        return [collections.totalNumberOfRowsInCommunityView intValue];
    } else {
        return [[self.collections currentGroup] count];
    }
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.mostRecentIndexPath = indexPath;
    // NSLog(@"Looking for indexpath.row %d", indexPath.row);
    if (collections.inCommunityView == YES) {
      //  int row = indexPath.row;
        // If the current indexPath.row is within our download request amount of the end of the array, go ahead and fetch some mo'
        NSInteger currentEnd = [collections.currentEndTarget intValue];
        NSInteger currentIndex = indexPath.row;
        NSLog(@"currentEnd: %ld", (long)currentEnd);
        NSLog(@"currentIndex: %ld", (long)currentIndex);
        if ([collections.currentEndTarget intValue] - indexPath.row <= kPrevealCommunityRecordsPerRequest)
        {
            [collections incrementEndTarget:kPrevealCommunityRecordsPerRequest];
        }

        // If the current indexPath.row is within our download request amount of the front of the array, go ahead and fetch some mo'

        if ([collections.currentFrontTarget intValue] > 0 &&
            [collections.currentFrontTarget intValue] <= indexPath.row - kPrevealCommunityRecordsPerRequest)
        {
                [collections decrementFrontTarget:kPrevealCommunityRecordsPerRequest];
        }
    }
    
    ManageTemplateCollectionViewCell *cell;
    if (collections.inCommunityView) {
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"CloudMgmtCell" forIndexPath:indexPath];
        
        
        // Trying to force a reload of the image so we get a little different behavior other than the whack a mole
        /**
        CGRect newRect = CGRectMake([(CloudManageTemplateCollectionViewCell *)cell downloadButton].frame.origin.x,
                                    [(CloudManageTemplateCollectionViewCell *)cell downloadButton].frame.origin.y,
                                    25,
                                    25);
        ** /
        CGRect newRect = CGRectMake(33, 7, 25, 25);
        [(CloudManageTemplateCollectionViewCell *)cell setDownloadButton:nil];
        UIButton *newButton = [[UIButton alloc] initWithFrame:newRect];
        [newButton setImage:[UIImage imageNamed:@"community-card-cloud-default.png"] forState:UIControlStateNormal];
        [newButton setImage:[UIImage imageNamed:@"community-card-cloud-active.png"] forState:UIControlStateSelected];
        [newButton addTarget:cell action:@selector(downloadButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [(CloudManageTemplateCollectionViewCell *)cell setDownloadButtonImageToDownloadedState];
        [(CloudManageTemplateCollectionViewCell *)cell setDownloadButton:newButton];
        **/
    } else {
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"MgmtCell" forIndexPath:indexPath];
    }

    // Make it pretty
    cell.contentView.layer.cornerRadius = 4.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.clipsToBounds = YES;
    
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    


    // If the currentGroup is still empty, don't even bother
    if ([collections.currentGroup count] == 0) {
        [cell putInWaitingState:self];
        return cell;
    }
    // If we're working with the community
    if (collections.inCommunityView == YES) {
       
        // If we're currently loading data back to the front of the stack
        if (collections.focusOnFrontOfStack) {
            // and the frontMost record is bigger than our current ite
            if ([collections.currentFirstRowLoaded intValue] > indexPath.row) {
                // Set the waiting state
                [cell putInWaitingState:self];
                return cell;
            }
        // Or if we're currently loading data to the end of the stack
        } else {
            // and the furthest record we've downloaded is less than the current item
            if ([collections.currentLastRowLoaded intValue] <= indexPath.row ) {
                // Set the waiting state
                [cell putInWaitingState:self];
                return cell;
            }
        }
    }

    Collection *collection = [self getCollectionForIndexPath:indexPath];
    if (collection == nil) {
        [cell putInWaitingState:self];
        return cell;
    }
    [cell setMyCollection: collection];
    return cell;
}

- (Collection *) getCollectionForIndexPath: (NSIndexPath *) indexPath
{
    Collection *collection = nil;
    // Figure out what row array index we really need.
    long indexForCorrectTemplate = indexPath.row;
    
    if (collections.inCommunityView) {
        indexForCorrectTemplate -=  [collections.currentFirstRowLoaded intValue];
    }
    
    if (indexForCorrectTemplate < 0) {
        
        return collection;
    }
    
    //    NSLog(@"Grabbing object at index: %ld for indexPath.row = %d when currentFirstRowLoaded = %@",
    //          indexForCorrectTemplate, indexPath.row, collections.currentFirstRowLoaded);
    if ([collections.currentGroup count] > indexForCorrectTemplate) {
        collection = [collections.currentGroup objectAtIndex:indexForCorrectTemplate];
    }
    return collection;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    Collection *collection = [self getCollectionForIndexPath:indexPath];
    if (collections.inCommunityView) {
        [self showInfoForCommunityCollection:collection];
    } else {
        [self showEditViewForCollection:collection];
    }
     */
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{ }


#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(175, 175);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) didReceiveMemoryWarning
{
    if (collections.inCommunityView) {
        [collections trimCommunityArray];
    }
}

@end
