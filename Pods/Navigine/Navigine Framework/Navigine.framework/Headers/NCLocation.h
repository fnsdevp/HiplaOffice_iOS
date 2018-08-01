//
//  NCLocation.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 11/03/15.
//  Copyright (c) 2015 Navigine. All rights reserved.
//

#import "NCSublocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCLocation :NSObject<NSCoding>

/**
 *  Location id in personal account
 */
@property (nonatomic, assign) NSInteger      id;

/**
 *  Location name in personal account
 */
@property (nonatomic, copy)   NSString       *name;

/**
 *  Location description in personal account
 */
@property (nonatomic, copy)   NSString       *localDescription;

/**
 *  Archive version
 */
@property (nonatomic, assign) NSInteger      version;

/**
 *  Array with sublocations of your location
 */
@property (nonatomic, strong) NSMutableArray *sublocations;

/**
*  Is local modified Archive
*/
@property (nonatomic, assign, readonly) BOOL modified;

- (id) initWithLocation :(NCLocation *)location;

/**
 *  Function is used for getting sublocation at id or nil error
 *
 *  @param id 
 *
 *  @return Sublocation object or nil
 */
- (NCSublocation *_Nullable) subLocationWithId: (NSInteger) id;

- (NCZone *_Nullable) zoneWithId: (NSInteger) id;

- (NSArray<NCZone *> *) zonesContainingPoint: (NCLocalPoint *) point;

- (BOOL) isValid;
@end

NS_ASSUME_NONNULL_END
