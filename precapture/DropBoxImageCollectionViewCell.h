//
//  DropBoxImageCollectionViewCell.h
//  precapture
//
//  Created by Randy Crafton on 4/5/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropBoxImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *syncStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end
