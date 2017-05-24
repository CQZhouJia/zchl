//
//  foueCell.h
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol phoneDelegate <NSObject>

-(void)buttonphoneDelegate:(UIButton *)sender;

@end


@interface foueCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *namelabel;



@property (weak, nonatomic) IBOutlet UIImageView *redImage;



@property (weak, nonatomic) IBOutlet UIButton *phonebtn;


@property (nonatomic,assign)id <phoneDelegate> delegate;





@end
