//
//  ControlPanelViewController.m
//  @TCS
//
//  Created by FNSPL on 17/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "ControlPanelViewController.h"

@interface ControlPanelViewController ()

@end


@implementation ControlPanelViewController



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    [self setNeedsStatusBarAppearanceUpdate];
    
    
}
- (void)viewDidLoad {
    
//    [super viewDidLoad];
    
        [self setNeedsStatusBarAppearanceUpdate];

    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    _array_UserName = [NSMutableArray arrayWithObjects:@"guest1", nil];
    
    _array_Password = [NSMutableArray arrayWithObjects:@"fnspl123", nil];

    
    self.detailsVw.layer.borderColor = [UIColor blackColor].CGColor;
    self.detailsVw.layer.borderWidth = 1.0;
    
   // [self generateICEDetails:@"sourav" withPassword:@"Cisco2018"];
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
    [self.buttonOpenDoor setEnabled:NO];
    [self.buttonOpenDoor setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.btnAction_Reconnect setEnabled:NO];
    [self.btnAction_Reconnect setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
#pragma mark - Code Added
    
    UIDevice *device = [UIDevice currentDevice];
    
    currentDeviceId = [[device identifierForVendor]UUIDString];
    
    
    currentDeviceId=[currentDeviceId substringToIndex:10];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeOpenedOneBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [SVProgressHUD showWithStatus:@"Connecting..."];

    [self sessionclose];

    [self connectToMQTT];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    self.namelbl.text = [NSString stringWithFormat:@"Name: %@ %@",[userDict objectForKey:@"fname"],[userDict objectForKey:@"lname"]];
    
    self.designationlbl.text = [NSString stringWithFormat:@"Designation: %@",[userDict objectForKey:@"designation"]];
    
    self.departmentlbl.text = [NSString stringWithFormat:@"Department: %@",[userDict objectForKey:@"department"]];
    
    self.companylbl.text = [NSString stringWithFormat:@"Company: %@",[userDict objectForKey:@"company"]];
    
    self.profPicImg.layer.cornerRadius = self.profPicImg.frame.size.width / 2;
    self.profPicImg.clipsToBounds = YES;
    
    [self getRandomNumberFromArrayUsername:_array_UserName];
    
    self.wifiPasswordlbl.text = [NSString stringWithFormat:@"WiFi Password: ******"];
    
    [Userdefaults setObject:@"NO" forKey:@"isVisible"];
    
    [Userdefaults setBool:NO forKey:@"isPreConference"];
    
    [Userdefaults setBool:NO forKey:@"isConnectionDone"];
    
    [Userdefaults synchronize];
    
    [self.btnVisibilityPassword setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    
    [self.buttonOpenDoor setEnabled:NO];
    [self.btnAction_Reconnect setEnabled:NO];
    
    [self sessionclose];

    [self connectToMQTT];
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    [self performSelector:@selector(checkMeetingDetails:) withObject:userDict afterDelay:0.5];
    
    [SVProgressHUD show];
    
    [self getZone];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _navigineCore = nil;
    
    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
    
    [session close];
    
}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}


-(void)getRandomNumberFromArrayUsername:(NSMutableArray *)user{
    
    //int index = arc4random() % user.count;
    self.wifiUserNamelbl.text = [NSString stringWithFormat:@"WiFi Username: %@",[user objectAtIndex:0]];
    
}

-(void)getRandomNumberFromArrayPassword:(NSMutableArray *)pass{
    
    //int index = arc4random() % pass.count;
    self.wifiPasswordlbl.text = [NSString stringWithFormat:@"WiFi Password: %@",[pass objectAtIndex:0]];
}


-(void)checkMeetingDetails:(NSDictionary *)dict
{
    self.btnBack.userInteractionEnabled = NO ;
    
    //    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
    //
    //    if (within400Meter)
    //    {
    //        [[ZoneDetection sharedZoneDetection] setDelegate:self];
    //    }
    
    //    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[dict objectForKey:@"profile_image"]]];
    //
    //    UIImage *image = [UIImage imageWithData: imageData];
    //
    //    self.profPicImg.image = [UIImage imageWithCGImage:[image CGImage] scale:2.0 orientation:UIImageOrientationUp];
    
    NSString *usertype = [NSString stringWithFormat:@"%@",[dict objectForKey:@"usertype"]];
    
    [self.profPicImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@"user"]];
    
    if ([usertype isEqualToString:@"Employee"]) {
        
        if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours]) {
            
            [SVProgressHUD dismiss];
            
            self.btnBack.userInteractionEnabled = YES;
            
            NSDictionary *meetingDetail = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
            
            self.locationlbl.text = [NSString stringWithFormat:@"Location: %@",[meetingDetail objectForKey:@"location"]];
            
            self.meetingTimelbl.text = [NSString stringWithFormat:@"Meeting Time: %@ - %@",[meetingDetail objectForKey:@"fromtime"],[meetingDetail objectForKey:@"totime"]];
            
            NSDictionary *guest = [meetingDetail objectForKey:@"guest"];
            
            self.meetingWithlbl.text = [NSString stringWithFormat:@"Meeting With: %@",[guest objectForKey:@"contact"]];
            
            [self.QRImg sd_setImageWithURL:[NSURL URLWithString:[meetingDetail objectForKey:@"qrUrl"]] placeholderImage:[UIImage imageNamed:@"qr_vector.png"]];
            
        }
        else
        {
            [SVProgressHUD dismiss];
            
            self.btnBack.userInteractionEnabled = YES ;
            
            [self.QRImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"qr_image"]] placeholderImage:[UIImage imageNamed:@"qr_vector.png"]];
            
        }
        
    }
    else
    {
        
        if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours]) {
            
            [SVProgressHUD dismiss];
            
            self.btnBack.userInteractionEnabled = YES ;
            
            NSDictionary *meetingDetail = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
            
            self.locationlbl.text = [NSString stringWithFormat:@"Location: %@",[meetingDetail objectForKey:@"location"]];
            
            self.meetingTimelbl.text = [NSString stringWithFormat:@"Meeting Time: %@ - %@",[meetingDetail objectForKey:@"fromtime"],[meetingDetail objectForKey:@"totime"]];
            
            NSDictionary *guest = [meetingDetail objectForKey:@"guest"];
            
            self.meetingWithlbl.text = [NSString stringWithFormat:@"Meeting With: %@",[guest objectForKey:@"contact"]];
            
            [self.QRImg sd_setImageWithURL:[NSURL URLWithString:[meetingDetail objectForKey:@"qrUrl"]] placeholderImage:[UIImage imageNamed:@"qr_vector.png"]];
        }
        else
        {
            [SVProgressHUD dismiss];
            
            self.btnBack.userInteractionEnabled = YES ;
            
        }
        
    }
    
    [SVProgressHUD dismiss];
    
}



#pragma mark - connect MQTT

-(void)closeOpenedOneBackground{
    
    NSData *data = [@"off" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:SmartOfficeGate
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [_switchLight setOn:NO animated:YES];
    
    [self closethePresentSession];
    
}

-(void)connectToMQTT
{
    session = [[MQTTSession alloc] init];
    session.userName = @"hipla";
    session.password = @"hipla@123";
    session.protocolLevel = 4;
    session.clientId = [NSString stringWithFormat:@"HC-APL-7411277896"];
    
    //session.clientId = [NSString stringWithFormat:@"HC-ANDae536ae8530d2601"];
    
    session.willQoS = MQTTQosLevelExactlyOnce;
    session.willRetainFlag = TRUE;
    session.willFlag = TRUE;
    session.willMsg = [@"False" dataUsingEncoding:NSUTF8StringEncoding]; ;
    session.willTopic =[NSString stringWithFormat:@"/available/online/%@",session.clientId];
    [session connectToHost:@"192.168.1.30" port:8883 usingSSL:NO];
    
    session.keepAliveInterval = 10;
    session.delegate = self;
    
}

#pragma mark -  Session delegate method
/** gets called when a connection has been successfully established
 @param session the MQTTSession reporting the connect
 
 */

- (void)connected:(MQTTSession *)session{
    
    NSLog(@"Connection Is done");
    
    [SVProgressHUD dismiss];
    
    [session publishData:[@"True" dataUsingEncoding:NSUTF8StringEncoding]
                 onTopic:[NSString stringWithFormat:@"/available/online/%@",session.clientId]
                  retain:YES
                     qos:MQTTQosLevelAtLeastOnce];
    
    
}

/** gets called when a connection has been refused
 @param session the MQTTSession reporting the refusal
 @param error an optional additional error object with additional information
 */

- (void)connectionRefused:(MQTTSession *)session error:(NSError *)error{
    
    NSLog(@"Connection Is refused");
    
    [SVProgressHUD dismiss];
    
}

/** gets called when a connection has been closed
 @param session the MQTTSession reporting the close
 
 */

- (void)connectionClosed:(MQTTSession *)session{
    
    NSLog(@"Connection Is closed");
    
    [SVProgressHUD dismiss];
    
}

/** gets called when a connection error happened
 @param session the MQTTSession reporting the connect error
 @param error an optional additional error object with additional information
 */

- (void)connectionError:(MQTTSession *)session error:(NSError *)error{
    
    NSLog(@"Connection has error");
    
    [SVProgressHUD dismiss];
    
    
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:@"Hipla Office"
//                                 message:@"Error Connecting!! Please try again"
//                                 preferredStyle:UIAlertControllerStyleAlert];
//
//
//
//    UIAlertAction* yesButton = [UIAlertAction
//                                actionWithTitle:@"OK"
//                                style:UIAlertActionStyleDefault
//                                handler:^(UIAlertAction * action) {
//                                    //Handle your yes please button action here
//
//                                    [self connectToMQTT];
//
//
//                                }];
//
//    UIAlertAction* noButton = [UIAlertAction
//                               actionWithTitle:@"Cancel"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action) {
//                                   //Handle no, thanks button
//
//
//                               }];
//
//
//
//    [alert addAction:yesButton];
//    [alert addAction:noButton];
//
//    [self presentViewController:alert animated:YES completion:nil];
    
    
}

/** gets called when a published message was actually delivered
 @param session the MQTTSession reporting the delivery
 @param msgID the Message Identifier of the delivered message
 @note this method is called after a publish with qos 1 or 2 only
 */

- (void)messageDelivered:(MQTTSession *)session msgID:(UInt16)msgID{
    
    
    
}


#pragma mark - For closing Session

-(void)closethePresentSession{
    
    [session close];
    
}


#pragma mark - Open door by zone detection

-(void)openDoor
{
    [self switchOnGate];

   // [self switchoffGate];

   [self performSelector:@selector(switchoffGate) withObject:self afterDelay:3.0];

   // [self performSelector:@selector(messageDoorON:) withObject:@"on" afterDelay:0.5];
}

- (void)messageDoorON:(NSString *)strMessage
{
    NSData *data = [@"on" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:strTopicDoor
                         retain:YES
                            qos:MQTTQosLevelAtLeastOnce]; // this is part of the asynchronous API
    
    NSString *strOff = @"off";
    
    [self performSelector:@selector(messageDoor:) withObject:strOff afterDelay:3.0];
    
    NSLog(@"fired");
}


#pragma mark - On light & AC

-(void)switchOnLight1{
    
    NSData *data = [@"on" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:Light1
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [self performSelector:@selector(switchOnLight2) withObject:self afterDelay:0.5];
    
}

-(void)switchOnLight2{
    
    NSData *data = [@"on" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:Light2
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [self performSelector:@selector(switchOnLight3) withObject:self afterDelay:0.5];
    
}

-(void)switchOnLight3{
    
    NSData *data = [@"on" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:Light3
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [self performSelector:@selector(switchOnAC) withObject:self afterDelay:0.5];
    
}

-(void)switchOnAC{
    
    NSData *data = [@"on" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:AC
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
}


#pragma mark - Off light & AC

-(void)switchoffAC{
    
    NSData *data = [@"off" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:AC
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [_switchLight setOn:NO animated:YES];
    
    [self performSelector:@selector(switchoffLight3) withObject:self afterDelay:0.5];
    
    
}

-(void)switchoffLight3{
    
    NSData *data = [@"off" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:Light3
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [_switchLight setOn:NO animated:YES];
    
    [self performSelector:@selector(switchoffLight2) withObject:self afterDelay:0.5];
    
    
}



-(void)switchoffLight2{
    
    NSData *data = [@"off" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:Light2
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [_switchLight setOn:NO animated:YES];
    
    [self performSelector:@selector(switchoffLight1) withObject:self afterDelay:0.5];
    
    
}

-(void)switchoffLight1{
    
    NSData *data = [@"off" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:Light1
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    [_switchLight setOn:NO animated:YES];
    
    
}



//- (IBAction)switchAction_Light:(id)sender {
//
//    if ([sender isOn]) {
//
//        [self switchOnLight1];
//
//        [self performSelector:@selector(switchOnLight2) withObject:self afterDelay:0.5];
//
//
//    }else{
//
//        [self switchoffAC];
//
//        [self performSelector:@selector(switchoffLight3) withObject:self afterDelay:0.5];
//
//
//    }
//
//}


-(void)switchoffGate{
    
    NSData *data = [@"off" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:SmartOfficeGate
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
    
  //  [_switchLight setOn:NO animated:YES];
    
}

-(void)switchOnGate{
    
    
    NSData *data = [@"on" dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:SmartOfficeGate
                         retain:TRUE
                            qos:MQTTQosLevelAtLeastOnce];
    
   // [self switchOnLight1];
    
}

- (void)messageDoor:(NSString *)strMessage
{
    // message = true
    
    //topic =  [NSString stringWithFormat:@"/available/online/%@",session.clientId];
    
    NSData *data = [strMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    [session publishAndWaitData:data
                        onTopic:strTopicDoor
                         retain:YES
                            qos:MQTTQosLevelAtLeastOnce]; // this is part of the asynchronous API
    
    NSLog(@"fired");
}





#pragma mark - Navigation

- (void)navigationTicker {
    
    // NCDeviceInfo *res = _navigineCore.deviceInfo;
    
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    NSLog(@"Error code:%zd",res.error.code);
    
    if (res.error.code == 0) {
        
        [Userdefaults setObject:@"YES" forKey:@"inLocation"];
        
        [Userdefaults synchronize];
        
        NSLog(@"RESULT: %lf %lf", res.x, res.y);
        
        NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
        
        if ([[dic allKeys] containsObject:@"name"]) {
            
            // NSLog(@"zone detected:%@",dic);
            
            NSString* zoneName = [dic objectForKey:@"name"];
            
            if (!_currentZoneName) {
                
                _currentZoneName = zoneName;
                
                [self enterZoneWithZoneName:_currentZoneName];
                
                
            } else {
                
                if (![zoneName isEqualToString:_currentZoneName]) {
                    
                    [self exitZoneWithZoneName:_currentZoneName];
                    
                    _currentZoneName = zoneName;
                    
                    [self enterZoneWithZoneName:_currentZoneName];
                    
                } else {
                    
                }
            }
            
            
        } else {
            
            if (_currentZoneName) {
                
                [self exitZoneWithZoneName:_currentZoneName];
                
                _currentZoneName = nil;
                
            } else {
                
            }
            
        }
        
    }
    else{
        
        NSLog(@"Error code:%zd",res.error.code);
    }
    
}


-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"Pre Conference Room"]) {
            
               // [self openDoor];
            
            
          
        }
        else if ([zoneName isEqualToString:@"conference area"]) {
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self openDoor];
//
//            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.buttonOpenDoor setEnabled:YES];
                [self.buttonOpenDoor setTitleColor:[UIColor colorWithHexString:@"#46AFEF"] forState:UIControlStateNormal];
                
                [self.btnAction_Reconnect setEnabled:YES];
                [self.btnAction_Reconnect setTitleColor:[UIColor colorWithHexString:@"#46AFEF"] forState:UIControlStateNormal];
                
             });
            
        }
    }
}


-(void)exitZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"Pre Conference Room"])
        {
            
        }
        else if ([zoneName isEqualToString:@"conference area"]) {
            
           // [self switchoffAC];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.buttonOpenDoor setEnabled:NO];
                [self.buttonOpenDoor setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
                [self.btnAction_Reconnect setEnabled:NO];
                [self.btnAction_Reconnect setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
            });
            
        }
    }
}


- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    
    if (_zoneArray) {
        
        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
            
            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[_zoneArray objectAtIndex:i]];
            
            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
                    
                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
                        
                        float xPoint = (float)[[dicCoordinate objectForKey:@"kx"] floatValue];
                        float yPoint = (float)[[dicCoordinate objectForKey:@"ky"] floatValue];
                        
                        CGPoint point = CGPointMake(xPoint, yPoint);
                        
                        if (j == 0) {
                            
                            [path moveToPoint:point];
                            
                        } else {
                            
                            [path addLineToPoint:point];
                        }
                    }
                }
                
                [path closePath];
                
                if ([path containsPoint:currentPoint]) {
                    
                    zone = [NSDictionary dictionaryWithDictionary:dicZone];
                    
                    break;
                    
                } else {
                    
                    zone = nil;
                    
                }
            }
        }
        
    } else {
        
    }
    
    return zone;
}


#pragma mark - Button actions

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
   
}


- (IBAction)btnOpenMap:(id)sender {
    
//    NavigationViewController *controlVC = [[NavigationViewController alloc]initWithNibName:@"NavigationViewController" bundle:nil];
//
//    [self.navigationController pushViewController:controlVC animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_objc" bundle:nil];
    ViewController *myVC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    
    
    //    ViewController *indoorMap = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    [self.navigationController pushViewController:myVC animated:YES];
    
}


//- (IBAction)btnOpenDoor:(id)sender {
//
//    NSString *strOff = @"off";
//
//    [self messageDoor:@"on"];
//
//    [self performSelector:@selector(messageDoor:) withObject:strOff afterDelay:3.0];
//
//}


- (IBAction)btnAction_OpenDoor:(id)sender {
    
    [self switchOnGate];
    
    [self performSelector:@selector(switchoffGate) withObject:self afterDelay:3.0 ];
    
}


- (IBAction)btnReconnect:(id)sender {
    
    [self connect:strHost];
    
}


- (IBAction)btnVisibilityPassword:(id)sender {
    
    NSString *strVisible = [Userdefaults objectForKey:@"isVisible"];
    
    if ([strVisible isEqualToString:@"NO"]) {
        
        [Userdefaults setObject:@"YES" forKey:@"isVisible"];
        
        [Userdefaults synchronize];
        
        [self.btnVisibilityPassword setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
        
        [self getRandomNumberFromArrayPassword:_array_Password];
        
    } else {
        
        [Userdefaults setObject:@"NO" forKey:@"isVisible"];
        
        [Userdefaults synchronize];
        
        [self.btnVisibilityPassword setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
        
        self.wifiPasswordlbl.text = [NSString stringWithFormat:@"WiFi Password: ******"];
    }
    
}

-(void)sessionclose{
    
    [session close];
}


#pragma mark - Api details

-(void)getZone{
    
    NSString *url = [NSString stringWithFormat:@"https://api.navigine.com/zone_segment/getAll?userHash=0F17-DAE1-4D0A-1778&sublocationId=3247"];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              
                                              NSLog(@"The response is - %@",responseDictionary);
                                              
                                              self->_zoneArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"zoneSegments"]];
                                              
//                                              [SVProgressHUD dismiss];
//
//                                              [SVProgressHUD showWithStatus:@"Connecting..."];
//
//                                              [self sessionclose];
//
//                                              [self connectToMQTT];
                                              
                                          }
                                          else
                                          {
                                              NSLog(@"Error");
                                              
                                              //[SVProgressHUD dismiss];
                                          }
                                      }];
    
    [dataTask resume];
    
}


-(void)generateICEDetails:(NSString *)userName withPassword:(NSString *)password
{
    [SVProgressHUD show];
    
    NSDictionary *headers = @{ @"Content-Type": @"application/json",
                               @"Accept-Type": @"application/json",
                               @"Authorization": @"Basic ZXJzLWFkbWluOkZuc3BsQDIwMTg=",
                               @"Cache-Control": @"no-cache",
                               @"Postman-Token": @"09819f50-185f-440d-af38-62dc3e0ad39c" };
    NSDictionary *parameters = @{ @"InternalUser": @{ @"name": @"arijit3", @"password": @"C1sco12389", @"changePassword": @"" } };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://10.137.247.204:9060/ers/config/internaluser"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    [NSURLRequest allowsAnyHTTPSCertificateForHost:request];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    [SVProgressHUD dismiss];
                                                    
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                    }
                                                }];
    [dataTask resume];
    
    
}


#pragma mark - MQTT

-(void)connect:(NSString *)strHost
{
    NSString *strUdid = [Userdefaults objectForKey:@"udid"];
    
    NSString *trimmedString=[strUdid substringFromIndex:MAX((int)[strUdid length]-6, 0)];
    
    transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = strHost;
    transport.port = 8883;
    
    session = [[MQTTSession alloc] init];
    session.transport = transport;
    session.clientId = [NSString stringWithFormat:@"HC-APL-%@",trimmedString];
    session.userName = [NSString stringWithFormat:@"hipla"];
    session.password = [NSString stringWithFormat:@"hipla@123"];
    session.keepAliveInterval = 10.0;
    
    session.willQoS = 1;
    session.willTopic = [NSString stringWithFormat:@"/available/online/%@",session.clientId];
    
    session.willMsg = false;
    session.willRetainFlag = true;
    
    session.delegate = self;
    
    Contected = [session connectAndWaitTimeout:30];  //this is part of the synchronous API
    
    if (Contected) {
        
        
    }
    
    [SVProgressHUD dismiss];
    
}

- (void)ConnectMQTT
{
    [SVProgressHUD showWithStatus:@"Connecting..."];
    
    [self connect:strHost];
    
}


-(void)subscribe:(NSString *)strTopic
{
    [session subscribeToTopic:strTopic atLevel:2 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss){
        
        if (error) {
            
            NSLog(@"Subscription failed %@", error.localizedDescription);
            
        } else {
            
            NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
            
        }
        
        [SVProgressHUD dismiss];
        
        
    }]; // this is part of the block API
    
    // topic = @"example/#"
    
}


- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid
{
    // this is one of the delegate callbacks
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
