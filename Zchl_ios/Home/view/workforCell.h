//
//  workforCell.h
//  Zchl_ios
//
//  Created by jglx on 17/4/27.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol leftrightbuttonDelegate <NSObject>

@optional

-(void)leftServericsCollectionViewClick:(UIButton *)sender;

-(void)rightServericsCollectionViewClick:(UIButton *)sender;



@end

@interface workforCell : UITableViewCell

@property (nonatomic,strong)UIButton * leftbutton;

@property (nonatomic,strong)UIButton * rightbutton;

@property (nonatomic,assign) id <leftrightbuttonDelegate>delegate;


@end
