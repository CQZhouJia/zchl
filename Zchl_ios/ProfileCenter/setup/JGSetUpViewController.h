//
//  JGSetUpViewController.h
//  NDP_eHome
//
//  Created by 冠美 on 16/2/1.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGBaseViewController.h"
@interface JGSetUpViewController : JGBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)backBtnClick:(id)sender;
@end
