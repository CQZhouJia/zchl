//
//  JGMyTableView.h
//  NDP_eHome
//
//  Created by 冠美 on 16/1/29.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TouchTableViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;


@end

@interface  JGMyTableView : UITableView


@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;

@end