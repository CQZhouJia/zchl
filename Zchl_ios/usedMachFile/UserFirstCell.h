//
//  UserFirstCell.h
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserFirstCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic,strong)NSString * stastaticHttpUrl;

@property (nonatomic,strong)NSArray * imageArr;

@property (nonatomic,strong)UIScrollView * scrollview;

@property (nonatomic,strong)UIPageControl * pageControl;

@property (nonatomic,strong)NSString * goodName;

@property (nonatomic,strong)NSString * goodPrice;

@end
