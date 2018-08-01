//
//  ZoneDetection.h
//  @TCS
//
//  Created by FNSPL on 28/04/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MapPin.h"

@class NavigineCore;

@protocol sharedZoneDetectionDelegate
@optional

//-(void)enterZoneWithZoneName:(NSString *)zoneName;
//-(void)exitZoneWithZoneName:(NSString *)zoneName;
- (void) navigationTicker;
@end

@interface ZoneDetection : NSObject 

+(ZoneDetection *) sharedZoneDetection;
- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint;

@property (nonatomic, strong) id <sharedZoneDetectionDelegate> delegate;
@property (nonatomic, strong) NavigineCore *navigineCore;

@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;

@end
