//
//  selectionContactVw.h
//  SmartOffice
//
//  Created by FNSPL on 03/04/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@protocol selectionContactDelegate;
@class selectionContactVw;

@protocol selectionContactDelegate <NSObject>

@optional

-(void)selectionContactVw:(selectionContactVw *)obj didTapOnCell:(BOOL)isTap withName:(NSString *)textName withPh:(NSString *)textPh;

-(void)selectionContactVw:(selectionContactVw *)obj didTapOnBackground:(BOOL)isClose;


@end

@interface selectionContactVw : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic)id<selectionContactDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSString *strName;
@property (nonatomic, strong) IBOutlet UIView *backVw;
@property (nonatomic) NSArray *arrayPh;

-(selectionContactVw *) init;
-(void)ResizeandReloadViews;

@end
