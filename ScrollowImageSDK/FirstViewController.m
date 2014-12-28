//
//  FirstViewController.m
//  ScrollowImageSDK
//
//  Created by zengqingfu on 14/12/28.
//  Copyright (c) 2014年 zengqingfu. All rights reserved.
//

#import "FirstViewController.h"
#import "ZQFScrollImageView.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = CGRectMake(0, 90, self.view.frame.size.width, 150);
    ZQFScrollImageView *zView = [[ZQFScrollImageView alloc] initWithFrame:rect];
    zView.backgroundColor = [UIColor lightGrayColor];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 1; i <= 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)i]];
        [array addObject:image];
    }

    zView.images = array;
    zView.timerInterval = 0;
    [zView start];
    [self.view addSubview:zView];
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

@end
