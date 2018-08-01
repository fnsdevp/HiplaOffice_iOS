//
//  selectionContactVw.m
//  SmartOffice
//
//  Created by FNSPL on 03/04/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "selectionContactVw.h"

@implementation selectionContactVw

-(selectionContactVw *) init{
    
    selectionContactVw *result = nil;
    
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options: nil];
    
    for (id anObject in elements)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            
            break;
        }
    }
    
    return result;
}

- (void)drawRect:(CGRect)rect {
    
    self.backVw.frame = self.bounds;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake((SCREENWIDTH-180)/2, (SCREENHEIGHT-180)/2, 180, 180) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.alpha = 1.0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView  = [self roundCornersOnTableView:self.tableView onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:7.5];
    
    [self addSubview:self.tableView];
    
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    
    tapPress.delaysTouchesBegan = NO;
    tapPress.cancelsTouchesInView = NO;
    
    [self.backVw addGestureRecognizer:tapPress];
    
}

- (void)tapPress:(UITapGestureRecognizer *)gesture {
    
    [self.delegate selectionContactVw:self didTapOnBackground:YES];
}

-(void)ResizeandReloadViews
{
    self.tableView.frame = [self setdynamicFramewith:self.tableView.frame withHeight:([self.arrayPh count]*30)];
    
    NSLog(@"%@",self.arrayPh);
    
    [self.tableView reloadData];
}

-(CGRect)setdynamicFramewith:(CGRect)Frame withHeight:(float)Height
{
    CGRect PersonalFrame = Frame;
    
    
    PersonalFrame = CGRectMake(Frame.origin.x, (SCREENHEIGHT-Height)/2, Frame.size.width, Height);
    
    
    return PersonalFrame;
    
}

- (UITableView *)roundCornersOnTableView:(UITableView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius
{
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0;
        if (tl) corner = corner | UIRectCornerTopLeft;
        if (tr) corner = corner | UIRectCornerTopRight;
        if (bl) corner = corner | UIRectCornerBottomLeft;
        if (br) corner = corner | UIRectCornerBottomRight;
        
        UITableView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        
        return roundedView;
    }
    
    return view;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayPh count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ([self.arrayPh count]>0) {
        
        CNLabeledValue *label = [self.arrayPh objectAtIndex:indexPath.row];
        
        NSString *phone = [label.value stringValue];
        
        if ([phone length] > 0) {
            
            cell.textLabel.text = phone;
        }
        
        
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Ph no selected : %@",[self.arrayPh objectAtIndex:indexPath.row]);
    
    CNLabeledValue *label = [self.arrayPh objectAtIndex:indexPath.row];
    
    NSString *phone = [label.value stringValue];
    
    if ([phone length] > 0) {
        
        [self.delegate selectionContactVw:self didTapOnCell:YES withName:_strName withPh:phone];
    }
    
}


@end
