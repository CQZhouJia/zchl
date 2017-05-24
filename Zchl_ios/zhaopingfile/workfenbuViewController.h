//
//  workfenbuViewController.h
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol backDelegate <NSObject>

-(void)refreshMessage:(NSString *)typeId;

@end

@interface workfenbuViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *feileiworktableView;


@property (nonatomic,assign)id<backDelegate>delegate;


@end
