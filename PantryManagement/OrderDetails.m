//
//  OrderDetails.m
//  @TCS
//
//  Created by fnspl3 on 03/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "OrderDetails.h"
static OrderDetails *sharedInstanceOrderDetails;

@implementation OrderDetails

+(OrderDetails *)sharedInstanceCartDetails
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstanceOrderDetails=[[OrderDetails alloc] init];
    });
    
    return sharedInstanceOrderDetails;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.addToOrderItems = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
