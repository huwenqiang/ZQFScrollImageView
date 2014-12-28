//
//  ZQFScrollowImage.h
//  ScrollowImageSDK
//  
//  Created by zengqingfu on 14/12/27.
//  Copyright (c) 2014年 zengqingfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQFScrollImageView : UIView
//设置图片对象（UIImage）,有多少页就设置多少图片
@property(nonatomic, strong, readwrite) NSArray *images;
//返回当前的展示的页码
@property(nonatomic, assign, readonly)  NSInteger currentPage;

//设置timer的轮播间隔时间
@property(nonatomic, assign, readwrite)NSTimeInterval timerInterval;

//初始化方法
- (id)initWithFrame:(CGRect)frame;
//点击的时候返回
- (void)clickAction:(void (^)(NSInteger pageIndex))click;
//timer开始与停止
- (void)start;
- (void)stop;

@end
