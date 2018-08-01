//
//  APIManager.h
//  Jing
//
//  Created by FNSPL on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface APIManager : NSURLSession<NSURLSessionDelegate>

+(APIManager *) sharedManager;

-(void)ApiRequestPOSTwithParameters:(NSDictionary *)param WithUrlLastPart:(NSString *)lastUrl completion:(void (^)(NSDictionary *, NSError *))completion;

-(void)ApiRequestGETwithParameters:(NSDictionary *)param WithUrlLastPart:(NSString *)lastUrl completion:(void (^)(NSDictionary *, NSError *))completion;

-(void)ApiRequestPOSTwithPostdata:(NSData *)postData WithUrlLastPart:(NSString *)lastUrl completion:(void (^)(NSDictionary *, NSError *))completion;

@end
