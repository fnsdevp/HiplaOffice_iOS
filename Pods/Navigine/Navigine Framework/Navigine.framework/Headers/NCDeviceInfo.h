//
//  NCDeviceInfo.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 29/03/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCLocationPoint.h"
#import "NCGlobalPoint.h"
#import "NCZone.h"


typedef NS_ENUM(NSInteger, NCNavigationError) {
  NCIncorrectClient    = 1,
  NCNoSolution         = 4,
  NCNoBeacons          = 8,
  NCIncorrectBMP       = 10,
  NCIncorrectGP        = 20,
  NCIncorrectXMLParams = 21
};

@interface NCDeviceInfo : NSObject <NSCoding>
@property (nonatomic, strong, nonnull) NSString *id;
@property (nonatomic, strong, nonnull) NSDate *time;
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, assign) NSInteger sublocation;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float kx;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float ky;
@property (nonatomic, assign) float r;
@property (nonatomic, assign) float azimuth;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong, nullable) NSArray *paths;
@property (nonatomic, strong, nullable) NSArray *zones;
@property (nonatomic, strong, nullable) NSError *error;

@property (nonatomic, strong, readonly, nullable) NCLocationPoint *locationPoint;
@property (nonatomic, strong, readonly, nullable) NCGlobalPoint   *globalPoint;

- (BOOL) isInsideZoneWithId:    (NSInteger) id;
- (BOOL) isInsideZoneWithAlias: (NSString *) alias;

- (BOOL) isValid;

@end
