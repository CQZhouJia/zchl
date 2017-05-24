//
//  UserFirstCell.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "UserFirstCell.h"


#define GIFTIMAGEHEIGHT 160
@implementation UserFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat confot = scrollView.contentOffset.x/WIDTH;
    _pageControl.currentPage = confot;
}

-(void)initUI{
    
//    self.imageArr = @[@"1",@"2",@"3"];
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, GIFTIMAGEHEIGHT)];
//    _scrollview.contentSize = CGSizeMake(WIDTH * self.imageArr.count, GIFTIMAGEHEIGHT);
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    _scrollview.showsHorizontalScrollIndicator = NO;
    for (NSInteger i = 0; i < self.imageArr.count; i ++) {
        
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, GIFTIMAGEHEIGHT)];
//        imageView.image = [UIImage imageNamed:@"ershoujixiangqing"];
//        [_scrollview addSubview:imageView];
        
        //        UIImageView * loveShapeImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 100, 10, 60, 40)];
        //        loveShapeImage.image = [UIImage imageNamed:@"loveShape"];
        //        [imageView addSubview:loveShapeImage];
        //
        //        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(loveShapeImage.frame), CGRectGetHeight(loveShapeImage.frame) * 2/3.0)];
        //        textLabel.text = @"扶贫大礼包698元";
        //        textLabel.textAlignment = NSTextAlignmentCenter;
        //        textLabel.numberOfLines = 2;
        //        textLabel.font = [UIFont systemFontOfSize:10];
        //        textLabel.textColor = [UIColor whiteColor];
        //        [loveShapeImage addSubview:textLabel];
        
    }
    
    [self.contentView addSubview:_scrollview];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([FlexibeFrame flexibleFloat:320] - 100)/2.0, GIFTIMAGEHEIGHT - 20, 100, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.hidesForSinglePage = YES; // 隐藏指示器当只有一个的时候
//    _pageControl.numberOfPages = self.imageArr.count;
    _pageControl.numberOfPages = 1;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _pageControl.pageIndicatorTintColor = Color_RGBA(158, 175, 175, 1);
    [self.contentView addSubview:_pageControl];
}

-(void)setStastaticHttpUrl:(NSString *)stastaticHttpUrl{
    _stastaticHttpUrl = stastaticHttpUrl;
}

-(void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    _scrollview.contentSize = CGSizeMake(WIDTH * self.imageArr.count, GIFTIMAGEHEIGHT);

    for (NSInteger i = 0; i < self.imageArr.count; i ++) {

        NSDictionary * dic = imageArr[i];

        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, GIFTIMAGEHEIGHT)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_stastaticHttpUrl,dic[@"url"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
        [_scrollview addSubview:imageView];

//        UIImageView * loveShapeImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 100, 10, 60, 40)];
//        loveShapeImage.image = [UIImage imageNamed:@"loveShape"];
//        [imageView addSubview:loveShapeImage];
//
//        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(loveShapeImage.frame), CGRectGetHeight(loveShapeImage.frame) * 2/3.0)];
////        textLabel.text = @"扶贫大礼包698元";
//        textLabel.text = [NSString stringWithFormat:@"%@%@元",_goodName,_goodPrice];
//        textLabel.textAlignment = NSTextAlignmentCenter;
//        textLabel.numberOfLines = 2;
//        textLabel.font = [UIFont systemFontOfSize:10];
//        textLabel.textColor = [UIColor whiteColor];
//        [loveShapeImage addSubview:textLabel];

    }
    NSLog(@"%zd",_imageArr.count);
    _pageControl.numberOfPages = self.imageArr.count;

}

-(void)setGoodName:(NSString *)goodName{
    _goodName = goodName;
}

-(void)setGoodPrice:(NSString *)goodPrice{
  
    _goodPrice = goodPrice;
}



@end
