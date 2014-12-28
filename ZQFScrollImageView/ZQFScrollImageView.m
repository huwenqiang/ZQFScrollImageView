//
//  ZQFScrollowImage.m
//  ScrollowImageSDK
//
//  Created by zengqingfu on 14/12/27.
//  Copyright (c) 2014年 zengqingfu. All rights reserved.
//

#import "ZQFScrollImageView.h"

@interface ZQFScrollImageView()<UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
    UIPageControl *pageCtrl;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    
    NSTimer *timer;
}
//点击触发的block
@property (nonatomic, strong) void (^click)(NSInteger pageIndex);

@end

@implementation ZQFScrollImageView

//初始化方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews:frame];
        
        //添加手势
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
        [self addGestureRecognizer:tapGest];
        
    }
    return self;
}

//配置图片
- (void)setImages:(NSArray *)images
{
    if (images != _images) {
        _images = images;
        
        NSInteger count = images.count;
        
        if (count > 1) {
            mainScrollView.scrollEnabled = YES;
        }
        
        pageCtrl.numberOfPages = count;
        pageCtrl.hidden = NO;
        
        [self resetImages];
    }
}
//当前页数减一
- (void)currentPageDown
{
    _currentPage = (_currentPage - 1 + pageCtrl.numberOfPages) % pageCtrl.numberOfPages;
    pageCtrl.currentPage = _currentPage;
}
//当前页数加一
- (void)currentPageUp
{
    _currentPage = (_currentPage + 1) % pageCtrl.numberOfPages;
    pageCtrl.currentPage = _currentPage;
}

//下一页
- (void)nextPage
{
    CGPoint offset2 = CGPointMake(self.frame.size.width * 2, 0);
    [mainScrollView setContentOffset:offset2 animated:YES];
}
//定时器执行
- (void)timerAction:(id)sender
{
    if (mainScrollView.isDragging || mainScrollView.isDecelerating) {
        return;
    }
    
    [self nextPage];
}

//重置图片
- (void)resetImages
{
    NSInteger index1 = (_currentPage - 1 + pageCtrl.numberOfPages) % pageCtrl.numberOfPages;
    NSInteger index2 = _currentPage;
    NSInteger index3 = (_currentPage + 1 + pageCtrl.numberOfPages) % pageCtrl.numberOfPages;

    imageView1.image = self.images[index1];
    imageView2.image = self.images[index2];
    imageView3.image = self.images[index3];
}

//重置偏移量
- (void)resetOffset
{
    CGPoint offset = CGPointMake(self.frame.size.width, 0);
    [mainScrollView setContentOffset:offset];
}

/**
 *  初始化pageControl和scrollView，同时初始化scroll上的三个imageView
 *
 *  @param frame 当前view的frame
 */
- (void)initSubViews:(CGRect)frame
{
    //计算pageControl的高度-大概是否view的1/3高
    CGFloat pcHeight = frame.size.height / 3;
    //如果高度超过了40就给40
    if (frame.size.height > 40) {
        pcHeight = 40;
    }
    //如果高度小于10就给10好了
    if (frame.size.height < 10 && frame.size.height > 10) {
        pcHeight = 10;
    }
    CGRect pcRect = CGRectMake(0, frame.size.height - pcHeight, frame.size.width, pcHeight);
    //初始化pageControl和scrollView
    pageCtrl = [[UIPageControl alloc] initWithFrame:pcRect];
    pageCtrl.hidesForSinglePage = YES;
    pageCtrl.hidden = YES;
    
    //配置mainScrollview
    CGRect scRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    mainScrollView = [[UIScrollView alloc] initWithFrame:scRect];
    mainScrollView.contentSize = CGSizeMake(frame.size.width * 3, 0);
    mainScrollView.contentOffset = CGPointMake(frame.size.width, 0);
    mainScrollView.delegate = self;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.scrollEnabled = NO;
    
    //计算三个imageView的Rect
    CGRect ivRect1 = CGRectMake(frame.size.width * 0, 0, frame.size.width, frame.size.height);
    CGRect ivRect2 = CGRectMake(frame.size.width * 1, 0, frame.size.width, frame.size.height);
    CGRect ivRect3 = CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height);
    
    //初始化三个imageView
    imageView1 = [[UIImageView alloc] initWithFrame:ivRect1];
    imageView2 = [[UIImageView alloc] initWithFrame:ivRect2];
    imageView3 = [[UIImageView alloc] initWithFrame:ivRect3];
    
    //添加到scrollow上去
    [mainScrollView addSubview:imageView1];
    [mainScrollView addSubview:imageView2];
    [mainScrollView addSubview:imageView3];
    
    //添加到父视图上
    [self addSubview:mainScrollView];
    [self addSubview:pageCtrl];
    
}

//定时器开关
- (void)start
{
    if (timer == nil) {
        if (self.timerInterval <= 0) {
            self.timerInterval = 5;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    [timer fire];
}
- (void)stop
{
    [timer invalidate];
    timer = nil;
}

#pragma mark - 代理-
//代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.x <= 0) {
        [self currentPageDown];
        [self resetImages];
        [self resetOffset];
    } else if (currentOffset.x >= self.frame.size.width*2) {
        [self currentPageUp];
        [self resetImages];
        [self resetOffset];
    }
    
}

#pragma mark -点击相关
//当view被点击的时候返回当前的页数
- (void)viewTapAction:(id)sender
{
    if (_click != nil) {
        self.click(_currentPage);
    }
}
//配置点击block
- (void)clickAction:(void (^)(NSInteger pageIndex))click;
{
    if (click != _click) {
        self.click = click;
    }
}
@end
