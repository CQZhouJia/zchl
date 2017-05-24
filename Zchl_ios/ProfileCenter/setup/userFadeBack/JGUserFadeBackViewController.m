//
//  JGUserFadeBackViewController.m
//  NDP_eHome
//
//  Created by 冠美 on 16/2/2.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGUserFadeBackViewController.h"

@interface JGUserFadeBackViewController ()
@end

@implementation JGUserFadeBackViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTextView.layer.cornerRadius = 10;
    self.commitBtn.layer.cornerRadius = 5;
    self.myTitle.text = self.titleStr;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)showKeyBoard:(NSNotification *)info{
    if ([self.myTextView.text isEqualToString:@"请输入您的意见（500字以内）"]) {
        self.myTextView.text = @"";
        self.myTextView.textColor = [UIColor blackColor];
    }
}
-(void)hideKeyBoard:(NSNotification *)info{
    if ([self.myTextView.text isEqualToString:@""]) {
        self.myTextView.text = @"请输入您的意见（500字以内）";
        self.myTextView.textColor = [UIColor lightGrayColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commitBtnClick:(id)sender {
//    服务地址	Chat/Feedback
//    content	反馈/举报内容
//    state	0反馈 1举报
    if (self.myTextView.text.length > 500) {
        [self showHint:@"500字以内"];
        return;
    }
    NSString *stateStr=@"0"; //0反馈 1举报
    if (self.state!=1) { //反馈
        stateStr=@"1";
    }
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    
    NSDictionary * dict = @{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"content":self.myTextView.text,@"state":@"0"};
    NSLog(@"%@",dict);
    [ZTHttpTool postWithUrl:@"Feedback/Commit" param:dict success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"State"] integerValue] == 0) {
            [self showHint:responseObj[@"Msg"]];
           [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseObj[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
@end
