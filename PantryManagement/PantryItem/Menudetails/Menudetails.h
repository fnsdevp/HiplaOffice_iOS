//
//  Menudetails.h
//  @TCS
//
//  Created by FNSPL on 08/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menudetails : NSObject

+(Menudetails *)sharedMenudetails;

@property (nonatomic, strong) NSString* menuId;
@property (nonatomic, strong) NSString* menuName;
@property (nonatomic, strong) NSString* subCcatId;
@property (nonatomic, strong) NSString* subCatName;
@property (nonatomic, assign) NSInteger quantity;

@end
