//
//  DropboxCellCell.h
//  precapture
//
//  Created by Randy Crafton on 6/15/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropboxCell : UITableViewCell {
    IBOutlet UIButton *thumbnail1;
    IBOutlet UILabel *filename1;
    IBOutlet UIButton *thumbnail2;
    IBOutlet UILabel *filename2;
    IBOutlet UIButton *thumbnail3;
    IBOutlet UILabel *filename3;
    IBOutlet UIButton *thumbnail4;
    IBOutlet UILabel *filename4;
    IBOutlet UIButton *thumbnail5;
    IBOutlet UILabel *filename5;
    IBOutlet UIButton *thumbnail6;
    IBOutlet UILabel *filename6;
    IBOutlet UILabel *noFilesLabel;

}

@property (nonatomic, retain) IBOutlet UIButton *thumbnail1;
@property (nonatomic, retain) IBOutlet UILabel *filename1;
@property (nonatomic, retain) IBOutlet UIButton *thumbnail2;
@property (nonatomic, retain) IBOutlet UILabel *filename2;
@property (nonatomic, retain) IBOutlet UIButton *thumbnail3;
@property (nonatomic, retain) IBOutlet UILabel *filename3;
@property (nonatomic, retain) IBOutlet UIButton *thumbnail4;
@property (nonatomic, retain) IBOutlet UILabel *filename4;
@property (nonatomic, retain) IBOutlet UIButton *thumbnail5;
@property (nonatomic, retain) IBOutlet UILabel *filename5;
@property (nonatomic, retain) IBOutlet UIButton *thumbnail6;
@property (nonatomic, retain) IBOutlet UILabel *filename6;
@property (nonatomic, retain) IBOutlet UILabel *noFilesLabel;

@end
