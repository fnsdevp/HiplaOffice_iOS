//
//  DynamicUIAnimation.m
//  SmartOffice
//
//  Created by FNSPL on 09/01/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "DynamicUIAnimation.h"

@implementation DynamicUIAnimation


-(instancetype)initWithItems:(NSArray *)items {
    
    if (!(self = [super init])) return nil;
    
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:items];
    gravityBehavior.magnitude = 0.5;
    [self addChildBehavior:gravityBehavior];
    
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self addChildBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    elasticityBehavior.elasticity = 0.8f;
    [self addChildBehavior:elasticityBehavior];
    
    return self;
    
}

@end
