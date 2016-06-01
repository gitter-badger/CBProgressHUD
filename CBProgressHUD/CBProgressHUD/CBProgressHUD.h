//
//  CBProgressHUD.h
//  CBProgressHUD
//
//  Created by 陈超邦 on 16/6/2.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CBProgressHUDMode) {
    /**
     *  文字指示器
     */
    CBProgressHUDModeText               = 1 << 0,
    /**
     *  菊花指示器
     */
    CBProgressHUDModeIndeterminate      = 1 << 1,
    /**
     *  下载指示器
     */
    CBProgressHUDModeAnnularDeterminate  = 1 << 2
};

@interface CBProgressHUD : UIView

/**
 *  下载进度
 */
@property (assign, nonatomic) float progress;

/**
 *  弹出HUD
 *
 *  @param view     附着的视图层
 *  @param mode     指示器类型
 *  @param text     文字
 *  @param animated 动画
 *
 *  @return 实例化对象
 */
+ (instancetype)showHUDAddedTo:(UIView *)view
                          mode:(CBProgressHUDMode)mode
                          text:(NSString *)text
                      animated:(BOOL)animated;

/**
 *  隐藏所有HUD
 *
 *  @param view     附着的视图层
 *  @param animated 动画
 *
 */
+ (void)hideHUDForView:(UIView *)view
              animated:(BOOL)animated;

/**
 *  隐藏单个HUD
 *
 *  @param animated 动画
 */
- (void)hideAnimated:(BOOL)animated;

/**
 *  在一定时间后隐藏单个HUD
 *
 *  @param animated 动画
 *  @param delay    时间间隔
 */
- (void)hideAnimated:(BOOL)animated
          afterDelay:(NSTimeInterval)delay;

@end

@interface CBProgressView : UIView

@property (assign, nonatomic) float progress;

@end
