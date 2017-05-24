//
//  HomePageFirstTableViewCell.m
//  LSOnline
//
//  Created by jglx on 17/3/16.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "HomePageFirstTableViewCell.h"
#import "LSHomeCollectionViewCell.h"

@interface HomePageFirstTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    UIScrollView * scrollview;
    NSArray * nameArray;
    NSArray * imageArray;
    NSTimer * timer;
    UIPageControl * pageControl;
}

@end

@implementation HomePageFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initScView];
        imageArray = [NSArray arrayWithObjects:@"drivertop",@"ershouji",@"weixiu",@"peijiantop", nil];
        nameArray = [NSArray arrayWithObjects:@"驾驶员",@"二手机",@"维修",@"配件", nil];
        [self startRun];
    }
    return self;
}

-(void)startRun{
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

//关闭定时器
- (void)cancelRun
{
    if (timer)
    {
        [timer invalidate];
    }
}

-(void)timerAction{

    
    NSInteger page = pageControl.currentPage;
    page ++;
//    NSLog(@"%zd",page);
    page = page == 4 ? 0 :page;
    pageControl.currentPage = page;
    [self turnPage];
}

#pragma mark --pageController选择器方法
-(void)turnPage{
 
    NSInteger page = pageControl.currentPage;
    [scrollview scrollRectToVisible:CGRectMake(WIDTH * page, 0, WIDTH, 160) animated:YES];
    
}

-(void)initScView{
    float Sheight = 160;
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, Sheight)];
    scrollview.delegate = self;
//    scrollview.contentSize = CGSizeMake(WIDTH * 4, Sheight);
    scrollview.contentSize = CGSizeMake(WIDTH, Sheight);
    [scrollview setPagingEnabled:YES]; // 设计翻页
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
//    NSArray * am = @[@"1.png",@"2.png",@"3.png",@"2.png"];
//    for (NSInteger i = 0; i < 4; i ++) {
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, Sheight)];
////        imageView.image = [UIImage imageNamed:@"souyeScr"];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",am[i]]];
//        [scrollview addSubview:imageView];
//    }
    
    [self.contentView addSubview:scrollview];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([FlexibeFrame flexibleFloat:320] - 100)/2.0, Sheight - 20, 100, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.hidesForSinglePage = YES; // 隐藏指示器当只有一个的时候
//    pageControl.numberOfPages = 1;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    pageControl.pageIndicatorTintColor = Color_RGBA(158, 175, 175, 1);
    NSLog(@"x-%f width - %f - 屏幕宽度 -- %f",pageControl.frame.origin.x,pageControl.frame.size.width,WIDTH);
    [self.contentView addSubview:pageControl];
    
    UIView * ColorViewone = [[UIView alloc] initWithFrame:CGRectMake(0, Sheight, WIDTH, 5)];
    ColorViewone.backgroundColor = Color_RGBA(227, 228, 229, 1);
    [self.contentView addSubview:ColorViewone];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(WIDTH/4, 80);
    flowLayout.minimumInteritemSpacing = 0;
    UICollectionView * collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Sheight + 5, WIDTH, 75) collectionViewLayout:flowLayout];
    collView.delegate = self;
    collView.dataSource = self;
    collView.bounces = NO;
    collView.showsVerticalScrollIndicator = NO;
    collView.backgroundColor = [UIColor clearColor];
    UINib * nib = [UINib nibWithNibName:@"LSHomeCollectionViewCell" bundle:[NSBundle mainBundle]];
    [collView registerNib:nib forCellWithReuseIdentifier:@"LSHomeCollectionViewCell"];
    [self.contentView addSubview:collView];
    
    UIView * ColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 245, WIDTH, 5)];
    ColorView.backgroundColor = Color_RGBA(227, 228, 229, 1);
    [self.contentView addSubview:ColorView];
}
#pragma mark UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (LSHomeCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     static NSString * iden = @"LSHomeCollectionViewCell";
    LSHomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LSHomeCollectionViewCell" owner:self options:nil] lastObject];
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",nameArray[indexPath.row]];
    cell.nameLabel.backgroundColor = [UIColor clearColor];
    cell.LogoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[indexPath.row]]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(ServericsCollectionViewClick:)]) {
        [self.delegate ServericsCollectionViewClick:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - 当scrollerView滚动时触发的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)scrollview.contentOffset.x / WIDTH;
    [pageControl setCurrentPage:page];
    //    NSLog(@"%f",self.scrollView.contentOffset.x);
}
#pragma mark - 当scrollerView滚动减速后停止时触发的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int currentPage = (int)scrollView.contentOffset.x / WIDTH;
    NSLog(@"%f",scrollView.contentOffset.x);
    if (currentPage == 0) {
        
        [scrollView scrollRectToVisible:CGRectMake(WIDTH * 0, 0, WIDTH, 160) animated:YES];
        NSLog(@"0");
    }else if(currentPage == self.AdimageArray.count){
        
        [scrollView scrollRectToVisible:CGRectMake(0, 0, WIDTH, 160) animated:NO];
        NSLog(@"5");
    }
    
}

-(void)setStastaticHttpUrl:(NSString *)stastaticHttpUrl{
    _stastaticHttpUrl = stastaticHttpUrl;
}

-(void)setAdimageArray:(NSArray *)AdimageArray{
  
    _AdimageArray = AdimageArray;
    
    scrollview.contentSize = CGSizeMake(WIDTH * self.AdimageArray.count, 160);

    
    for (NSInteger i = 0; i < self.AdimageArray.count; i ++) {
        
        NSDictionary * dic = self.AdimageArray[i];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, 160)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_stastaticHttpUrl,dic[@"url"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
        [scrollview addSubview:imageView];
        
    }
    NSLog(@"%zd",self.AdimageArray.count);
    pageControl.numberOfPages = self.AdimageArray.count;

  
}

-(void)dealloc{
    NSLog(@"dasdsadasdas");
}

@end
