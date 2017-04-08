//
//  GGSCoachStarView.m
//  TQStarRatingView
//
//  Created by 简而言之 on 2017/4/5.
//  Copyright © 2017年 TinyQ. All rights reserved.
//

#import "ZJFCommentStarView.h"

@interface ZJFCommentStarView()
/** UIView */
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@end

@implementation ZJFCommentStarView

-(instancetype)initWithFrame:(CGRect)frame number:(NSUInteger )number type:(GGSStarViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加SubVeiws
        [self p_setupSubViewslayoutwithNumber:number type:type];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _numberOfStar = kNUMBER_OF_STAR;
    //    [self p_setupSubViewslayoutwithNumber:self.numberOfStar type:<#(GGSStarViewType)#>];
}

/** 设置frame 以及 星星数 */
- (void)setupNumberOfStar:(int)number originalWidth:(CGFloat )width margin:(CGFloat )marginWidth spacing:(CGFloat )spacingWidth star:(CGFloat )starWidth
{
    _numberOfStar = number;
    _originalWidth = width;
    _marginWidth = marginWidth;
    _spacingWidth = spacingWidth;
    _starWidth = starWidth;
}

#pragma mark ----- Privation
- (void)p_setupSubViewslayoutwithNumber:(NSInteger)number type:(GGSStarViewType )type
{
    // 创建View
    [self addSubview:self.starBackgroundView];
    [self insertSubview:self.starForegroundView aboveSubview:self.starBackgroundView];
    __weak typeof(self) weakSelf = self;
    [self.starBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    if (type == GGSStarViewTypeFull) {
        [self.starForegroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.and.bottom.equalTo(weakSelf).offset(0);
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
        // view上创建ImageView
        [self P_buidlStarViewWithImageName:kBACKGBIGROUND_STAR view:self.starBackgroundView number:number type:GGSStarViewTypeFull];
        [self P_buidlStarViewWithImageName:kFOREGBIGROUND_STAR view:self.starForegroundView number:number type:GGSStarViewTypeFull];
    }
    else
    {
        [self.starForegroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.and.bottom.equalTo(weakSelf).offset(0);
            make.width.equalTo(@((145 * SCREEN_WIDTH) / 375));
        }];
        // view上创建ImageView
        [self P_buidlStarViewWithImageName:kBACKGSMALLROUND_STAR view:self.starBackgroundView number:number type:GGSStarViewTypePart];
        [self P_buidlStarViewWithImageName:kFOREGSMALLROUND_STAR view:self.starForegroundView number:number type:GGSStarViewTypePart];
    }
}

#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate
{
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数 ，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion
{
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0){
        score = 0;
    }
    
    if (score > 1){
        score = 1;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate){
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf changeStarForegroundViewWithPoint:point];
        } completion:^(BOOL finished){
            if (completion){
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point)){
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf changeStarForegroundViewWithPoint:point];
    }];
}

/*  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (void )P_buidlStarViewWithImageName:(NSString *)imageName view:(UIView *)view number:(NSInteger )number type:(GGSStarViewType )type;
{
    //    CGRect frame = self.bounds;
    view.clipsToBounds = YES;
    switch (type) {
        case GGSStarViewTypeFull:
            for (int i = 0; i < number; i ++){
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [view addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view.mas_top).offset((15 *SCREEN_HEIGHT) / 667);
                    make.bottom.equalTo(view.mas_bottom).offset(- (15 *SCREEN_HEIGHT) / 667);
                    make.right.equalTo(view.mas_right).offset(-(((70 * SCREEN_WIDTH) / 375) + i * ((50 * SCREEN_WIDTH) / 375)));
                    make.width.equalTo(@((35 * SCREEN_WIDTH) / 375));
                    
                }];
            }
            break;
        case GGSStarViewTypePart:
            for (int i = 0; i < number; i ++){
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [view addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view.mas_top).offset((15 * SCREEN_WIDTH) / 375);
                    make.bottom.equalTo(view.mas_bottom).offset(0);
                    make.right.equalTo(view.mas_right).offset(- (i * (31 * SCREEN_WIDTH) / 375));
                    make.width.equalTo(@((21 * SCREEN_WIDTH) / 375));
                }];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Change Star Foreground With Point
/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0){
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width){
        p.x = self.frame.size.width;
    }
    // 计算点击位置与星星点击的比例
    CGFloat score =  [self setupClickProportion:p.x];
    //    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    //    float score = [str floatValue];
    //    p.x = (score / 10) * self.frame.size.width;
    // 根据屏幕点击的位置 重新对self.starForegroundView进行布局
    [self.starForegroundView layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [self.starForegroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(weakSelf.originalWidth - p.x));
    }];
    [self layoutIfNeeded];
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]){
        [self.delegate starRatingView:self score:score];
    }
}

/** 通过外部传进来的值 来设定便宜量 */
- (void)setupViewoffsetWithParameter:(CGFloat)offset
{
    // 根据提供的比例来设置starForegroundView的宽度
    CGFloat offset_x = [self setupWidthWithProportion:offset];
    [self.starForegroundView layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [self.starForegroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(weakSelf.originalWidth - offset_x));
    }];
    [self layoutIfNeeded];
}
/** 计算比例 */
- (CGFloat )setupClickProportion:(CGFloat )location
{
    if (location <= self.marginWidth) {
        return 0.0;
    }
    if (location > self.marginWidth && location <= (self.marginWidth + self.starWidth)) {
        return (location - self.marginWidth) / self.starWidth;
    }
    if (location > (self.marginWidth + self.starWidth) && location <= (self.marginWidth + self.starWidth + self.spacingWidth)) {
        return 1.0;
    }
    if (location > (self.marginWidth + self.starWidth + self.spacingWidth) && location <= (self.marginWidth + 2 * self.starWidth + self.spacingWidth)) {
        return 1.0 + (location - self.marginWidth - self.starWidth - self.spacingWidth) / self.starWidth;
    }
    if (location > (self.marginWidth + 2 * self.starWidth + self.spacingWidth) && location <= (self.marginWidth + 2 * self.starWidth + 2 * self.spacingWidth)) {
        return 2.0;
    }
    if (location > (self.marginWidth + 2 * self.starWidth + 2 * self.spacingWidth) && location <= (self.marginWidth + 3 * self.starWidth + 2 * self.spacingWidth)) {
        return 2.0 + (location - self.marginWidth - 2 *self.starWidth - 2 * self.spacingWidth) / self.starWidth;
    }
    if (location > (self.marginWidth + 3 * self.starWidth + 2 * self.spacingWidth) && location <= (self.marginWidth + 3 * self.starWidth + 3 * self.spacingWidth)) {
        return 3.0;
    }
    if (location > (self.marginWidth + 3 * self.starWidth + 3 * self.spacingWidth) && location <= (self.marginWidth + 4 * self.starWidth + 3 * self.spacingWidth)) {
        return 3.0 + (location - self.marginWidth - 3 * self.starWidth - 3 * self.spacingWidth) / self.starWidth;
    }
    if (location > (self.marginWidth + 4 * self.starWidth + 3 * self.spacingWidth) && location <= (self.marginWidth + 4 * self.starWidth + 4 * self.spacingWidth)) {
        return 4.0;
    }
    if (location > (self.marginWidth + 4 * self.starWidth + 4 * self.spacingWidth) &&  location <= (self.marginWidth + 5 * self.starWidth + 4 * self.spacingWidth)) {
        return 4.0 + (location - self.marginWidth - 4 * self.starWidth - 4 * self.spacingWidth) / self.starWidth;
    }
    if (location > (self.marginWidth + 5 * self.starWidth + 4 * self.spacingWidth)) {
        return 5.0;
    }
    return 0.0;
}

/** 根据设置的比例来设置宽度 */
- (CGFloat )setupWidthWithProportion:(CGFloat )proportion
{
    if (proportion >= 0 && proportion < 1) {
        return self.marginWidth + self.starWidth * proportion;
    }
    if (proportion >= 1 && proportion < 2) {
        return self.marginWidth + self.starWidth * proportion + self.spacingWidth;
    }
    if (proportion >= 2 && proportion < 3) {
        return self.marginWidth + self.starWidth * proportion + 2 * self.spacingWidth;
    }
    if (proportion >= 3 && proportion < 4) {
        return self.marginWidth + self.starWidth * proportion + 3 * self.spacingWidth;
    }
    if (proportion >= 4 && proportion <= 5) {
        return self.marginWidth + self.starWidth * proportion + 4 * self.spacingWidth;
    }
    return 0;
}

#pragma mark ----- Getter
- (UIView *)starBackgroundView
{
    if (_starBackgroundView == nil) {
        _starBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _starBackgroundView;
}

- (UIView *)starForegroundView
{
    if (_starForegroundView == nil) {
        _starForegroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _starForegroundView;
}
@end
