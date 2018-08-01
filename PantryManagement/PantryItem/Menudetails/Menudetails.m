//
//  Menudetails.m
//  @TCS
//
//  Created by FNSPL on 08/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "Menudetails.h"

static Menudetails *sharedMenudetails;

@implementation Menudetails

+(Menudetails *)sharedMenudetails
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMenudetails=[[Menudetails alloc] init];
    });
    
    return sharedMenudetails;
}

@end
