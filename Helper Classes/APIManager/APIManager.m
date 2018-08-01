//
//  APIManager.m
//  Jing
//
//  Created by FNSPL on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "APIManager.h"

static APIManager *sharedApi = nil;


@implementation APIManager

+(APIManager *) sharedManager {
    
    @synchronized([APIManager class])
    {
        if (!sharedApi)
            sharedApi = [[self alloc] init];
        
        return sharedApi;
    }
    
    return nil;
    
}


- (NSURLSession *)createSession
{
    static NSURLSession *session = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    
    
    return session;

}



-(void)ApiRequestPOSTwithParameters:(NSDictionary *)param WithUrlLastPart:(NSString *)lastUrl completion:(void (^)(NSDictionary *, NSError *))completion {

    NSError *error;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,lastUrl]];

    NSLog(@"url====%@",url);

    NSDictionary *mapData = [[NSDictionary alloc] initWithDictionary:param];

    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:60.0];

   // [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   // [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];

   // [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
   // [request addValue:@"text/html" forHTTPHeaderField:@"Accept"];

    [request setHTTPMethod:@"POST"];
//     [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:YES];

    [request setHTTPBody:postData];


    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSLog(@"RESPONSE: %@",response);
        NSLog(@"DATA: %@",data);

        if (!error) {
            // convert the NSData response to a dictionary
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                // there was a parse error...maybe log it here, too
                completion(nil, error);
            } else {
                // success!
                completion(dictionary, nil);
            }
        } else {
            // error from the session...maybe log it here, too
            completion(nil, error);
        }

    }];

    [postDataTask resume];

}


-(void)ApiRequestPOSTwithPostdata:(NSData *)postData WithUrlLastPart:(NSString *)lastUrl completion:(void (^)(NSDictionary *, NSError *))completion {

    //NSError *error;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,lastUrl]];

    NSLog(@"url====%@",url);

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];

    [urlRequest setHTTPMethod:@"POST"];
    //Apply the data to the body
    [urlRequest setHTTPBody:postData];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSLog(@"RESPONSE: %@",response);
        NSLog(@"DATA: %@",data);

        if (!error) {
            // convert the NSData response to a dictionary
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

            if (error) {
                // there was a parse error...maybe log it here, too
                completion(nil, error);
            } else {
                // success!
                completion(dictionary, nil);
            }

        } else {
            // error from the session...maybe log it here, too
            completion(nil, error);
        }

    }];

    [dataTask resume];


}


-(void)ApiRequestGETwithParameters:(NSDictionary *)param WithUrlLastPart:(NSString *)lastUrl completion:(void (^)(NSDictionary *, NSError *))completion {

    NSError *error;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASE_URL,lastUrl]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [request setHTTPMethod:@"GET"];

    NSDictionary *mapData = [[NSDictionary alloc] initWithDictionary:param];

    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];

    [request setHTTPBody:postData];


    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error) {
            // convert the NSData response to a dictionary
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                // there was a parse error...maybe log it here, too
                completion(nil, error);
            } else {
                // success!
                completion(dictionary, nil);
            }
        } else {
            // error from the session...maybe log it here, too
            completion(nil, error);
        }

    }];

    [postDataTask resume];

}


@end
