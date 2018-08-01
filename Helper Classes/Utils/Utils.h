//
//  Utils.h
//  Entr
//
//  Created by Comantra on 21/09/16.
//  Copyright © 2016 crescentek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "Constants.h"

@interface Utils : NSObject<CAAnimationDelegate>

+(Utils *)sharedInstance;

//Utility functions

+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width;

+ (BOOL)isEmailAddress:(NSString *)emailAddress;
+(void)showAlertOn:(UIViewController*)sender withTitle:(NSString*)title message:(NSString*)msg;
+(void)showAlertwithCancelButtonOn:(UIViewController*)sender withTitle:(NSString*)title message:(NSString*)msg;
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize andOffSet:(CGPoint)offSet;
+ (void)setDeviceToken:(NSString *)deviceToken;
+ (NSString *)deviceToken;
+ (NSString *)deviceType;
+ (NSString *)devicePlatform;
+ (void)setDeviceID;
+ (NSString *)deviceUUID;
+ (void)removeDeviceUUID;
+(void)setDefaultsWithFloatValue:(float)fvalue andKey:(NSString*)key;
+(void)setDefaultsWithIntValue:(int)intvalue andKey:(NSString*)key;
+(void)setDefaultsWithValue:(id)value andKey:(NSString*)key;
+(void)setDefaultsWithboolValue:(BOOL)bvalue andKey:(NSString*)key;
+(int)DefaultsIntForKey:(NSString*)key;
+(float)DefaultsFloatForKey:(NSString*)key;
+(id)DefaultsValueForKey:(NSString*)key;
+(BOOL)DefaultsBoolForKey:(NSString*)key;
+(void)removeDefaultsValueForKey:(NSString*)key;
+(void)parseAndStoreCountries;
+ (NSString *)timeFormatted:(int)totalSeconds;
+ (NSString*) getValidDay:(long)secs;
-(NSString*)getNibName:(NSString*)OriginalnibName;
+(BOOL)CheckInternet;
+(NSString *)stringByTrimingWhitespace:(NSString *)str;

/** Toast View */
@property (nonatomic, weak) UIView *tostView;
@property (nonatomic, weak) UILabel *tostLabel;
@property (nonatomic, readwrite) BOOL canOpenDrawer;
@property (nonatomic, readwrite) BOOL isLandscape;
/** Toast View */

@property (nonatomic, readwrite) int selectedButtonTag;

//HUD
- (void)showCommonHud;
-(void)hideCommonHud;

-(BOOL)isiPad;
+(BOOL) isiPadPro;
+(BOOL) isiPad;
+(BOOL) isTermsandConditions;

//For null checking of a string
-(BOOL)isNullString:(NSString*)_inputString;
-(NSString *)checkNullStringAndReplace:(NSString*)_inputString;

//Show toastview
-(void)showTost:(BOOL)show onView:(UIView *)Vw message:(NSString *)message animated:(BOOL)animated;

-(void)showToast:(BOOL)show onView:(UIView *)Vw message:(NSString *)message animated:(BOOL)animated;

-(NSString *)RemoveSpecialCaracter:(NSString *)inputstring;
-(NSString *)RemoveSpecialCaracterFromInteger:(NSString *)inputstring;

-(IBAction)buttonActionTouchDown:(id)sender;


-(CGSize)getLabelSizeFortext:(NSString *)text forHeight:(float)height WithFont:(UIFont *)font;
-(CGSize)getLabelSizeFortext:(NSString *)text forWidth:(float)width WithFont:(UIFont *)font;

-(void)createAnimationForViewAppear:(UIView *)view animationType:(NSString*)type animationSubtype:(NSString*)subtype withTimeInterval:(float )time previousView:(UIView *)pview;

-(void)createAnimationForViewDisAppear:(UIView *)view animationType:(NSString*)type animationSubtype:(NSString*)subtype withTimeInterval:(float )time;

@end
