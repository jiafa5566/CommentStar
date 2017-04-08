//
//  ViewController.m
//  ZJFCommentStarView
//
//  Created by 简而言之 on 2017/4/8.
//  Copyright © 2017年 jiafa.apple. All rights reserved.
//

#import "ViewController.h"

#import "ZJFCommentStarView.h"

#define TITLE_TEXt @"星星评价"
#define TEXTFIELD_TEXT @"请输入指定参数"
#define BUTTON_TEXT @"设置"
@interface ViewController ()<StarRatingViewDelegate>
@property (nonatomic, strong) ZJFCommentStarView *starView;
@property (nonatomic, strong) UILabel *valueLabel;
/** 输入指定数值 */
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = TITLE_TEXt;
    // 添加SubViews
    [self p_setupSubViewsLayout];
    
    self.starView.delegate = self;
    [self.starView setupNumberOfStar:5 originalWidth:SCREEN_WIDTH margin:(70 * SCREEN_WIDTH) / 375 spacing:(15 * SCREEN_WIDTH) / 375 star:(35 * SCREEN_WIDTH) / 375];
}

#pragma mark ----- StarRatingViewDelegate
-(void)starRatingView:(ZJFCommentStarView *)view score:(float)score
{
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",score];
}

#pragma mark ----- Privation
- (void)p_setupSubViewsLayout
{
    [self.view addSubview:self.starView];
    [self.view addSubview:self.valueLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.button];
    __weak typeof(self) weakSelf = self;
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.height.equalTo(@(70));
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.starView.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.valueLabel.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.textField.mas_bottom).offset(30);
        make.height.equalTo(@100);
    }];
}
- (void)clickBtn:(UIButton *)btn
{
    if (self.textField.text != nil && self.textField.text.floatValue >= 0 && self.textField.text.floatValue <= 5) {
        [self.starView setupViewoffsetWithParameter:self.textField.text.floatValue];
    }
    else
    {
        NSLog(@"超出评分限制");
    }
}

#pragma mark ----- Getter
- (ZJFCommentStarView *)starView
{
    if (_starView == nil) {
        _starView = [[ZJFCommentStarView alloc] initWithFrame:CGRectZero number:5 type:(GGSStarViewTypeFull)];
    }
    return _starView;
}
- (UILabel *)valueLabel
{
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.backgroundColor = [UIColor greenColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLabel;
}
- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.placeholder = TEXTFIELD_TEXT;
    }
    return _textField;
}
- (UIButton *)button
{
    if (_button == nil) {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        _button.backgroundColor = [UIColor lightGrayColor];
        [_button setTitle:BUTTON_TEXT forState:(UIControlStateNormal)];
        [_button addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
