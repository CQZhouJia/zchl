//
//  headerCell.h
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol checkDelegate <NSObject>

-(void)lookButtonDelegate:(UIButton *)sender;

@end


@interface headerCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *logo;


@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *btnClick;

@property (nonatomic,assign)id <checkDelegate> delegate;

@end
