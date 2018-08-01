//
//  HotDeskingDetailViewController.h
//  @TCS
//
//  Created by FNSPL on 17/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotDeskingDetailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_BookListZone;
@property (strong,nonatomic)NSString *getZoneId;

- (IBAction)btnAction_Back:(id)sender;


//Local View

@property (weak, nonatomic) IBOutlet UIView *view_Local;

@property (weak, nonatomic) IBOutlet UILabel *lbl_ZoneName;


- (IBAction)btnAction_Release:(id)sender;


@end
