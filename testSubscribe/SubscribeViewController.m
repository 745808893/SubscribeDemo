//
//  SubscribeViewController.m
//  testSubscribe
//
//  Created by wls on 2018/5/21.
//  Copyright © 2018年 ChaoXing. All rights reserved.
//

#import "SubscribeViewController.h"
#import "CXSubscribeView.h"
#import "IQKeyboardManager.h"
#import "FSTextView.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define ITEMWIDTH SCREENW/6
#define ITEMHRIGHT 40
#define KLIVEISIPHONEX  MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)==812.0
#define IPHONEXLIVETOPSPACE      (KLIVEISIPHONEX?24:0)
#define IPHONEXLIVEBOTTOMSPACE   (KLIVEISIPHONEX?34:0)

@interface SubscribeViewController ()<CXSubscribeViewDelegate>
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) CXSubscribeView *subscribeView;
@property (nonatomic,strong) FSTextView *remarkView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UITextField *startTime;
@property (nonatomic,strong) UITextField *endTime;
@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"可预约时间";
    [self setUpUI];
    //配置别人选的
    [self configOtherSelectedData];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
//确认预约
- (void)submitBtnAction:(UIButton *)sender{
   NSArray *currentSelectInfo = [[self.subscribeView getCurrentSelectInfo] copy];
   [self.subscribeView addSelectedDataWithSelectInfo:currentSelectInfo];
}
-(void)configOtherSelectedData{
    [self.subscribeView addOtherSelectedDataWithInfo:self.otherSubscribeArr];
}
#pragma mark CXSubscribeViewDelegate
-(void)selecChangedWithInfo:(NSDictionary *)info{
    NSString *starTime = [[NSString stringWithFormat:@"%@", info[STARTTIME]] componentsSeparatedByString:@":"][0];
    NSString *endTime = [[NSString stringWithFormat:@"%@", info[ENDTIME]] componentsSeparatedByString:@":"][0];
    self.startTime.text = starTime;
    self.endTime.text = endTime;
}
-(void)setUpUI{
    CGFloat navH = 0;
    CGFloat topSpace = navH+40;
    //背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.bgScrollView.contentSize = CGSizeMake(SCREENW,topSpace+ITEMHRIGHT*11+160);
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bgScrollView];
    
    //可预约时间
    UIView *schunkView = [[UIView alloc] initWithFrame:CGRectMake(ITEMWIDTH, 10+navH, 15, 15)];
    schunkView.layer.borderWidth = 0.5;
    schunkView.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    schunkView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:schunkView];
    UILabel *schunkLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(schunkView.frame)+5, 10+navH, 70, 15)];
    schunkLabel.text = @"可预约时间";
    schunkLabel.font = [UIFont systemFontOfSize:12];
    schunkLabel.textColor = [UIColor grayColor];
    [self.bgScrollView addSubview:schunkLabel];
    
    //其他人预约
    UIView *ochunkView = [[UIView alloc] initWithFrame:CGRectMake((SCREENW - ITEMWIDTH)/3+ITEMWIDTH, 10+navH, 15, 15)];
    ochunkView.layer.borderWidth = 0.5;
    ochunkView.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    ochunkView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [self.bgScrollView addSubview:ochunkView];
    UILabel *ochunkLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ochunkView.frame)+5, 10+navH, 70, 15)];
    ochunkLabel.text = @"其他人预约";
    ochunkLabel.font = [UIFont systemFontOfSize:12];
    ochunkLabel.textColor = [UIColor grayColor];
    [self.bgScrollView addSubview:ochunkLabel];
    
    //已预约
    UIView *mchunkView = [[UIView alloc] initWithFrame:CGRectMake((SCREENW - ITEMWIDTH)*2/3+ITEMWIDTH, 10+navH, 15, 15)];
    mchunkView.layer.borderWidth = 0.5;
    mchunkView.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    mchunkView.backgroundColor = [UIColor colorWithRed:0.98 green:0.75 blue:0.44 alpha:1.00];
    [self.bgScrollView addSubview:mchunkView];
    UILabel *mchunkLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mchunkView.frame)+5, 10+navH, 70, 15)];
    mchunkLabel.text = @"已预约";
    mchunkLabel.font = [UIFont systemFontOfSize:12];
    mchunkLabel.textColor = [UIColor grayColor];
    [self.bgScrollView addSubview:mchunkLabel];
    //内容
    self.subscribeView = [[CXSubscribeView alloc] initWithFrame:CGRectMake(0, topSpace, [UIScreen mainScreen].bounds.size.width, 480)];
    self.subscribeView.delegate = self;
    [self.bgScrollView addSubview:self.subscribeView];
    
    UILabel *stimetitle = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.subscribeView.frame)+topSpace+10-64, 60, 20)];
    stimetitle.textColor = [UIColor grayColor];
    stimetitle.text = @"具体时间";
    stimetitle.font = [UIFont systemFontOfSize:13];
    [self.bgScrollView addSubview:stimetitle];
    _startTime = [self getDateTextField];
    _startTime.frame = CGRectMake(CGRectGetMaxX(stimetitle.frame), stimetitle.frame.origin.y, 20, 20);
    [self.bgScrollView addSubview:_startTime];
    UILabel *colon1 = [self getDateLabel];
    colon1.frame = CGRectMake(CGRectGetMaxX(_startTime.frame), _startTime.frame.origin.y, 15, 20);
    colon1.text = @":";
    [self.bgScrollView addSubview:colon1];
    UITextField *startTimeFoot = [self getDateTextField];
    startTimeFoot.frame = CGRectMake(CGRectGetMaxX(colon1.frame), _startTime.frame.origin.y, 20, 20);
    startTimeFoot.text = @"00";
    [self.bgScrollView addSubview:startTimeFoot];
    UILabel *spaceLine = [self getDateLabel];
    spaceLine.frame = CGRectMake(CGRectGetMaxX(startTimeFoot.frame), _startTime.frame.origin.y, 20, 20);
    spaceLine.text = @"一";
    spaceLine.textColor = [UIColor grayColor];
    [self.bgScrollView addSubview:spaceLine];
    _endTime = [self getDateTextField];
    _endTime.frame = CGRectMake(CGRectGetMaxX(spaceLine.frame), _startTime.frame.origin.y, 20, 20);
    [self.bgScrollView addSubview:_endTime];
    UILabel *colon2 = [self getDateLabel];
    colon2.frame = CGRectMake(CGRectGetMaxX(_endTime.frame), _startTime.frame.origin.y, 15, 20);
    colon2.text = @":";
    [self.bgScrollView addSubview:colon2];
    UITextField *endTimeFoot = [self getDateTextField];
    endTimeFoot.frame = CGRectMake(CGRectGetMaxX(colon2.frame), _startTime.frame.origin.y, 20, 20);
    endTimeFoot.text = @"00";
    [self.bgScrollView addSubview:endTimeFoot];
    _remarkView = [[FSTextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_startTime.frame)+20, SCREENW-30, 80)];
    _remarkView.placeholder = @"添加备注...";
    _remarkView.placeholderColor = [UIColor grayColor];
    _remarkView.placeholderFont = [UIFont systemFontOfSize:14];
    _remarkView.maxLength = 140;
    //    _remarkView.textColor = [UIColor grayColor];
    _remarkView.layer.borderWidth = 0.5;
    //    _remarkView.returnKeyType = UIReturnKeyDone;
    _remarkView.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    _remarkView.layer.cornerRadius = 3;
    [self.bgScrollView addSubview:_remarkView];
    _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.view.bounds.size.height-40-IPHONEXLIVEBOTTOMSPACE, SCREENW-30, 40)];
    _submitBtn.backgroundColor = [UIColor colorWithRed:0.14 green:0.59 blue:0.96 alpha:1.00];
    _submitBtn.layer.cornerRadius = 4;
    [_submitBtn setTitle:@"确认预约" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
}
-(UITextField *)getDateTextField{
    UITextField *tf = [[UITextField alloc] init];
    tf.layer.borderWidth = 0.5;
    tf.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    tf.userInteractionEnabled = NO;
    tf.font = [UIFont systemFontOfSize:12];
    tf.textColor = [UIColor darkGrayColor];
    tf.textAlignment = NSTextAlignmentCenter;
    return tf;
}
-(UILabel *)getDateLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    return label;
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
