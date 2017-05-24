//
//  LSTabBarController.m
//  LSOnline
//
//  Created by jglx on 17/3/13.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "LSTabBarController.h"

@interface LSTabBarController ()

@end

@implementation LSTabBarController

-(void)awakeFromNib{
   
    [super awakeFromNib];

}

+(LSTabBarController *)custom{
    static LSTabBarController * sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LSselectedloveVC" object:nil];
}
-(void)selectViewControlls:(NSNotification *)note{

    self.selectedIndex = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectViewControlls:) name:@"LSselectedloveVC" object:nil];
    
    for (UITabBarItem * item in self.tabBar.items) {
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }
    
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbarColor"]];

    [self.tabBar setBarTintColor:[UIColor whiteColor]];
//    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.tintColor = Color_RGBA(157, 207, 119, 1);  // 这是选中状态下的颜色
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color_RGBA(140, 140, 140, 1),NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color_RGBA(33, 40, 93, 1),NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
//    [self.tabBar setBarTintColor:[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1]];
    
//    UIImageView * imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage imageNamed:@"tabbarColor"];
//    imageView.frame = self.tabBar.bounds;
//    [[UITabBar appearance] insertSubview:imageView atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addNavChildController:(UIViewController *)ChildVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{

    //设置每个nav的随机颜色
     //[ChildVc.view setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
    ChildVc.title = title;
    ChildVc.tabBarItem.image = [UIImage imageNamed:imageName];
    //tabbar属性
    NSMutableDictionary * tabBarTitleAtrr = [NSMutableDictionary dictionary];
    tabBarTitleAtrr[NSForegroundColorAttributeName] = [UIColor blackColor];
    tabBarTitleAtrr[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [ChildVc.tabBarItem setTitleTextAttributes:tabBarTitleAtrr forState:UIControlStateNormal];
    
    NSMutableDictionary * tabBarSelectedTitleAtrr = [NSMutableDictionary dictionary];
    tabBarSelectedTitleAtrr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [ChildVc.tabBarItem setTitleTextAttributes:tabBarSelectedTitleAtrr forState:UIControlStateSelected];
    
    UIImage * selectedImage = [UIImage imageNamed:selectedImageName];
    BOOL isIOS7 = [[UIDevice currentDevice] systemVersion].doubleValue >= 7.0;
    //ios7中会将选中的图片再次渲染，以下方法表示不渲染，保持原图
    if (isIOS7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    ChildVc.tabBarItem.selectedImage = selectedImage;
    
    
}


@end
