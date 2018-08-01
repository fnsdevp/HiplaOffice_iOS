//
//  ProfileDetailViewController.m
//  @TCS
//
//  Created by FNSPL on 10/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileDetailViewController ()

@end


@implementation ProfileDetailViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    [self setNeedsStatusBarAppearanceUpdate];
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

//    _isFromAddMeeting = @"False";
    if ([Userdefaults boolForKey:@"dateNotification"]==NO) {
        
        [self.dateNotifSwitch setOn:false animated:YES];
        
        [Userdefaults setBool:NO forKey:@"dateNotification"];
        
        [Userdefaults synchronize];
    }
    else
    {
        [self.dateNotifSwitch setOn:true animated:YES];
        
        [Userdefaults setBool:YES forKey:@"dateNotification"];
        
        [Userdefaults synchronize];
    }
    
    [self setProfileDetails];
    
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSString *isMeetingTimeSlot = [Userdefaults objectForKey:@"isMeetingTimeSlot"];
    
    if ([isMeetingTimeSlot isEqualToString:@"30 min"]) {
        
        [self.radioButton1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        
        [self.radioButton1 setTitle:@"30 min" forState:UIControlStateNormal];
        [self.radioButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.radioButton1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.radioButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.radioButton1.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        
        [self.radioButton2 setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [self.radioButton2 setTitle:@"60 min" forState:UIControlStateNormal];
        [self.radioButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.radioButton2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.radioButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.radioButton2.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        
        
        [self.radioButton1 setSelected:YES];
        
    } else if ([isMeetingTimeSlot isEqualToString:@"60 min"]) {
        
        [self.radioButton1 setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        
        [self.radioButton1 setTitle:@"30 min" forState:UIControlStateNormal];
        [self.radioButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.radioButton1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.radioButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.radioButton1.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        
        [self.radioButton2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [self.radioButton2 setTitle:@"60 min" forState:UIControlStateNormal];
        [self.radioButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.radioButton2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.radioButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.radioButton2.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        
        
        [self.radioButton2 setSelected:YES];
    }

    
   // NSMutableArray* buttons = [NSMutableArray arrayWithObjects:@"30 min", @"60 min", nil];
    
  //  [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    
    
    _innerScrollVw.contentSize = CGSizeMake(SCREENWIDTH, (_timeOptionVw.frame.origin.y+_timeOptionVw.frame.size.height+100));
    
}


- (IBAction)btnAction_Back:(id)sender {
    
//   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    
//   DashBoardViewController *dashboard = [storyboard instantiateInitialViewController];
//    
//   [self.navigationController pushViewController:dashboard animated:YES];
    
    if ([self.isFromAddMeeting isEqualToString:@"True"]){
        
        _isFromAddMeeting = @"False";
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
    
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//
//    DashBoardViewController *dashboard = [storyboard instantiateInitialViewController];
//
//    [self.navigationController pushViewController:dashboard animated:YES];
    
}

-(IBAction)setNotification:(id)sender
{
    if ([Userdefaults boolForKey:@"dateNotification"]==YES)
    {
        [self.dateNotifSwitch setOn:false animated:YES];
        
        [Userdefaults setBool:NO forKey:@"dateNotification"];
        
        [Userdefaults synchronize];
    }
    else
    {
        [self.dateNotifSwitch setOn:true animated:YES];
        
        [Userdefaults setBool:YES forKey:@"dateNotification"];
        
        [Userdefaults synchronize];
        
    }
}


-(void)setProfileDetails
{
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    self.profPicImg.layer.cornerRadius = self.profPicImg.frame.size.width / 2;
    self.profPicImg.clipsToBounds = YES;
    self.profPicImg.layer.borderWidth = 3.0f;
    self.profPicImg.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.profPicImg sd_setImageWithURL:[NSURL URLWithString:[userDict objectForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@"user"]];

    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    _userTypelbl.text = [NSString stringWithFormat:@"User: %@",[userDict objectForKey:@"usertype"]];
    
    _fnamelbl.text = [NSString stringWithFormat:@"First Name: %@",[userDict objectForKey:@"fname"]];
    
    _lnamelbl.text = [NSString stringWithFormat:@"Last Name: %@",[userDict objectForKey:@"lname"]];
    
    _designationlbl.text = [NSString stringWithFormat:@"Designation: %@",[userDict objectForKey:@"designation"]];
    
    _departmentlbl.text = [NSString stringWithFormat:@"Department: %@",[userDict objectForKey:@"department"]];
    
    _companylbl.text = [NSString stringWithFormat:@"Company: %@",[userDict objectForKey:@"company"]];
    
    _emaillbl.text = [NSString stringWithFormat:@"Email: %@",[userDict objectForKey:@"email"]];
    
    _phonelbl.text = [NSString stringWithFormat:@"Phone: %@",[userDict objectForKey:@"phone"]];
    
}


- (void)removeImage {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"profilePic.png"]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
    
    [self setProfilePic];
    
    NSLog(@"image removed");
}

- (void)gestureHandler:(UILongPressGestureRecognizer *)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Do you really want to delete the profile picture." message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"YES"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self removeImage];
                             
                         }];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"NO"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)changePasswordBtnAction:(id)sender {
    
    newPassVC = [[ChangePasswordViewController alloc] init];
    
    newPassVC.delegate = self;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self presentViewController:newPassVC animated:NO completion:nil];
    
}


- (IBAction)profPicBtnAction:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Set Profile picture." message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction
                             actionWithTitle:@"Take Photo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self takePicture];
                                 
                             }];
    
    
    UIAlertAction* photoGallery = [UIAlertAction
                                   actionWithTitle:@"Choose Photo"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [self choosePicture];
                                       
                                   }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:camera];
    [alert addAction:photoGallery];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)choosePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)takePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.profPicImg.image = chosenImage;
    
    self.profPicImg.layer.cornerRadius = self.profPicImg.frame.size.width/2;
    self.profPicImg.clipsToBounds = YES;
    
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"profilePic.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    [self profileImageUpload];
    
}


-(void)setProfilePic
{
    NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [docpaths objectAtIndex:0];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"profilePic.png"];
    
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    
    if (thumbNail==nil) {
        
        self.profPicImg.image = [UIImage imageNamed:@"profilePic"];
    }
    else
    {
        self.profPicImg.image = thumbNail;
        
        self.profPicImg.layer.cornerRadius = self.profPicImg.frame.size.width/2;
        self.profPicImg.clipsToBounds = YES;
    }
    
}


-(void)ChangePasswordViewController:(ChangePasswordViewController *)obj didremove:(BOOL)isRemove
{
    [obj dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)updateDeviceInfoBtn:(id)sender
{
    // [self getMacAddressByipAddress];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    [self getRegKey:userId];
    
}

-(void)getRegKey:(NSString *)userID{
    
    [SVProgressHUD showWithStatus:@"Updating..."];
    
    NSString *deviceToken = [Userdefaults objectForKey:@"deviceToken"];
    
    if (!deviceToken) {
        deviceToken = [Utils deviceToken];
    }
    
    NSDictionary *params = @{@"userid":userID,@"reg":deviceToken,@"type":@"Ios"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *hostUrl = [NSString stringWithFormat:@"%@get_regkey.php",BASE_URL];
    
    [manager POST:hostUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            
            [Userdefaults setBool:true forKey:@"isDeviceinfoUpdated"];
            
            [Userdefaults synchronize];
            
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Device information updated successfully." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            
            
            [alert addAction:OKAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [SVProgressHUD dismiss];
            
        }else{
            
            NSString *msg = [responseDict objectForKey:@"message"];
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            
            
            [alert addAction:OKAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [self performSelector:@selector(getRegKey:) withObject:userID afterDelay:0.0];
        
        [SVProgressHUD dismiss];
    }];
    
}

-(void)profileImageUpload{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
 
    NSString *hostUrl = [NSString stringWithFormat:@"%@upload_image.php",BASE_URL];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
        
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    userID,@"userid"
                                    , nil];
    
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyyHHmm"];
    NSDate *currentDate = [NSDate date];
    NSString *timeString = [formatter stringFromDate:currentDate];
        
    NSData  *imageDataToUpload=UIImageJPEGRepresentation(self->_profPicImg.image, 1.0);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:hostUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
            [formData appendPartWithFileData:imageDataToUpload
                                        name:@"photo"
                                    fileName:[NSString stringWithFormat:@"image%@.jpg",timeString]
                                    mimeType:@"image/jpeg"];
        
            
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Successful %@",responseObject);
            
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            NSString *str_dict = [responseObject valueForKey:@"url"];
            
            if (!str_dict) {
                
                str_dict = @"";
            }
            
            
            NSDictionary *dictProfile = [Userdefaults objectForKey:@"ProfInfo"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)dictProfile;
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:str_dict forKey:@"profile_image"];
            
            NSDictionary *dict2 = [newDict mutableCopy];
            
            [Userdefaults setObject:dict2 forKey:@"ProfInfo"];
            
            [Userdefaults synchronize];
            
            [self setProfileDetails];
            
        }
        else
        {
            
        }
            
            
       [SVProgressHUD dismiss];
        
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error %@",error.description);
        
        [[[UIAlertView alloc] initWithTitle:@"Error !" message:@"Error In Loading. Please Check Network Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        [SVProgressHUD dismiss];
        
    }];
   
}


-(IBAction)for30Min:(RadioButton*)sender
{
    if(sender.selected) {
        
        NSLog(@"Selected color: %@", sender.titleLabel.text);
        
        [self.radioButton1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        
        [self.radioButton2 setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        
        [Userdefaults setObject:@"30 min" forKey:@"isMeetingTimeSlot"];
        
        [Userdefaults synchronize];
        
    }
}

-(IBAction)for60Min:(RadioButton*)sender
{
    if(sender.selected) {
        
        NSLog(@"Selected color: %@", sender.titleLabel.text);
        
        [self.radioButton2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        
        [self.radioButton1 setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        
        [Userdefaults setObject:@"60 min" forKey:@"isMeetingTimeSlot"];
        
        [Userdefaults synchronize];
    }
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
