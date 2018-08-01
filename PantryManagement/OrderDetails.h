//
//  OrderDetails.h
//  @TCS
//
//  Created by fnspl3 on 03/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface OrderDetails : NSObject
+(OrderDetails *)sharedInstanceOrderDetails;

@property (nonatomic, strong) NSMutableArray* addToOrderItems;

@end
