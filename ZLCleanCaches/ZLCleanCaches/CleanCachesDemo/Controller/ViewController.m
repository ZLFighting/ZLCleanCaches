//
//  ViewController.m
//  ZLCleanCaches
//
//  Created by ZL on 2017/7/25.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ViewController.h"
#import "CleanCaches.h"

#define UI_View_Width   [UIScreen mainScreen].bounds.size.width // 屏幕宽度


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 实现一个跳转入口而已~
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"进入测试" forState:UIControlStateNormal];
    btn.frame = CGRectMake(15, 100, UI_View_Width - 15 * 2, 40);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 3.0;
    btn.clipsToBounds = YES;
    [self.view addSubview:btn];
}


- (void)btnPress {
    
    // 显示清理缓存数字弹框
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    float size = [CleanCaches folderSizeAtPath:cachesDir];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清理" message:[NSString stringWithFormat:@"已清理%.2lfM缓存", size] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [CleanCaches clearCache:cachesDir];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
