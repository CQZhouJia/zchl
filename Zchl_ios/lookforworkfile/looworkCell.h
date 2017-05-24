//
//  looworkCell.h
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol rightButtondelegatelook <NSObject>

-(void)rightbuttondelegate:(UIButton *)sender;

@end


@interface looworkCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *logoimage;


@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;


@property (weak, nonatomic) IBOutlet UILabel *jiqilabel;

@property (weak, nonatomic) IBOutlet UILabel *localabel;


@property (weak, nonatomic) IBOutlet UIButton *checkbutton;


@property (nonatomic,assign) id <rightButtondelegatelook> delegate;


@end
