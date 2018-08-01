//
//  Utils.m
//  Entr
//
//  Created by Comantra on 21/09/16.
//  Copyright © 2016 crescentek. All rights reserved.
//

#import "Utils.h"

static Utils *sharedInstance;


@implementation Utils

+(Utils *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance=[[Utils alloc] init];
    });
    
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (NSString *)stringByTrimingWhitespace:(NSString *)str {
    
    NSString *squashed =
    
    [str stringByReplacingOccurrencesOfString:@"[ ]+"
                                    withString:@" "
                                       options:NSRegularExpressionSearch range:NSMakeRange(0, str.length)];
    
    return [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size;
    
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}


#pragma Utility Functions

+(BOOL) isTermsandConditions
{
    if([[self DefaultsValueForKey:@"isTermsandConditions"] boolValue]==YES)
        return YES;
    else
        return  NO;
}

+(BOOL)CheckInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"There is NO internet connection");
        
        return NO;
        
    }
    else
    {
        NSLog(@"There is internet connection");
        
        return YES;
        
    }
}

+(BOOL)isEmailAddress:(NSString *)emailAddress
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailAddress];
}

+(void)showAlertOn:(UIViewController*)sender withTitle:(NSString*)title message:(NSString*)msg
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [sender presentViewController:alert animated:YES completion:nil];
}

+(void)showAlertwithCancelButtonOn:(UIViewController*)sender withTitle:(NSString*)title message:(NSString*)msg
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:msg
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [sender presentViewController:alertController animated:YES completion:nil];
}

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize andOffSet:(CGPoint)offSet{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(offSet.x, offSet.y, newSize.width-offSet.x, newSize.height-offSet.y)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)setDeviceToken:(NSString *)deviceToken
{
    [Userdefaults setObject:deviceToken forKey:@"deviceToken"];
    
    [Userdefaults synchronize];
}

+ (NSString *)deviceToken
{
#if (TARGET_IPHONE_SIMULATOR)
    return @"f79f58021282babc8ecd9d388d772968f586bb5460634aedd61ab20af251de09";
#else
    
    NSLog(@"%@",[Userdefaults objectForKey:@"deviceToken"]);
    
    return [Userdefaults objectForKey:@"deviceToken"];
    
#endif
}


+ (NSString *)deviceType
{
#if (TARGET_IPHONE_SIMULATOR)
    return @"2";
#else
    return @"1";
    
#endif
}

+ (NSString *)devicePlatform
{
    return @"1";
}

+ (void)setDeviceID
{
    [Userdefaults setObject:[self deviceUUID] forKey:@"udid"];
    
    [Userdefaults synchronize];
}

+ (NSString *)deviceUUID
{
    if([Userdefaults objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
        return [Userdefaults objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    @autoreleasepool {
        
        CFUUIDRef uuidReference = CFUUIDCreate(nil);
        CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
        NSString *uuidString = (__bridge NSString *)(stringReference);
        [Userdefaults setObject:uuidString forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [Userdefaults synchronize];
        
        CFRelease(uuidReference);
        CFRelease(stringReference);
        
        return uuidString;
    }
}

+ (void)removeDeviceUUID
{
    [Userdefaults removeObjectForKey:@"udid"];
    [Userdefaults synchronize];
}



#pragma mark- USERDEFAULTS

+(void)setDefaultsWithValue:(id)value andKey:(NSString*)key
{
    [Userdefaults setObject:value forKey:key];
    [Userdefaults synchronize];
}

+(void)setDefaultsWithIntValue:(int)intvalue andKey:(NSString*)key
{
    [Userdefaults setInteger:intvalue forKey:key];
    [Userdefaults synchronize];
}

+(void)setDefaultsWithFloatValue:(float)fvalue andKey:(NSString*)key
{
    [Userdefaults setFloat:fvalue forKey:key];
    [Userdefaults synchronize];
}


+(void)setDefaultsWithboolValue:(BOOL)bvalue andKey:(NSString*)key
{
    [Userdefaults setBool:bvalue forKey:key];
    [Userdefaults synchronize];
}

+(int)DefaultsIntForKey:(NSString*)key
{
    int intvalue = (int)[Userdefaults integerForKey:key];
    
    return intvalue;
}

+(float)DefaultsFloatForKey:(NSString*)key
{
    float fvalue = [Userdefaults floatForKey:key];
    
    return fvalue;
}

+(id)DefaultsValueForKey:(NSString*)key
{
    id value = [Userdefaults valueForKey:key];
    
    return value;
}

+(BOOL)DefaultsBoolForKey:(NSString*)key
{
    BOOL value = [Userdefaults boolForKey:key];
    
    return value;
}

+(void)removeDefaultsValueForKey:(NSString*)key
{
    [Userdefaults removeObjectForKey:key];
    [Userdefaults synchronize];
}

-(NSString *)RemoveSpecialCaracter:(NSString *)inputstring
{
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    
    NSString *resultString = [[inputstring componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    NSLog (@"Result: %@", resultString);
    
    return resultString;
}

-(NSString *)RemoveSpecialCaracterFromInteger:(NSString *)inputstring
{
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    
    NSString *resultString = [[inputstring componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    NSLog (@"Result: %@", resultString);
    
    return resultString;
}

+(void)parseAndStoreCountries
{
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    
    // NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // NSLog(@"%@",responseString);
    
    // NSError *error;
    
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    
    NSMutableArray *arrCountries = [[NSMutableArray alloc] initWithArray:(NSArray *)jsonObject];
    
    
    //    SBJsonParser *jsonParser = [SBJsonParser new];
    //    NSMutableArray *arrCountries = [[NSMutableArray alloc] initWithArray:(NSArray *)[jsonParser objectWithString:responseString error:&error]];
    
    
    [Utils setDefaultsWithValue:arrCountries andKey:@"countries"];
    
    [Userdefaults setObject:arrCountries forKey:@"countries"];
    
    [Userdefaults synchronize];
    
}

+ (NSString *)timeFormatted:(int)totalSeconds
{
    int minutes = (totalSeconds / 60) % 60;
    int hours = (totalSeconds / 3600) % 24;
    int days = (totalSeconds / (3600 * 24));
    
    if (days == 0) {
        return [NSString stringWithFormat:@"%d hours, %d mins.", hours, minutes];
    }
    else
    {
        return [NSString stringWithFormat:@"%d days, %d hours, %d mins.", days, hours, minutes];
    }
}

+ (NSString*) getValidDay:(long)secs
{
    long day = (double)(secs / 3600) / 24;
    int offset = secs % (3600 * 24);
    
    if (offset > 0)
    {
        day = day + 1;
    }
    
    if(day > 0)
    {
        if((int)day == 1)
        {
            return [NSString stringWithFormat:@"%ld day", day];
        }
        
        return [NSString stringWithFormat:@"%ld days", day];
    }
    
    return nil;
}


#pragma mark - HUD

//- (void)showCommonHud
//{
//    [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] animated:YES];
//}
//
//
//-(void)hideCommonHud
//{
//    [MBProgressHUD hideHUDForView:[APPDELEGATE window] animated:YES];
//}


#pragma mark-
#pragma mark  Get Nib Name

-(NSString*)getNibName:(NSString*)OriginalnibName
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        return [NSString stringWithFormat:@"%@_iPad",OriginalnibName];
    }
    else
    {
        return [NSString stringWithFormat:@"%@_iPhone",OriginalnibName];
    }
}


-(IBAction)buttonActionTouchDown:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    self.selectedButtonTag = (int)btn.tag;
}

#pragma mark-
#pragma mark  Device Types Related

-(BOOL)isiPad
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad);
}

+(BOOL) isiPadPro
{
    
    if ([UIScreen mainScreen].bounds.size.height == 1366)
    {
        return  YES;
    }
    
    return NO;
}

+(BOOL) isiPad
{
    
    if ([UIScreen mainScreen].bounds.size.height == 1024)
    {
        return  YES;
    }
    
    return NO;
}


#pragma mark-
#pragma mark  Null String Exception Handel
-(BOOL)isNullString:(NSString*)_inputString
{
    NSString *InputString=@"";
    
    InputString=[NSString stringWithFormat:@"%@",_inputString];
    
    if((InputString == nil) ||(InputString ==(NSString *)[NSNull null])||([InputString isEqual:nil])||([InputString isKindOfClass:[NSNull class]])||([InputString length] == 0)||[allTrim( InputString ) length] == 0||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])||([InputString isEqualToString:@""])))
        
        return YES;
    
    else
        
        return NO ;
    
}

-(NSString *)checkNullStringAndReplace:(NSString*)_inputString
{
    NSString *InputString=@"";
    
    InputString=[NSString stringWithFormat:@"%@",_inputString];
    
    if((InputString == nil) ||(InputString ==(NSString *)[NSNull null])||([InputString isEqual:nil])||([InputString isKindOfClass:[NSNull class]])||([InputString length] == 0)||[allTrim( InputString ) length] == 0||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])||([InputString isEqualToString:@""])))
        
        return @"";
    
    else
        
        return _inputString ;
    
}


#pragma mark- Show/Hide Toast View

//Show toast message and desolve automatically
-(void)showTost:(BOOL)show onView:(UIView *)Vw message:(NSString *)message animated:(BOOL)animated
{
    if (show)
    {
        if (!self.tostView)
        {
            UIView *networktostView = [[UIView alloc] init];
            
            if (SCREENHEIGHT==480)
            {
                networktostView.frame = CGRectMake(20, Vw.bounds.size.height-250, [UIScreen mainScreen].bounds.size.width-40, 50);
            }
            else if (SCREENHEIGHT==568)
            {
                networktostView.frame = CGRectMake(20, Vw.bounds.size.height-250, [UIScreen mainScreen].bounds.size.width-40, 50);
            }
            else if ([self isiPad])
            {
                networktostView.frame = CGRectMake(20, Vw.bounds.size.height-500, [UIScreen mainScreen].bounds.size.width-40, 50);
            }
            else
            {
                networktostView.frame = CGRectMake(20, Vw.bounds.size.height-350, [UIScreen mainScreen].bounds.size.width-40, 50);
            }
            
            networktostView.backgroundColor = [UIColor blackColor];
            
            //   networktostView.layer.borderColor = [UIColor whiteColor].CGColor;
            //   networktostView.layer.borderWidth = 1.0f;
            
            UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
            [window addSubview:networktostView];
            networktostView.alpha = 0.0f;
            self.tostView=networktostView;
            
            UILabel *mesgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.tostView.frame.size.width-10, self.tostView.frame.size.height-10)];
            mesgLabel.font = [self isiPad]?FONT_REGULAR(22.0):FONT_REGULAR(15.0);
            mesgLabel.textColor = [UIColor whiteColor];
            mesgLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mesgLabel.numberOfLines = 20;
            mesgLabel.backgroundColor = [UIColor clearColor];
            mesgLabel.textAlignment = NSTextAlignmentCenter;
            [self.tostView addSubview:mesgLabel];
            self.tostLabel=mesgLabel;
        }
        
        self.tostView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width-40, 40);
        self.tostLabel.frame = CGRectMake(5, 5, self.tostView.frame.size.width-10, self.tostView.frame.size.height-10);
        
        CGSize size = [self getLabelSizeFortext:message forWidth:self.tostLabel.frame.size.width WithFont:self.tostLabel.font];
        self.tostView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-(size.width+40))/2, [UIScreen mainScreen].bounds.size.height-((size.height+20+40)), size.width+40, size.height+10);
        self.tostLabel.frame = CGRectMake(20, 5, self.tostView.frame.size.width-40, self.tostView.frame.size.height-10);
        self.tostLabel.text = message;
        self.tostView.layer.cornerRadius = 5;//self.tostView.frame.size.height/2;
        if (animated) {
            [UIView animateWithDuration:0.4 animations:^{
                self.tostView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showTost:NO onView:Vw message:@"" animated:animated];
                });
            }];
        }
        else {
            self.tostView.alpha = 1.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTost:NO onView:Vw message:@"" animated:animated];
            });
        }
    }
    else {
        if (animated) {
            [UIView animateWithDuration:0.4 animations:^{
                self.tostView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
            }];
        }
        else {
            self.tostView.alpha = 0.0f;
        }
    }
}


-(void)showToast:(BOOL)show onView:(UIView *)Vw message:(NSString *)message animated:(BOOL)animated
{
    if (show)
    {
        if (!self.tostView)
        {
            UIView *networktostView = [[UIView alloc] init];
            
            networktostView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width-40, 50);
            
            networktostView.backgroundColor = [UIColor blackColor];
            
            //   networktostView.layer.borderColor = [UIColor whiteColor].CGColor;
            //   networktostView.layer.borderWidth = 1.0f;
            
            UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
            [window addSubview:networktostView];
            
            networktostView.alpha = 0.0f;
            
            self.tostView=networktostView;
            
            UILabel *mesgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.tostView.frame.size.width-10, self.tostView.frame.size.height-10)];
            mesgLabel.font = [self isiPad]?FONT_REGULAR(22.0):FONT_REGULAR(15.0);
            mesgLabel.textColor = [UIColor whiteColor];
            mesgLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mesgLabel.numberOfLines = 20;
            mesgLabel.backgroundColor = [UIColor clearColor];
            mesgLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.tostView addSubview:mesgLabel];
            self.tostLabel=mesgLabel;
        }
        
        self.tostView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width-40, 40);
        self.tostLabel.frame = CGRectMake(5, 5, self.tostView.frame.size.width-10, self.tostView.frame.size.height-10);
        
        CGSize size = [self getLabelSizeFortext:message forWidth:self.tostLabel.frame.size.width WithFont:self.tostLabel.font];
        self.tostView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-(size.width+40))/2, [UIScreen mainScreen].bounds.size.height-(size.height+160), size.width+40, size.height+25);
        self.tostLabel.frame = CGRectMake(20, 10, self.tostView.frame.size.width-40, self.tostView.frame.size.height-25);
        self.tostLabel.text = message;
        self.tostView.layer.cornerRadius = 5;//self.tostView.frame.size.height/2;
        
        if (animated) {
            
            [UIView animateWithDuration:0.4 animations:^{
                
                self.tostView.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showTost:NO onView:Vw message:@"" animated:animated];
                });
            }];
            
        }
        else {
            self.tostView.alpha = 1.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTost:NO onView:Vw message:@"" animated:animated];
            });
        }
    }
    else {
        if (animated) {
            [UIView animateWithDuration:0.4 animations:^{
                self.tostView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
            }];
        }
        else {
            self.tostView.alpha = 0.0f;
        }
    }
}


-(CGSize)getLabelSizeFortext:(NSString *)text forWidth:(float)width WithFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    // Get the size of the text given the CGSize we just made as a constraint
    
    CGRect titleRect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil];
    return titleRect.size;
    
}

//Returns the message size
-(CGSize)getLabelSizeFortext:(NSString *)text forHeight:(float)height WithFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(MAXFLOAT, height);
    // Get the size of the text given the CGSize we just made as a constraint
    
    CGRect titleRect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil];
    
    return titleRect.size;
}

-(void)createAnimationForViewAppear:(UIView *)view animationType:(NSString*)type animationSubtype:(NSString*)subtype withTimeInterval:(float )time previousView:(UIView *)pview{
    [view.layer removeAllAnimations];
    CATransition *transition = [CATransition animation];
    transition.type = type;
    transition.subtype = subtype;
    transition.duration = time;
    transition.delegate=self;
    [view.layer addAnimation:transition forKey:nil];
    view.hidden=NO;
    [pview.layer addAnimation:transition forKey:nil];
    pview.hidden=YES;
}

-(void)createAnimationForViewDisAppear:(UIView *)view animationType:(NSString*)type animationSubtype:(NSString*)subtype withTimeInterval:(float )time{
    [view.layer removeAllAnimations];
    CATransition *transition = [CATransition animation];
    transition.type = type;
    transition.subtype = subtype;
    transition.duration = time;
    transition.delegate=self;
    [view.layer addAnimation:transition forKey:nil];
    view.hidden=YES;
}


@end
