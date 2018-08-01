//
//  NSURLRequest+NSURLRequestSSLY.m
//  @TCS
//
//  Created by FNSPL on 24/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "NSURLRequest+NSURLRequestSSLY.h"

@implementation NSURLRequest (NSURLRequestSSLY)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

@end
