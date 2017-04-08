//
//  ZJFCommentStarView.h
//  ZJFCommentStarView
//
//  Created by 简而言之 on 2017/4/8.
//  Copyright © 2017年 jiafa.apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
/** 对应字符串宏定义 */
#define kBACKGBIGROUND_STAR @"ggs_LightBigStar"
#define kFOREGBIGROUND_STAR @"ggs_grayBigStar"
#define kBACKGSMALLROUND_STAR @"ggs_LightSmallStar"
#define kFOREGSMALLROUND_STAR @"ggs_graySmallStar"
#define kNUMBER_OF_STAR  5

@class ZJFCommentStarView;
/** 设置代理 */
@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(ZJFCommentStarView *)view score:(float)score;

@end
/** starView类型*/
typedef NS_ENUM(NSInteger, GGSStarViewType) {
    GGSStarViewTypeFull = 0,
    GGSStarViewTypePart
};

@interface ZJFCommentStarView : UIView
/** 星星个数 */
@property (nonatomic, readonly) int numberOfStar;
/** 记录view的原始宽 */
@property (nonatomic, assign) CGFloat originalWidth;
/** 第一个Star与view的边距 */
@property (nonatomic, assign) CGFloat marginWidth;
/** Star之间的间距长 */
@property (nonatomic, assign) CGFloat spacingWidth;
/** single star width */
@property (nonatomic, assign) CGFloat starWidth;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

/** 设置frame 以及 星星数 */
- (void)setupNumberOfStar:(int)number originalWidth:(CGFloat )width margin:(CGFloat )marginWidth spacing:(CGFloat )spacingWidth star:(CGFloat )starWidth;
/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

/** 通过外部赋值来来设定偏移量 */
- (void)setupViewoffsetWithParameter:(CGFloat )offset;

/** 重写init */
-(instancetype)initWithFrame:(CGRect)frame number:(NSUInteger )number type:(GGSStarViewType )type;
@end
