//
//  DropboxViewControllerDelegateProtocol.h
//  precapture
//
//  Created by Randy Crafton on 6/18/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

@protocol DropboxViewControllerDelegateProtocol<NSObject>
- (void)didSelectImageFromDropbox:(UIImage *)image;
@end
