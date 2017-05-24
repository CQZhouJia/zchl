//
//  HomeTextField.m
//  LSOnline
//
//  Created by jglx on 17/3/20.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "HomeTextField.h"

@implementation HomeTextField

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(10, 10, 20, 20);
}

-(CGRect)borderRectForBounds:(CGRect)bounds{
    bounds.size.height = 40;
    return bounds;
}

@end
