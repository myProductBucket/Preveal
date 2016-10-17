//
//  DropboxCellCell.m
//  precapture
//
//  Created by Randy Crafton on 6/15/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "DropboxCell.h"

@implementation DropboxCell

@synthesize filename1, filename2, filename3, filename4, filename5, filename6;
@synthesize thumbnail1, thumbnail2, thumbnail3, thumbnail4, thumbnail5, thumbnail6;
@synthesize noFilesLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
