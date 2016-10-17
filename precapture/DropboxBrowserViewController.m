//
//  DropboxBrowserViewController.m
//  precapture
//
//  Created by Randy Crafton on 4/5/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "DropboxBrowserViewController.h"
#import "DropBoxImageCollectionViewCell.h"
#import "DropBoxFolderCollectionViewCell.h"
//#import <Dropbox/Dropbox.h>

#import "MyDropbox.h"
#import "MyDBMetadata.h"

@interface DropboxBrowserViewController () {
    NSString *currentParentPath;
    NSString *currentFolderPath;
    DBMetadata *currentPathMetadata;
    
    NSMutableArray *currentContents;//MyDBMetadata;
}

@end

@implementation DropboxBrowserViewController

@synthesize collectionView, filesystem, root, currentPath, myReloadTimer, currentDirectoryContents, delegate;
@synthesize acticityView, activityViewBackground, backButton;

@synthesize restClient;

- (void) viewDidLoad
{
//    DBAccount *account = [[[DBAccountManager sharedManager] linkedAccounts] objectAtIndex:0];

    
    
//    self.filesystem = [[DBFilesystem alloc] initWithAccount:account];
//    self.filesystem = [[MyDropbox sharedInstance] getDBFilesystem];
//    
//    self.root = [DBPath root];
//
//    __weak id weakSelf = self;
//    [filesystem addObserver:self forPathAndDescendants:root block:^{
//        NSLog(@"observing path&descendants");
//        [weakSelf loadContentsOfDirectoryAtPath:[weakSelf currentPath]];
//    }];
//    [self loadContentsOfDirectoryAtPath:root];
    
//    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient = [[MyDropbox sharedInstance] getRestClient];
    self.restClient.delegate = self;
    
    [self showActiviyView];
    
    currentFolderPath = @"/";
    [restClient loadMetadata:currentFolderPath];
    [backButton setEnabled:NO];
}

- (void) viewWillAppear:(BOOL)animated
{
//    [self.acticityView stopAnimating];
//    self.activityViewBackground.hidden = YES;
//    self.myReloadTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadCurrentDirectory) userInfo:nil repeats:YES];
}
- (void) viewWillDisappear:(BOOL)animated
{
//    [myReloadTimer invalidate];
}

- (void) reloadCurrentDirectory
{
    [self loadContentsOfDirectoryAtPath:self.currentPath];
}

#pragma mark - Getting around the filesystem

- (void) loadContentsOfDirectoryAtPath: (DBPath *)path
{
//    NSError *error = nil;
//    self.currentDirectoryContents = [filesystem listFolder:path
//                                                     error:&error];
//    if ([[path stringValue] isEqualToString:[root stringValue]]) {
//        backButton.enabled = NO;
//    } else {
//        backButton.enabled = YES;
//    }
    self.currentPath = path;
    [self.collectionView reloadData];
    
    [self.view sendSubviewToBack:activityViewBackground];
    self.activityViewBackground.hidden = YES;
    [acticityView stopAnimating];
}


#pragma mark - Navigation Methods


- (IBAction)touchedBackButton:(id)sender
{
//    [self loadContentsOfDirectoryAtPath:currentPath.parent];
    
    currentFolderPath = currentParentPath;
    
    if (currentFolderPath == nil) {
        return;
    }
    
    if ([currentFolderPath isEqualToString:@"/"]) {
        [backButton setEnabled:NO];
    }
    
    currentParentPath = [self getParentFolderFrom:currentFolderPath];
    
    [self showActiviyView];
    
    [restClient loadMetadata:currentFolderPath];
    
}

- (IBAction)touchedCloseButton:(id)sender
{
    [restClient cancelAllRequests];
    restClient.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView Datasource


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
//    return [currentDirectoryContents count];
    NSUInteger count;
    if (currentPathMetadata == nil) {
        count = 0;
    }else{
        count = currentContents.count;
    }
    return count;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    DropBoxFolderCollectionViewCell *folderCell;
    DropBoxImageCollectionViewCell *cell;
    
    MyDBMetadata *item = (MyDBMetadata *)[currentContents objectAtIndex:indexPath.row];
    
    if (item.metadata == nil) {
        return cell;
    }
    
    if (item.metadata.isDirectory) {
        folderCell = [cv dequeueReusableCellWithReuseIdentifier:@"DropBoxFolderCollectionViewCell" forIndexPath:indexPath];
        folderCell.directoryNameLabel.text = item.metadata.filename;
        return folderCell;
    }else{
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"DropBoxImageCollectionViewCell" forIndexPath:indexPath];
        cell.imageView.image = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.nameLabel.text = item.metadata.filename;
        if ([item.metadata.filename length] > 30) {
            NSUInteger index = [item.metadata.filename length] - 14;
           cell.nameLabel.text = [NSString stringWithFormat:@"...%@", [item.metadata.filename substringFromIndex:index]];
        }
        
        cell.syncStatusLabel.hidden = NO;
        cell.imageView.alpha = 1;
        
        if (item.thumbnailPath == nil) {
            if (item.metadata.thumbnailExists) {
                NSString *toPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/thumb_%@", item.metadata.filename]];
                [restClient loadThumbnail:item.metadata.path ofSize:THUMBNAIL_SIZE intoPath:toPath];
                
                cell.syncStatusLabel.text = NSLocalizedString(@"Downloading", nil);
            }else{
                [cell.syncStatusLabel setText:@"No thumbnail available"];
            }
        }else{
            if ([UIImage imageNamed:item.thumbnailPath]) {
                cell.imageView.image = [UIImage imageNamed:item.thumbnailPath];
                cell.syncStatusLabel.hidden = YES;
            }else{
                [cell.syncStatusLabel setText:@"No thumbnail available"];
            }
        }
        
        return cell;
    }
    
    
    //    NSError *error = nil;
//    DBFileInfo *thisFile = (DBFileInfo *) [currentDirectoryContents objectAtIndex:indexPath.row];
//    if (thisFile.isFolder == NO) {
//        cell = [cv dequeueReusableCellWithReuseIdentifier:@"DropBoxImageCollectionViewCell" forIndexPath:indexPath];
//        cell.imageView.image = nil;
//        cell.backgroundColor = [UIColor clearColor];
//        cell.nameLabel.text = thisFile.path.name;
//
//        if ([thisFile.path.name length] > 30) {
//            NSUInteger index = [thisFile.path.name length] - 14;
//           cell.nameLabel.text = [NSString stringWithFormat:@"...%@", [thisFile.path.name substringFromIndex:index]];
//        }
//        cell.syncStatusLabel.hidden = NO;
//        cell.imageView.alpha = 1;
//        if (thisFile.thumbExists) {
//            DBFile *file = [filesystem openThumbnail:thisFile.path ofSize:DBThumbSizeM inFormat:DBThumbFormatPNG error:&error];
//            
//            
//            __weak id weakSelf = self;
//            [file addObserver:self block:^{
//                NSLog(@"observing file");
//                [[weakSelf collectionView] reloadData];
//            }];
//            DBFileStatus *fileStatus = file.status;
//            DBFileStatus *newerStatus = file.newerStatus;
//            cell.syncStatusLabel.hidden = NO;
//            if (fileStatus.cached){
//                // There is local image data to display in this cell
//                cell.imageView.image = [UIImage imageWithData:[file readData:nil]];
//                cell.syncStatusLabel.hidden = YES;
//            }
//            if (fileStatus.state == DBFileStateUploading){
//                cell.syncStatusLabel.text = NSLocalizedString(@"Uploading", nil);
//            } else if (fileStatus.state == DBFileStateDownloading){
//                cell.syncStatusLabel.text = NSLocalizedString(@"Downloading", nil);
//            } else if (newerStatus && file.newerStatus.state == DBFileStateDownloading){
//                cell.syncStatusLabel.text = NSLocalizedString(@"Updating", nil);
//            }
//        } else {
//            cell.syncStatusLabel.text = @"No thumbnail available";
//        }
//
//        
//        return cell;
//
//    } else {
//        folderCell = [cv dequeueReusableCellWithReuseIdentifier:@"DropBoxFolderCollectionViewCell" forIndexPath:indexPath];
//        folderCell.directoryNameLabel.text = thisFile.path.name;
//        return folderCell;
//    }
//    return cell;
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showActiviyView];
    
    MyDBMetadata *item = (MyDBMetadata *)[currentContents objectAtIndex:indexPath.row];
    
    if (item.metadata == nil) {
        return;
    }
    
    if (item.metadata.isDirectory) {
        [self.backButton setEnabled:YES];
        
        currentParentPath = currentFolderPath;
        currentFolderPath = item.metadata.path;
        
        [restClient loadMetadata:currentFolderPath];
    }else{
        NSString *toPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", item.metadata.filename]];
//        [restClient loadThumbnail:item.metadata.path ofSize:THUMBNAIL_SIZE intoPath:toPath];
        
        [restClient loadFile:item.metadata.path intoPath:toPath];
        
    }
//    DBFileInfo *thisFile = (DBFileInfo *) [currentDirectoryContents objectAtIndex:indexPath.row];
//    if (thisFile.isFolder) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loadContentsOfDirectoryAtPath:thisFile.path];
//        });
//    } else {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            DBFile *file = [filesystem openFile:thisFile.path error:nil];
//            [self.delegate didSelectImageFromDropbox:[UIImage imageWithData:[file readData:nil]]];
//            [self.activityViewBackground setHidden:YES];
//            
//            [self dismissViewControllerAnimated:YES completion:NULL];
//        });
////        [self dismissViewControllerAnimated:YES completion:NULL];
//
//    }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{ }


#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(128 , 158);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

#pragma mark - DBRestClientDelegate

#pragma mark - Listing folders
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        if (currentContents) {
            currentContents = nil;
        }
        currentContents = [[NSMutableArray alloc] init];
        
        for (DBMetadata *file in metadata.contents) {
            [currentContents addObject:[[MyDBMetadata alloc] initWithMetadata:file]];
        }
        currentPathMetadata = metadata;
        
        [self.collectionView reloadData];
        
        [self hideActivityView];
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error.description);
    
    [restClient loadMetadata:currentFolderPath];
}

#pragma mark - Downloading thumbnails

- (void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath {
    
}

- (void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath metadata:(DBMetadata *)metadata {
    
    for (MyDBMetadata *item in currentContents) {
        if ([item.metadata.path isEqualToString:metadata.path]) {
            
            item.thumbnailPath = destPath;
            
            [collectionView reloadData];
            
            break;
        }
    }
    
    [client cancelThumbnailLoad:metadata.path size:THUMBNAIL_SIZE];
}

- (void)restClient:(DBRestClient *)client loadThumbnailFailedWithError:(NSError *)error {
//    NSLog(@"There was an error loading thumbnail: %@", error.description);
}

#pragma mark - Downloading files

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath {
    NSLog(@"File loaded into path: %@", destPath);
    if ([UIImage imageNamed:destPath]) {
        [self.delegate didSelectImageFromDropbox:[UIImage imageNamed:destPath]];
        [self.activityViewBackground setHidden:YES];
        
        restClient.delegate = nil;
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    [self hideActivityView];
}

//- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
//    
//}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error.description);
    
    [self hideActivityView];
}


#pragma mark - Custom Method

- (void)showActiviyView {
    [self.view bringSubviewToFront:activityViewBackground];
    self.activityViewBackground.hidden = NO;
    [acticityView startAnimating];
}

- (void)hideActivityView {
    [self.acticityView stopAnimating];
    [self.activityViewBackground setHidden:YES];
}

- (NSString *)getParentFolderFrom: (NSString *)currentFolder {
    NSString *parent;
    
    NSArray<NSString *> *subs = [currentFolder componentsSeparatedByString:@"/"];
    
    parent = [currentFolder substringToIndex: [currentFolder length] - [subs[subs.count - 1] length]];
    
    return parent;
}

@end
