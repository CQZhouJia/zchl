//
//  HomePageFirstTableViewCell.h
//  LSOnline
//
//  Created by jglx on 17/3/16.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageHeaderTableViewCellDelegate <NSObject>

@optional

-(void)ServericsCollectionViewClick:(NSInteger)indexPathRow;

@end

@interface HomePageFirstTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign) id <HomePageHeaderTableViewCellDelegate> delegate;

@property (nonatomic,strong)NSString * stastaticHttpUrl;

@property (nonatomic,strong)NSArray * AdimageArray;

@end
