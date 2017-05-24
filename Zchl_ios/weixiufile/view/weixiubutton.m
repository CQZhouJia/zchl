//
//  weixiubutton.m
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "weixiubutton.h"

@implementation weixiubutton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _boomView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH/2 - 40)/2, 37, 40, 3)];
    _boomView.backgroundColor = Color_RGBA(254, 171, 41, 1.0);
    [self addSubview:_boomView];
    
    
}

-(void)setSelect:(BOOL)select{
    _select = select;
    if (_select == YES) {
        //
        _boomView.hidden = NO;
    }else{
        _boomView.hidden = YES;
    }
    
}

@end
