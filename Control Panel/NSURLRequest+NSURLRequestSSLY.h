//
//  NSURLRequest+NSURLRequestSSLY.h
//  @TCS
//
//  Created by FNSPL on 24/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (NSURLRequestSSLY)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

@end
