//
//  ScalinatorTests.m
//  PreCapture
//
//  Created by Randy Crafton on 3/8/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "ScalinatorTests.h"
#import "Scalinator.h"


@implementation ScalinatorTests

@synthesize scalinator;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.scalinator = [[Scalinator alloc] init];
    STAssertNotNil(scalinator, @"Cannot create Scalinator instance");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCanSetActualSize
{
    NSDecimalNumber *width = [NSDecimalNumber decimalNumberWithString:@"8.5"];
    scalinator.actualSize = width;
    STAssertTrue([scalinator.actualSize isEqualToNumber:width], @"Width not set");
    
}

- (void)testCanSetPixelSize
{
    NSDecimalNumber *widthInPixels = [NSDecimalNumber decimalNumberWithString:@"300.0"];
    scalinator.referenceSize = widthInPixels;
    STAssertTrue([scalinator.referenceSize isEqualToNumber: widthInPixels], @"Reference size not set");
}

- (void)testSimpleHalfScale
{
    scalinator.actualSize = [NSDecimalNumber decimalNumberWithString:@"8.5"];
    scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:@"17.0"];
    NSDecimalNumber *expectedAdjustedSize = [NSDecimalNumber decimalNumberWithString:@"24"];
    NSDecimalNumber *requestedSize = [NSDecimalNumber decimalNumberWithString:@"12"];
    STAssertTrue([[scalinator getAdjustedSize:requestedSize] isEqualToNumber:expectedAdjustedSize], 
                 @"Scaling didn't occur as planned. Wrong result");
    
}


- (void)testSlightlyMoreComplicatedScaleThatRequiresMatchingPrecision
{
    scalinator.actualSize = [NSDecimalNumber decimalNumberWithString:@"8.5"];
    scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:@"255.5"];

    NSDecimalNumber *expectedAdjustedSize = [NSDecimalNumber decimalNumberWithString:@"360.7"];
    NSDecimalNumber *requestedSize = [NSDecimalNumber decimalNumberWithString:@"12"];
    NSDecimalNumber *actualAdjustedSize = [scalinator getAdjustedSize:requestedSize];

    STAssertTrue([actualAdjustedSize isEqualToNumber:expectedAdjustedSize], 
                 [NSString stringWithFormat:
                    @"Scaling didn't occur as planned. Wrong result. Got %@; Expected %@",
                    actualAdjustedSize, expectedAdjustedSize]
                 );
}

- (void)testCanScaleCGRectProperly
{
    scalinator.actualSize = [NSDecimalNumber decimalNumberWithString:@"8.5"];
    scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:@"17.0"];
    float expectedAdjustedWidth = 22.0;
    float expectedAdjustedHeight = 17.0;
    CGRect startingFrame = CGRectMake(0, 0, 11, 8.5);
    CGRect newFrame = [scalinator getAdjustedFrame:startingFrame];
    STAssertTrue(newFrame.size.width == expectedAdjustedWidth, 
                 [NSString stringWithFormat:@"Scaled frame width doesn't match expected. Got %f", newFrame.size.width]);
    STAssertTrue(newFrame.size.height == expectedAdjustedHeight, 
                 [NSString stringWithFormat:@"Scaled frame height doesn't match expected. Got %f", newFrame.size.height]);    
}


@end
