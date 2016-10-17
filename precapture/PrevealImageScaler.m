//
//  PrevealImageScaler.m
//  precapture
//
//  Created by Randy Crafton on 11/28/15.
//  Copyright © 2015 JSA Technologies. All rights reserved.
//

#import "PrevealImageScaler.h"
#import "PrevealConstants.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation PrevealImageScaler


+ (UIImage *) scaleImage: (UIImage *)image
{
    CGImageRef cgImage = image.CGImage;
    
    float width = (float) CGImageGetWidth(cgImage);
    float height = (float) CGImageGetHeight(cgImage);
    
    if (width < kPrevealMaxImageSize || height < kPrevealMaxImageSize) {
        return image;
    }
    
    float newWidth;
    float newHeight;
    
    if (width > height) {
        
        newHeight = kPrevealMaxImageSize;

        newWidth = newHeight / height * width;

    }
    else {
        newWidth = kPrevealMaxImageSize;
        
        newHeight = newWidth / width * height;
    }
    
    CGContextRef context = CGBitmapContextCreate(nil, newWidth, newHeight, CGImageGetBitsPerComponent(cgImage), CGImageGetBytesPerRow(cgImage), CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage));
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextDrawImage(context, CGRectMake(CGPointZero.x, CGPointZero.y, newWidth, newHeight), cgImage);


    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    image = nil;

    UIImage *newImage = [UIImage imageWithCGImage:newCGImage];
    return newImage;
}
@end
