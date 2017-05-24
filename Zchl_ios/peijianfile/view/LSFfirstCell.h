//
//  LSFfirstCell.h
//  LSOnline
//
//  Created by jglx on 17/4/8.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSFfirstCell : UITableViewCell <UIScrollViewDelegate>


@property (nonatomic,strong)NSString * stastaticHttpUrl;

@property (nonatomic,strong)NSArray * imageArr;

@property (nonatomic,strong)UIScrollView * scrollview;

@property (nonatomic,strong)UIPageControl * pageControl;

@property (nonatomic,strong)NSString * goodName;

@property (nonatomic,strong)NSString * goodPrice;


@end
