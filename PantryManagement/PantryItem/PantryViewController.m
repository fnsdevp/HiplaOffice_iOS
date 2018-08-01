//
//  PantryViewController.m
//  SmartOffice
//
//  Created by FNSPL on 07/08/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "PantryViewController.h"
#import "PantryOrderConfirmViewController.h"
#import "Menudetails.h"
#import "UIImageView+WebCache.h"

@interface PantryViewController ()

@end


@implementation PantryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    navView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 260, self.navigationController.navigationBar.frame.size.height)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, navView.frame.size.width - 20, self.navigationController.navigationBar.frame.size.height)];
    
    NSString *text = [NSString stringWithFormat:@"Pantry Management"];
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: label.textColor,
                              NSFontAttributeName: label.font
                              };

    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attribs];
    
    UIColor *whiteColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
//     UIColor *whiteColor = [UIColor whiteColor];
    NSRange whiteTextRange = [text rangeOfString:text];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:whiteColor}
                            range:whiteTextRange];
    label.attributedText = attributedText;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    
    [navView addSubview:label];
    
    [self.navigationController.navigationBar addSubview:navView];
    
    [self.tblPantry registerNib:[UINib nibWithNibName:@"PantryTableCell" bundle:nil] forCellReuseIdentifier:@"PantryTableCell"];
    
    [self.tblPantry registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];
    
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, (_headingVw.frame.origin.y+_headingVw.frame.size.height) - 1.0f, SCREENWIDTH, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    [_headingVw.layer addSublayer:bottomBorder];
    
    //self.btnOrder.layer.cornerRadius = 5.0;
    
    _items = [NSMutableArray array];
    
}
    

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:YES];
    
   [self getOrderManu];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [navView removeFromSuperview];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [orderFoodArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderCellIdentifier = @"PantryTableCell";
    
    PantryTableCell *cell = (PantryTableCell *)[tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PantryTableCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    


      [cell.typeIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self->orderFoodArr objectAtIndex:section] objectForKey:@"category_image"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    
    cell.typelbl.text = [[orderFoodArr objectAtIndex:section] objectForKey:@"category_name"];
    
    cell.btnSelect.tag = section;
    
    [cell.btnSelect addTarget:self action:@selector(btnSelectDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((isTypeClicked) && (section==TypeTag)) {
        
        if ([categoryArr count]>0) {
            
            return [categoryArr count];
        }
        else
        {
            return 0;
        }
        
    } else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *bodyCellIdentifier = @"ProductCell";
    
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:bodyCellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.btnAdd.tag = indexPath.row;
    cell.btnDel.tag = indexPath.row;
    
    cell.pantryDelegate =self;
    
    NSDictionary* dic = [categoryArr objectAtIndex:indexPath.row];
    cell.itemlbl.text = [dic objectForKey:@"food_name"];
    
    NSString* strSubCatId = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"food_id"] integerValue]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"subCcatId == %@",strSubCatId];
    NSArray* filteredItems = [_items filteredArrayUsingPredicate:predicate];
    
    if ([filteredItems count]) {
        
        Menudetails* menuDetails = (Menudetails *)[filteredItems firstObject];
        [cell setMenudetails:menuDetails];
        [cell.itemCount setText:[NSString stringWithFormat:@"%ld", menuDetails.quantity]];
        
    } else {
        
        Menudetails* menudetails = [[Menudetails alloc] init];
//        [menudetails setMenuId:[dic objectForKey:@"category_id"]];
        [menudetails setSubCcatId:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"food_id"] integerValue]]];
        [menudetails setSubCatName:[dic objectForKey:@"food_name"]];
        [menudetails setQuantity:0];
        [self.items addObject:menudetails];
        
        [cell setMenudetails:menudetails];
        [cell.itemCount setText:[NSString stringWithFormat:@"%ld", menudetails.quantity]];
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select");
}

#pragma mark - PantryViewDelegate
- (void)modifyItem1:(id)item {
    
    Menudetails* menuDet = (Menudetails *)item;
    NSInteger index = 0;
    for (; index < [_items count]; index++) {
        Menudetails* menuDet2 = (Menudetails *)[_items objectAtIndex:index];
        if ([menuDet.subCcatId isEqualToString:menuDet2.subCcatId]) {
            
            break;
        }
    }
    
    if (index < [_items count]) {
        
        [_items replaceObjectAtIndex:index withObject:menuDet];
    }
}


#pragma mark - Button actions

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDrawerMenuDidTap:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenDrawer"
     object:self];
}

- (IBAction)btnOrderDidTap:(id)sender
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"quantity > 0"];
    NSArray* filteredItems = [_items filteredArrayUsingPredicate:predicate];
    
    if ([filteredItems count]>0) {
        
        PantryOrderConfirmVC = [[PantryOrderConfirmViewController alloc]initWithNibName:@"PantryOrderConfirmViewController" bundle:nil];
        
        PantryOrderConfirmVC.orderFoodArr = [filteredItems mutableCopy];
        PantryOrderConfirmVC.currentMeeting = self.currentMeeting;
        
        [self.navigationController pushViewController:PantryOrderConfirmVC animated:YES];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please choose your order."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }
    
}

- (IBAction)btnSelectDidTap:(UIButton *)sender
{
    TypeTag = (int)sender.tag;
    
    if(isTypeClicked)
    {
        isTypeClicked = NO;
        
        categoryArr = [[NSMutableArray alloc] init];
        
        [self.tblPantry reloadData];
    }
    else
    {
        isTypeClicked = YES;
        
        self->categoryArr = [[orderFoodArr valueForKey:@"prod_list"]objectAtIndex:TypeTag];
        
        for (NSDictionary* dic in self->categoryArr) {
            
            NSString* subCatId = [dic objectForKey:@"cat_id"];
            NSPredicate *p = [NSPredicate predicateWithFormat:@"subCcatId == %@",subCatId];
            NSArray *res = [self->_items filteredArrayUsingPredicate:p];
            
            if ([res count]) {
                
            } else {
                
                Menudetails* menudetails = [[Menudetails alloc] init];
                
                [menudetails setMenuId:[dic objectForKey:@"category_id"]];
                [menudetails setSubCcatId:[dic objectForKey:@"id"]];
                [menudetails setSubCatName:[dic objectForKey:@"food_name"]];
                [menudetails setQuantity:0];
                
                [self->_items addObject:menudetails];
            }
            
        }
        
        NSLog(@"categoryArr: %@", self->categoryArr);
        
        [self.tblPantry reloadData];
    }
}


#pragma mark - Api details

-(void)getOrderManu
{
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    host_url = [NSString stringWithFormat:@"%@all_cat_subcat.php",BASE_URL];
    
    
    [manager POST:host_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSString *success = [dict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            self->orderFoodArr = [dict objectForKey:@"categories_list"];
            
            NSLog(@"orderFoodArr: %@", self->orderFoodArr);
            
            [self.tblPantry reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
    }];
    
}


-(void)getCategoryManu:(NSString *)catId
{
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                catId,@"cat",
                                nil];
    
     NSLog(@"Print paramenters ::%@",parameters);
    host_url = [NSString stringWithFormat:@"%@product_cat.php",BASE_URL];
    
    
    [manager POST:host_url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSString *success = [dict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            self->categoryArr = [dict objectForKey:@"productlist"];
            
            for (NSDictionary* dic in self->categoryArr) {
                
                NSString* subCatId = [dic objectForKey:@"id"];
                NSPredicate *p = [NSPredicate predicateWithFormat:@"subCcatId == %@",subCatId];
                NSArray *res = [self->_items filteredArrayUsingPredicate:p];
                
                if ([res count]) {
                    
                    
                    
                } else {
                    
                    Menudetails* menudetails = [[Menudetails alloc] init];
                    
                    [menudetails setMenuId:[dic objectForKey:@"category_id"]];
                    [menudetails setSubCcatId:[dic objectForKey:@"id"]];
                    [menudetails setSubCatName:[dic objectForKey:@"food_name"]];
                    [menudetails setQuantity:0];
                    [self->_items addObject:menudetails];
                }
                
            }
            
            NSLog(@"categoryArr: %@", self->categoryArr);
            
            [self.tblPantry reloadData];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No item found."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        [SVProgressHUD dismiss];
    }];
    
}


-(void)sendPushforOrderFood:(NSString *)strFoodSelected{
    
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *user = [NSString stringWithFormat:@"%@ %@",[userDict objectForKey:@"fname"],[userDict objectForKey:@"lname"]];
    
    NSString *strOrder = [NSString stringWithFormat:@"%@ has requested %@",user,strFoodSelected];
    
    NSDictionary *params = @{@"userid":@"1",@"appid":@"0",@"body":strOrder};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    host_url = [NSString stringWithFormat:@"%@customepush_guest.php",BASE_URL];

    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        self->strFood = @"";
        
        NSDictionary *responseDict = responseObject;
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Your order will be served shortly."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            
        }else{
            
            NSString *msg = [responseDict objectForKey:@"message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            [SVProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self->strFood = @"";
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [SVProgressHUD dismiss];
        
    }];
    
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
