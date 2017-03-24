//
//  ViewController.m
//  WJAlertViewDemo
//
//  Created by wangjian on 16/8/31.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "ViewController.h"
#import "WJAlertView.h"
#import "Header.h"
#import "WJProgressView.h"
#import "WJChartView.h"
@interface ViewController ()<WJAlertViewDelegate,WJChartDelegate,WJChartDataSource>
{

    NSArray *_titlesArray;
    NSArray *_colorArray;
    NSMutableArray *_amountArray;
    float          *_valuesArray;
    WJChartView  *_chartView;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
    _chartView = [[WJChartView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 15)
                                      chartViewType:WJChartViewType_Line];
    _chartView.delegate = self;
    _chartView.dataSource = self;
    [self.view addSubview:_chartView];

}
- (void)initData{

    _titlesArray = [NSArray arrayWithObjects:@"现金(元)",@"前金币", nil];
    _colorArray = [NSArray arrayWithObjects:UIColorFromRGB(0xFFD862),UIColorFromRGB(0x75B2F9), nil];
    _amountArray = [[NSMutableArray alloc] initWithCapacity:_titlesArray.count];
    _amountArray[0] = [NSString stringWithFormat:@"%.2f", 0.3];
    _amountArray[1] = [NSString stringWithFormat:@"%.2f", 0.7];
    
    
    _valuesArray = malloc(sizeof(float) * _titlesArray.count);
    memset(_valuesArray, 0.0f, sizeof(float));
    for (int i = 0; i < _titlesArray.count; i++) {
            //各部分所占百分比
            _valuesArray[i] = [_amountArray[i] doubleValue];
        
    }
}
- (IBAction)addAlertView:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    if (tag == 0) {
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:nil
                                                            message:@"总资产=可用余额+代收本金+冻结资金总资产=可用余额+代收本金+冻结资金总资产=可用余额+代收本金+冻结资金总资产=可用余额+代收本金+冻结资金"
                                                    andCancelButton:NO
                                                       forAlertType:AlertViewType_Alert
                                                       disMissBlock:^(WJAlertView * _Nonnull alert, UIButton * _Nonnull button) {
                                                       }];
        [alertView.confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
        alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
        [alertView showAnimated:YES];
        
    }
    else if (tag == 1){
        
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:@"188****6688"
                                                            message:@"输入登录密码"
                                                    andCancelButton:YES
                                                       forAlertType:AlertViewType_InputAlert
                                                       disMissBlock:^(WJAlertView * _Nonnull alert, UIButton * _Nonnull button) {
                                                       }];
        [alertView showAnimated:YES];
    }
    else if (tag == 2) {
        
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:@"清除缓存完成"
                                                            message:nil
                                                    andCancelButton:YES
                                                       forAlertType:AlertViewType_ProgressView
                                                       disMissBlock:^(WJAlertView * _Nonnull alert, UIButton * _Nonnull button) {
                                                       }];
        [alertView showAnimated:YES];
    }
    else if (tag == 3) {
        
        NSString *title = @"您获得10000元投资体验金";
        NSString *message = @"成功投资获得利息2.78元，可提现哦~";
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                    andCancelButton:YES
                                                       forAlertType:AlertViewType_ImageBackView];
        [alertView.cancelButton setTitle:@"暂不使用" forState:UIControlStateNormal];
        [alertView.confirmButton setTitle:@"使用体验金" forState:UIControlStateNormal];
        
        NSRange titleRange = [title rangeOfString:@"10000元"];
        NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:title];
        [titleAttributeString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff4a00)}
                                      range:titleRange];
        alertView.titleLabel.attributedText = titleAttributeString;
        
        NSRange messageRange = [message rangeOfString:@"2.78"];
        NSMutableAttributedString *messageAttributeString = [[NSMutableAttributedString alloc] initWithString:message];
        [messageAttributeString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff4a00)}
                                        range:messageRange];
        alertView.messageLabel.attributedText = messageAttributeString;
        
        [alertView showAnimated:YES];
        
        
    }
    else if (tag == 4) {
        
        WJAlertView *alertView = [[WJAlertView alloc] initWithTitle:nil
                                                            message:@"1.界面更新，系统优化全面升级\n2.优化投资记录\n3.最新版本2.0.3.3"
                                                    andCancelButton:YES
                                                       forAlertType:AlertViewType_UpdateVersion
                                                       disMissBlock:^(WJAlertView * _Nonnull alert, UIButton * _Nonnull button) {
                                                       }];
        alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
        [alertView showAnimated:YES];
        
    }

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    NSLog(@"刷新");
    [_chartView reloadData];
    
}
# pragma mark----WJChartView Delegate
- (NSUInteger)numberOfSlicesInChart:(WJChartView *)chartView{
    
    return _titlesArray.count;
    
}
- (CGFloat)chartView:(WJChartView *)chartView valueForSliceAtIndex:(NSInteger)index{
    
    NSLog(@"各部分所占比例---->>>%.2f",_valuesArray[index]);
    
    return _valuesArray[index];
}
- (UIColor *)chartView:(WJChartView *)chartView colorForSliceAtIndex:(NSInteger)index{
    
    return _colorArray[index];
    
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
