//
//  VersionManager.m
//  precapture
//
//  Created by Randy Crafton on 7/28/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "VersionManager.h"
#import "Collections.h"
#import "Collection.h"
#import "CollectionImage.h"
#import "CollectionFramedImage.h"
#import "CollectionInstallationManager.h"
@implementation VersionManager

@synthesize docDir;

+ (void) performUpdates
{
    VersionManager *vm = [[VersionManager alloc] init];

    
    [vm performUpdatesFor1_1];
    [vm performUpdatesFor1_2];
    [vm performUpdatesFor1_3];
    [vm performUpdatesFor1_4];
    [vm performUpdatesFor4_1];
}

- (void) performUpdatesFor1_1
{
    [self setDocDir];

    if ([[NSFileManager defaultManager] fileExistsAtPath:[docDir stringByAppendingPathComponent:@"1_1.txt"]] == NO) {
        NSLog(@"Performing update to 1.1");
        Collections *collections = [[Collections alloc] init];
        [collections loadCollectionsFromUserDocuments];
        NSEnumerator *e = [collections.allCollections objectEnumerator];
        Collection *currentCollection;
        while (currentCollection = [e nextObject]) {
            if ([currentCollection.file_name isEqualToString:@"0010.txt"]) {
                if ([currentCollection.name isEqualToString:@"Single 24x16 Image"]) {
                    currentCollection.file_name = @"0012.txt";
                    currentCollection.order = @"33";
                    currentCollection.free = @"YES";
                } else {
                    currentCollection.free = @"YES";
                    currentCollection.order = @"10";
                }
            } else if ([currentCollection.file_name isEqualToString:@"0001.txt"]) {
                currentCollection.order = @"1";
            } else if ([currentCollection.file_name isEqualToString:@"0002.txt"]) {
                currentCollection.order = @"2";
            } else if ([currentCollection.file_name isEqualToString:@"0003.txt"]) {
                currentCollection.order = @"3";
            } else if ([currentCollection.file_name isEqualToString:@"0004.txt"]) {
                currentCollection.order = @"4";
            } else if ([currentCollection.file_name isEqualToString:@"0005.txt"]) {
                currentCollection.order = @"5";
            } else if ([currentCollection.file_name isEqualToString:@"0006.txt"]) {
                currentCollection.order = @"6";
                currentCollection.free = @"YES";
            } else if ([currentCollection.file_name isEqualToString:@"0007.txt"]) {
                currentCollection.order = @"90";
                currentCollection.free = @"YES";
            }/* else if ([currentCollection.file_name isEqualToString:@"0008.txt"]) {
                currentCollection.order = @"270";
                currentCollection.free = @"YES";
            }*/ else if ([currentCollection.file_name isEqualToString:@"0009.txt"]) {
                currentCollection.order = @"9";
                currentCollection.free = @"YES";
            } else if ([currentCollection.file_name isEqualToString:@"0011.txt"]) {
                currentCollection.order = @"110";
            } else if ([currentCollection.file_name isEqualToString:@"0012.txt"]) {
                currentCollection.order = @"120";
            } else if ([currentCollection.file_name isEqualToString:@"0013.txt"]) {
                currentCollection.order = @"160";
            } else if ([currentCollection.file_name isEqualToString:@"0014.txt"]) {
                currentCollection.order = @"200";
            } else if ([currentCollection.file_name isEqualToString:@"0015.txt"]) {
                currentCollection.order = @"220";
            } else if ([currentCollection.file_name isEqualToString:@"0016.txt"]) {
                currentCollection.order = @"390";
            } else if ([currentCollection.file_name isEqualToString:@"0017.txt"]) {
                currentCollection.order = @"400";
            } else if ([currentCollection.file_name isEqualToString:@"0018.txt"]) {
                currentCollection.order = @"440";
            } else if ([currentCollection.file_name isEqualToString:@"0019.txt"]) {
                currentCollection.order = @"480";
            } else if ([currentCollection.file_name isEqualToString:@"0020.txt"]) {
                currentCollection.order = @"500";
            } else if ([currentCollection.file_name isEqualToString:@"BP_ClassicTriptych.txt"]) {
                currentCollection.order = @"11";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Filmstrip.txt"]) {
                currentCollection.order = @"12";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Flagstone.txt"]) {
                currentCollection.order = @"13";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FormalFour.txt"]) {
                currentCollection.order = @"14";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FourSquare12.txt"]) {
                currentCollection.order = @"15";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FourSquare16.txt"]) {
                currentCollection.order = @"16";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FourSquare20.txt"]) {
                currentCollection.order = @"17";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Modern.txt"]) {
                currentCollection.order = @"18";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Parquet.txt"]) {
                currentCollection.order = @"19";
            } else if ([currentCollection.file_name isEqualToString:@"BP_RectTriptych12.txt"]) {
                currentCollection.order = @"20";
            } else if ([currentCollection.file_name isEqualToString:@"BP_RectTriptych16.txt"]) {
                currentCollection.order = @"21";
            } else if ([currentCollection.file_name isEqualToString:@"BP_RectTriptych24.txt"]) {
                currentCollection.order = @"22";
            } else if ([currentCollection.file_name isEqualToString:@"BP_SqTriptych12.txt"]) {
                currentCollection.order = @"23";
            } else if ([currentCollection.file_name isEqualToString:@"BP_SqTriptych16.txt"]) {
                currentCollection.order = @"24";
            } else if ([currentCollection.file_name isEqualToString:@"BP_SqTriptych20.txt"]) {
                currentCollection.order = @"25";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Stairclimber.txt"]) {
                currentCollection.order = @"26";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TheBigE.txt"]) {
                currentCollection.order = @"27";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TicTacToe6.txt"]) {
                currentCollection.order = @"28";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TicTacToe9.txt"]) {
                currentCollection.order = @"29";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TicTacToe12.txt"]) {
                currentCollection.order = @"30";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Timeless.txt"]) {
                currentCollection.order = @"31";
            } 
    
            [currentCollection saveToFile];
        }
        [@"YES" writeToFile:[docDir stringByAppendingPathComponent:@"1_1.txt"] 
                                             atomically:NO
                                               encoding:NSStringEncodingConversionAllowLossy
                                                  error:nil];
    }
}

- (void) performUpdatesFor1_2
{
    [self setDocDir];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docDir stringByAppendingPathComponent:@"1_2.txt"]] == NO) {
        NSString *userCollectionsDirectory = [docDir stringByAppendingPathComponent:@"Collections"];
        [[NSFileManager defaultManager] removeItemAtPath:[userCollectionsDirectory stringByAppendingPathComponent:@"0003.txt"] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[userCollectionsDirectory stringByAppendingPathComponent:@"BP_TicTacToe9.txt"] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[userCollectionsDirectory stringByAppendingPathComponent:@"BP_Timeless.txt"] error:nil];
        [CollectionInstallationManager copyCollectionsIfNeeded];
        
        NSLog(@"Performing update to 1.2");
        Collections *collections = [[Collections alloc] init];
        [collections loadCollectionsFromUserDocuments];
        NSEnumerator *e = [collections.allCollections objectEnumerator];
        Collection *currentCollection;
        while (currentCollection = [e nextObject]) {
            // Set default "show" mode to true.
            currentCollection.show = @"1";
            currentCollection.priceDescription = @"Canvas";
            currentCollection.price2Description = @"Metal";
            currentCollection.price3Description = @"Acrylic";
            currentCollection.price4Description = @"Standout";
            // Rearrange these bitches. 
            if ([currentCollection.file_name isEqualToString:@"Ampersand.txt"]) {
                currentCollection.order = @"3";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Bundle1.txt"]) {
                currentCollection.order = @"11";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Bundle2.txt"]) {
                currentCollection.order = @"12";
            } else if ([currentCollection.file_name isEqualToString:@"PD_SquareQuad12.txt"]) {
                currentCollection.order = @"13";
            } else if ([currentCollection.file_name isEqualToString:@"PD_SquareQuad16.txt"]) {
                currentCollection.order = @"14";
            } else if ([currentCollection.file_name isEqualToString:@"PD_SquareQuad20.txt"]) {
                currentCollection.order = @"15";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Triptych1.txt"]) {
                currentCollection.order = @"16";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Triptych2.txt"]) {
                currentCollection.order = @"17";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Triptych3.txt"]) {
                currentCollection.order = @"18";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Triptych4.txt"]) {
                currentCollection.order = @"19";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Triptych5.txt"]) {
                currentCollection.order = @"20";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Triptych6.txt"]) {
                currentCollection.order = @"21";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Windmill1.txt"]) {
                currentCollection.order = @"22";
            } else if ([currentCollection.file_name isEqualToString:@"PD_Windmill2.txt"]) {
                currentCollection.order = @"23";
            } else if ([currentCollection.file_name isEqualToString:@"BP_ClassicTriptych.txt"]) {
                currentCollection.order = @"24";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Filmstrip.txt"]) {
                currentCollection.order = @"25";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Flagstone.txt"]) {
                currentCollection.order = @"26";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FormalFour.txt"]) {
                currentCollection.order = @"27";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FourSquare12.txt"]) {
                currentCollection.order = @"28";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FourSquare16.txt"]) {
                currentCollection.order = @"29";
            } else if ([currentCollection.file_name isEqualToString:@"BP_FourSquare20.txt"]) {
                currentCollection.order = @"30";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Modern.txt"]) {
                currentCollection.order = @"31";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Parquet.txt"]) {
                currentCollection.order = @"32";
            } else if ([currentCollection.file_name isEqualToString:@"BP_RectTriptych12.txt"]) {
                currentCollection.order = @"33";
            } else if ([currentCollection.file_name isEqualToString:@"BP_RectTriptych16.txt"]) {
                currentCollection.order = @"34";
            } else if ([currentCollection.file_name isEqualToString:@"BP_RectTriptych24.txt"]) {
                currentCollection.order = @"35";
            } else if ([currentCollection.file_name isEqualToString:@"BP_SqTriptych12.txt"]) {
                currentCollection.order = @"36";
            } else if ([currentCollection.file_name isEqualToString:@"BP_SqTriptych16.txt"]) {
                currentCollection.order = @"37";
            } else if ([currentCollection.file_name isEqualToString:@"BP_SqTriptych20.txt"]) {
                currentCollection.order = @"38";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Stairclimber.txt"]) {
                currentCollection.order = @"39";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TheBigE.txt"]) {
                currentCollection.order = @"40";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TicTacToe6.txt"]) {
                currentCollection.order = @"41";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TicTacToe10.txt"]) {
                currentCollection.order = @"42";
            } else if ([currentCollection.file_name isEqualToString:@"BP_TicTacToe12.txt"]) {
                currentCollection.order = @"43";
            } else if ([currentCollection.file_name isEqualToString:@"BP_Timeless.txt"]) {
                currentCollection.order = @"44";
            }
            /*
             else if ([currentCollection.file_name isEqualToString:@"A2H.txt"]) {
                currentCollection.order = @"9";
            } else if ([currentCollection.file_name isEqualToString:@"Diamond.txt"]) {
                currentCollection.order = @"10";
            } else if ([currentCollection.file_name isEqualToString:@"Epic.txt"]) {
                currentCollection.order = @"11";
            } else if ([currentCollection.file_name isEqualToString:@"Lupine.txt"]) {
                currentCollection.order = @"12";
            } else if ([currentCollection.file_name isEqualToString:@"Showoff.txt"]) {
                currentCollection.order = @"13";
            } else if ([currentCollection.file_name isEqualToString:@"8x10.txt"]) {
                currentCollection.order = @"1";
            } else if ([currentCollection.file_name isEqualToString:@"11x14.txt"]) {
                currentCollection.order = @"2";
            } else if ([currentCollection.file_name isEqualToString:@"10x20.txt"]) {
                currentCollection.order = @"53";
            } else if ([currentCollection.file_name isEqualToString:@"0011.txt"]) {
                currentCollection.order = @"54";
            } else if ([currentCollection.file_name isEqualToString:@"0012.txt"]) {
                currentCollection.order = @"55";
            } else if ([currentCollection.file_name isEqualToString:@"15x30.txt"]) {
                currentCollection.order = @"56";
            } else if ([currentCollection.file_name isEqualToString:@"0013.txt"]) {
                currentCollection.order = @"57";
            } else if ([currentCollection.file_name isEqualToString:@"0014.txt"]) {
                currentCollection.order = @"58";
            } else if ([currentCollection.file_name isEqualToString:@"0015.txt"]) {
                currentCollection.order = @"59";
            } else if ([currentCollection.file_name isEqualToString:@"8x10Framed.txt"]) {
                currentCollection.order = @"60";
            } else if ([currentCollection.file_name isEqualToString:@"11x14Framed.txt"]) {
                currentCollection.order = @"61";
            } else if ([currentCollection.file_name isEqualToString:@"10x20Framed.txt"]) {
                currentCollection.order = @"62";
            } else if ([currentCollection.file_name isEqualToString:@"0016.txt"]) {
                currentCollection.order = @"63";
            } else if ([currentCollection.file_name isEqualToString:@"0017.txt"]) {
                currentCollection.order = @"64";
            } else if ([currentCollection.file_name isEqualToString:@"15x30Framed.txt"]) {
                currentCollection.order = @"65";
            } else if ([currentCollection.file_name isEqualToString:@"0018.txt"]) {
                currentCollection.order = @"66";
            } else if ([currentCollection.file_name isEqualToString:@"0019.txt"]) {
                currentCollection.order = @"67";
            } else if ([currentCollection.file_name isEqualToString:@"0020.txt"]) {
                currentCollection.order = @"68";
            }
             */
            
            [currentCollection saveToFile];
        }
        [@"YES" writeToFile:[docDir stringByAppendingPathComponent:@"1_2.txt"] 
                                             atomically:NO
                                               encoding:NSStringEncodingConversionAllowLossy
                                                  error:nil];
    }
}

- (void) performUpdatesFor1_3
{
    [self setDocDir];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docDir stringByAppendingPathComponent:@"1_3.txt"]] == NO) {
        NSLog(@"Performing update to 1.3");
        Collections *collections = [[Collections alloc] init];
        [collections loadCollectionsFromUserDocuments];
        NSEnumerator *e = [collections.allCollections objectEnumerator];
        Collection *currentCollection;
        while (currentCollection = [e nextObject]) {
            if ([[currentCollection.file_name substringToIndex:2] isEqualToString:@"BP"]) {
                currentCollection.groupName = @"bayphoto";
            } else if ([[currentCollection.file_name substringToIndex:2] isEqualToString:@"PD"]) {
                currentCollection.groupName = @"prodpi";
            } else if ([currentCollection.type isEqualToString:@"single"]) {
                CollectionImage *image = [currentCollection.imageLayout objectAtIndex:0];
                if ([image class] == [CollectionFramedImage class]) {
                    currentCollection.groupName = @"singlesFramed";
                } else {
                    currentCollection.groupName = @"singles";
                }
            } else if ([[currentCollection.file_name substringToIndex:3] isEqualToString:@"DA_"]) {
                currentCollection.groupName = @"com.chrisandadriennescott.preveal.inspireguide.canvas";
            } else if ([[currentCollection.file_name substringToIndex:3] isEqualToString:@"DA1"]) {
                currentCollection.groupName = kPrevealDA1Name;
            } else {
                currentCollection.groupName = @"preveal";
            }
            [currentCollection saveToFile];
        }
        [@"YES" writeToFile:[docDir stringByAppendingPathComponent:@"1_3.txt"]
                 atomically:NO
                   encoding:NSStringEncodingConversionAllowLossy
                      error:nil];

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSArray *purchasedBundles = [NSArray arrayWithObjects:@"preveal", @"prodpi", @"bayphoto", @"singles", @"singlesFramed", @"favorites", nil];
        [prefs setObject:purchasedBundles forKey:@"purchasedBundles"];
        [prefs synchronize];
    }
}
- (void) performUpdatesFor1_4
{
    [self setDocDir];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docDir stringByAppendingPathComponent:@"1_4.txt"]] == NO) {
        NSLog(@"Performing update to 1.4");
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSArray *purchasedBundles = [prefs objectForKey:@"purchasedBundles"];
        NSArray *newPurchasedBundles = [purchasedBundles arrayByAddingObject:kPrevealMyCollectionsGroupName];
        newPurchasedBundles = [newPurchasedBundles arrayByAddingObject:kPrevealCommunityGroupName];
        [prefs setObject:newPurchasedBundles forKey:@"purchasedBundles"];
        [prefs synchronize];
        
        
        [@"YES" writeToFile:[docDir stringByAppendingPathComponent:@"1_4.txt"]
                 atomically:NO
                   encoding:NSStringEncodingConversionAllowLossy
                      error:nil];

    }
}

- (void) performUpdatesFor4_1
{
    [self setDocDir];
    NSString *versionFile = @"4_1.txt";
    
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docDir stringByAppendingPathComponent:versionFile]] == NO) {
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSArray *purchasedBundles = [prefs objectForKey:@"purchasedBundles"];
        NSString *otherDAGroup = @"com.chrisandadriennescott.preveal.inspireguide.canvas";
        
        NSError *error = nil;
        Collections *collections = [[Collections alloc] init];
        [collections loadCollectionsFromUserDocuments];
        [collections setCurrentGroupName:kPrevealMyCollectionsGroupName error:&error];
        NSUInteger order = [collections.currentGroup count];
        if ([purchasedBundles containsObject:kPrevealDA1Name]) {
            [collections setCurrentGroupName:kPrevealDA1Name error:&error];
            for (Collection *collection in collections.currentGroup) {
                [collection setGroupName:kPrevealMyCollectionsGroupName];
                order++;
                collection.order = [NSString stringWithFormat:@"%lu", order];
                
                [collection saveToFile];
            }
        }
        

        if ([purchasedBundles containsObject:otherDAGroup]) {
            [collections setCurrentGroupName:otherDAGroup error:&error];
            for (Collection *collection in collections.currentGroup) {
                [collection setGroupName:kPrevealMyCollectionsGroupName];
                order++;
                collection.order = [NSString stringWithFormat:@"%lu", order];
                
                [collection saveToFile];
            }
        }
        // Install Collections
        
        [CollectionInstallationManager copyCollectionsIfNeeded];
    }
    


    
    [@"YES" writeToFile:[docDir stringByAppendingPathComponent:versionFile]
             atomically:NO
               encoding:NSStringEncodingConversionAllowLossy
                  error:nil];

    
}


- (NSString *)setDocDir
{
    if (self.docDir == nil) {
        self.docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return self.docDir;
}

@end
