//
//  ViewController.m
//  NewsProject
//
//  Created by LOVE on 16/6/13.
//  Copyright © 2016年 LOVE. All rights reserved.
//

#import "ViewController.h"


#import "RecommendViewController.h"
#import "EntertainmentViewController.h"
#import "FashionViewController.h"
#import "MitoViewController.h"
#import "MilitaryViewController.h"
#import "SocialViewController.h"
#import "FunnyViewController.h"

#define   ScreenW  [UIScreen mainScreen].bounds.size.width
#define   ScreenH  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollViewTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *contenttView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAllChildViewController];
    [self setupScrollViewTitle];
    [self setupScrollView];
    
    
}
-(NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

#pragma  mark - 设置ScrollView
-(void)setupScrollView{
    
    NSUInteger count = self.childViewControllers.count;
    self.ScrollViewTitle.contentSize = CGSizeMake(count *100, 0);
    self.ScrollViewTitle.showsHorizontalScrollIndicator = NO;
    
    self.contenttView.contentSize = CGSizeMake(count * ScreenW, 0);
    self.contenttView.showsHorizontalScrollIndicator = NO;
    self.contenttView.pagingEnabled = YES;
    self.contenttView.bounces = NO;
    self.contenttView.delegate = self;
}

#pragma mark - 设置滚动的Title
-(void)setupScrollViewTitle{
    
    CGFloat labelY = 0;
    CGFloat labelW = 100;
    CGFloat labelH = 44;
    
    NSUInteger count = self.childViewControllers.count;
    for (int i=0; i<count; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.highlightedTextColor = [UIColor redColor];
        label.tag = i;
        
        CGFloat  labelX = i *labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        UIViewController *vc = self.childViewControllers[i];
        label.text =vc.title;
        
        [self.titleArray addObject:label];
        
        label.userInteractionEnabled  = YES;
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        if (i==0) {
            [self titleClick:tap];
        }
        
        [self.ScrollViewTitle addSubview:label];
        
    }}
#pragma mark - 设置点击的手势 响应事件
-(void)titleClick:(UITapGestureRecognizer*)tap{
    
    UILabel *selectLabel= (UILabel *)tap.view;
    
    //设置选中与没有选中的显示状态
    [self selectLabel:selectLabel];
    
    NSUInteger index = selectLabel.tag;
    CGFloat offsetX = index * ScreenW;
    self.contenttView.contentOffset = CGPointMake(offsetX,0);
    
    
    [self showVC:index];
    
    //设置文字居中
    [self  setupTitleCenter:selectLabel];
}
#pragma mark - 三部曲
-(void)selectLabel:(UILabel *)label{
    
    _selectLabel.highlighted = NO;
    
    _selectLabel.transform = CGAffineTransformIdentity;
    _selectLabel.textColor = [UIColor blackColor];
    
    label.highlighted =YES;
    label.transform = CGAffineTransformMakeScale(1.3,1.3);
    _selectLabel  =label;
    
}

#pragma mark - UIScrollViewDelegated代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSUInteger currentpage =  scrollView.contentOffset.x/ scrollView.bounds.size.width;
    
    //左，右两边的角标
    NSUInteger LeftIndex = currentpage;
    NSUInteger RightIndex = currentpage +1;
    
    //左，右两边的Label
    UILabel *LeftLabel = self.titleArray[LeftIndex];
    UILabel *RightLabel;
    if (RightIndex<self.titleArray.count -1) {
        
        RightLabel = self.titleArray[RightIndex];
    }
    
    //缩放比例
    CGFloat RightScale = currentpage - LeftIndex;
    CGFloat LeftScale = 1- RightScale;
    
    LeftLabel.transform = CGAffineTransformMakeScale(LeftScale*0.3 +1, LeftScale*0.3+1);
    RightLabel.transform = CGAffineTransformMakeScale(RightScale*0.3 +1, RightScale*0.3+1);
    
    
    LeftLabel.textColor = [UIColor colorWithRed:LeftScale green:0 blue:0 alpha:1];
    RightLabel.textColor = [UIColor colorWithRed:RightScale green:0 blue:0 alpha:1];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //1.计算滚动到哪一页
    NSUInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //2.把对应的标题选中
    UILabel *label = self.titleArray[index];
    [self selectLabel:label];
    
    //3.添加子控制器View
    [self showVC:index];
    
    [self setupTitleCenter:label];
}

#pragma mark  - 设置文字居中
-(void)setupTitleCenter:(UILabel *)label{
    
    CGFloat offsetX = label.center.x - ScreenW *0.5;
    
    if (offsetX<0) offsetX = 0;
    
    CGFloat maxoffsetX = self.ScrollViewTitle.contentSize.width - ScreenW;
    
    if (maxoffsetX<0) offsetX = maxoffsetX;
    
    [self.ScrollViewTitle setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void)showVC:(NSUInteger)index{
    CGFloat offsetX = index *ScreenW;
    
    UIViewController *vc = self.childViewControllers[index];
    if (vc.isViewLoaded) return;
    vc.view.frame = CGRectMake(offsetX, 0, ScreenW, ScreenH);
    [self.contenttView addSubview:vc.view];
    
}
#pragma mark - 初始化所有子控制器
-(void)setupAllChildViewController{
    RecommendViewController *recom = [[RecommendViewController alloc]init];
    recom.title = @"推荐";
    [self addChildViewController:recom];
    
    EntertainmentViewController *en = [[EntertainmentViewController alloc]init];
    en.title = @"娱乐";
    [self addChildViewController:en];
    
    FunnyViewController *funny = [[FunnyViewController alloc]init];
    funny.title = @"搞笑";
    [self addChildViewController:funny];
    
    MitoViewController *mico = [[MitoViewController alloc]init];
    mico.title = @"美图";
    [self addChildViewController:mico];
    
    MilitaryViewController *mili = [[MilitaryViewController alloc]init];
    mili.title = @"军事";
    [self addChildViewController:mili];
    
    SocialViewController *soci = [[SocialViewController alloc]init];
    soci.title = @"社会";
    [self addChildViewController:soci];
    
    FashionViewController *fash = [[FashionViewController alloc]init];
    fash.title = @"时尚";
    [self addChildViewController:fash];
    
}

@end
