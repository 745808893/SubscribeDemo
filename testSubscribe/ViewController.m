//
//  ViewController.m
//  testSubscribe
//
//  Created by wls on 2018/5/3.
//  Copyright © 2018年 ChaoXing. All rights reserved.
//

#import "ViewController.h"
#import "SubscribeViewController.h"
#import "IQKeyboardManager.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *startTF;
@property (weak, nonatomic) IBOutlet UITextField *endTF;
@property (weak, nonatomic) IBOutlet UITextField *weekTF;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (nonatomic,strong)UIPickerView *startPickerView;
@property (nonatomic,strong)UIPickerView *endPickerView;
@property (nonatomic,strong)UIPickerView *weekPickerView;
@property (nonatomic,strong)NSArray *timeArr;
@property (nonatomic,strong)NSArray *weekArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 选择框
    self.startPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-200, self.view.bounds.size.height, 200)];
    // 显示选中框
     self.startPickerView.showsSelectionIndicator=YES;
     self.startPickerView.dataSource = self;
     self.startPickerView.delegate = self;
    
    self.endPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-200, self.view.bounds.size.height, 200)];
    // 显示选中框
    self.endPickerView.showsSelectionIndicator=YES;
    self.endPickerView.dataSource = self;
    self.endPickerView.delegate = self;
    
    self.weekPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-200, self.view.bounds.size.height, 200)];
    // 显示选中框
    self.weekPickerView.showsSelectionIndicator=YES;
    self.weekPickerView.dataSource = self;
    self.weekPickerView.delegate = self;

    self.startTF.inputView = self.startPickerView;
    self.endTF.inputView = self.endPickerView;
    self.weekTF.inputView = self.weekPickerView;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
}
- (IBAction)clearAction:(id)sender {
    NSArray *cacheArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscribe"];
    if (cacheArr&&cacheArr.count>0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subscribe"];
    }
}
- (IBAction)GoBtnAction:(id)sender {
    if ([self isConfigOtherSubscribe]) {
        SubscribeViewController *vc = [[SubscribeViewController alloc] init];
        vc.otherSubscribeArr = @[@{@"startTime":self.startTF.text,@"endTime":self.endTF.text,@"weekTime":self.weekTF.text,@"remark":self.titleTF.text}];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(BOOL)isConfigOtherSubscribe{
    if (self.startTF.text&&self.endTF.text&&self.weekTF.text&&![self.startTF.text isEqualToString:@""]&&![self.endTF.text isEqualToString:@""]&&![self.weekTF.text isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}
#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.startPickerView || pickerView == self.endPickerView) {
        return self.timeArr.count;
    }else{
        return self.weekArr.count;
    }
}
#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.startPickerView) {
        NSLog(@"time%@",self.timeArr[row]);
        self.startTF.text = self.timeArr[row];
    }else if(pickerView == self.endPickerView){
        NSLog(@"time%@",self.timeArr[row]);
        self.endTF.text = self.timeArr[row];
    }else{
        NSLog(@"week%@",self.weekArr[row]);
        self.weekTF.text = self.weekArr[row];
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.startPickerView || pickerView == self.endPickerView) {
        return self.timeArr[row];
    }else{
        return self.weekArr[row];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(NSArray *)timeArr{
    if (!_timeArr) {
        _timeArr = @[@"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00"];
    }
    return _timeArr;
}
-(NSArray *)weekArr{
    if (!_weekArr) {
        _weekArr = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    }
    return _weekArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
