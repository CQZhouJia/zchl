//
//  UITableView+EmptyData.m
//  EMptyData
//
//  Created by 周佳 on 16/7/8.
//  Copyright © 2016年 zhoujia. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)

//-(void)tableViewDisplayWithMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount{
//    if (rowCount == 0) {
//
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        TableView * taView = [[TableView alloc] init];
//        [taView lstr:message];
//        self.backgroundView = taView;
//    }else{
//        self.backgroundView = nil;
//        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }
//
//}

-(void)tableViewGetFootEmptyView{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

//
//首先导入头文件
//
//#import "UITableView+EmptyData.h"
//1
//1
//然后在UITableView的数据源代理方法中使用就可以了。


//a.如果你的tableView是分组的，则在下面这个数据源代理方法里面这样写就可以了。
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    /**
//     *  如果没有数据的时候提示用户的信息
//     */
//    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
//    return [self.dataSource count];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 10;
//}
//
//b.如果你的tableView只有一个分组的话，则采用下面这种调用方式
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
//    return self.dataSource.count;
//}




@end
