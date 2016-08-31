//
//  ViewController.m
//  WJAlertViewDemo
//
//  Created by wangjian on 16/8/31.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "ViewController.h"
#import "WJAlertView.h"
@interface ViewController ()<WJAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    // Do any additional setup after loading the view, typically from a nib.

}
- (IBAction)addAlertView:(UIButton *)sender {
    
    if (sender.tag == 0) {
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"是否要退出？"
                                                           delegate:self
                                                    andCancelButton:NO
                                                       forAlertType:AlertViewType_Alert];
        [alertView showAnimated:YES];
    }
    else if (sender.tag == 1){
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请输入登录密码"
                                                           delegate:self
                                                    andCancelButton:YES
                                                       forAlertType:AlertViewType_InputAlert];
        [alertView showAnimated:YES];
    }
    else if (sender.tag == 2){
        
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"正在清理缓存"
                                                           delegate:self
                                                    andCancelButton:YES
                                                       forAlertType:AlertViewType_ProgressView];
        [alertView showAnimated:YES];
    }

}

# pragma  mark - WJAlertView Delegate -
- (void)alertView:(WJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"点击 ：%ld",buttonIndex);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
