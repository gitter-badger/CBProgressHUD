//
//  CBProgressHUD.m
//  CBProgressHUD
//
//  Created by 陈超邦 on 16/6/2.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBProgressHUD.h"

@interface CBProgressHUD()

@property (strong, nonatomic, readwrite) UIView             *backgroundView;
@property (strong, nonatomic, readwrite) UIView             *indicatorView;
@property (strong, nonatomic, readwrite) UILabel            *frontLabel;
@property (strong, nonatomic, readwrite) NSTimer            *timer;
@property (assign, nonatomic, readwrite) CBProgressHUDMode   mode;

@end

@implementation CBProgressHUD

#pragma 方法实现
+ (instancetype)showHUDAddedTo:(UIView *)view
                          mode:(CBProgressHUDMode)mode
                          text:(NSString *)text
                      animated:(BOOL)animated {
    CBProgressHUD *progressHUD = [[self alloc] initWithSuperView:view];
    progressHUD.frontLabel.text = text;
    progressHUD.mode = mode;
    [progressHUD updateIndicators];
    [view addSubview:progressHUD];
    [progressHUD showIn:YES Animated:YES];
    return progressHUD;
}

- (void)hideAnimated:(BOOL)animated {
    [self showIn:NO Animated:YES];
}

+ (void)hideHUDForView:(UIView *)view
              animated:(BOOL)animated {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:self]) {
            CBProgressHUD *progressHUD = (CBProgressHUD *)subview;
            [progressHUD showIn:NO Animated:YES];
        }
    }
}

- (void)hideAnimated:(BOOL)animated
          afterDelay:(NSTimeInterval)delay {
    NSTimer *timer = [NSTimer timerWithTimeInterval:delay
                                             target:self
                                           selector:@selector(handleHideTimer:)
                                           userInfo:@(animated)
                                            repeats:NO];
    _timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma 杂项
- (void)handleHideTimer:(NSTimer *)timer {
    [self showIn:NO Animated:[timer.userInfo boolValue]];
}

- (void)showIn:(BOOL)showIn
      Animated:(BOOL)animated {
    
    CGFloat viewAlpha;
    if (showIn) {
        _backgroundView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        viewAlpha = 1.f;
    }else {
        [_timer invalidate];
        [self removeFromSuperview];
        
        _backgroundView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        viewAlpha = 0.f;
    }
    
    if (animated) {
        
        [self.backgroundView.layer removeAllAnimations];
        
        dispatch_block_t animations = ^{
            _backgroundView.transform = CGAffineTransformIdentity;
            
            if (!showIn) {
                _backgroundView.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
            }
            
            _backgroundView.alpha = viewAlpha;
        };
        
        [UIView animateWithDuration:0.3f
                              delay:0.f
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:animations
                         completion:nil];
    }else {
        _backgroundView.alpha = viewAlpha;
    }
    
}

- (void)setProgress:(float)progress {
    if (_mode != CBProgressHUDModeAnnularDeterminate) return;
    
    if (progress != _progress) {
        _progress = progress;
        CBProgressView *indicator = (CBProgressView *)_indicatorView;
        indicator.progress = progress;
    }
}

#pragma 视图初始化
- (instancetype)initWithSuperView:(UIView *)view {
    self = [super initWithFrame:view.bounds];
    if (self) {
        _mode = CBProgressHUDModeIndeterminate;
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.layer.cornerRadius = 5.f;
        _backgroundView.clipsToBounds = YES;
        _backgroundView.layer.allowsGroupOpacity = NO;
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.895 alpha:0.800];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backgroundView];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _backgroundView.bounds;
        effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_backgroundView addSubview:effectView];
        
        _frontLabel = [[UILabel alloc] init];
        _frontLabel.adjustsFontSizeToFitWidth = NO;
        _frontLabel.textAlignment = NSTextAlignmentCenter;
        _frontLabel.textColor = [UIColor colorWithWhite:0.f alpha:0.7f];
        _frontLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _frontLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_backgroundView addSubview:_frontLabel];
        
    }
    return self;
}

- (void)updateIndicators {
    switch (_mode) {
        case CBProgressHUDModeIndeterminate: {
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [(UIActivityIndicatorView *)_indicatorView startAnimating];
            ((UIActivityIndicatorView *)_indicatorView).color = [UIColor colorWithWhite:0.f alpha:0.7f];
            [_backgroundView addSubview:_indicatorView];
        }
            break;
        case CBProgressHUDModeText: {
            _indicatorView = nil;
        }
            break;
        case CBProgressHUDModeAnnularDeterminate: {
            _indicatorView = [[CBProgressView alloc] init];
            [_backgroundView addSubview:_indicatorView];
        }
            break;
        default: break;
    }
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma 约束处理
- (void)updateConstraints {
    
    NSMutableArray *centeringConstraints = [NSMutableArray array];
    
    [centeringConstraints addObject:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.f
                                                                  constant:0.f]];
    
    [centeringConstraints addObject:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.f
                                                                  constant:0.f]];
    
    [self addConstraints:centeringConstraints];
    
    NSMutableArray *sideConstraints = [NSMutableArray array];
    
    CGFloat marginUpDown;CGFloat marginLeftRight;
    
    if (_mode == CBProgressHUDModeText) {
        marginLeftRight = 30.f;
        marginUpDown = 16.f;
    }else {
        marginLeftRight = 95.f;
        marginUpDown = 18.f;
    }
    
    [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[_backgroundView]-(>=margin)-|"
                                                                                 options:0
                                                                                 metrics:@{@"margin": @(marginLeftRight)}
                                                                                   views:NSDictionaryOfVariableBindings(_backgroundView)]];
    
    [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=margin)-[_backgroundView]-(>=margin)-|"
                                                                                 options:0 metrics:@{@"margin": @(marginLeftRight)}
                                                                                   views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [self addConstraints:sideConstraints];
    
    NSMutableArray *subviews = [NSMutableArray arrayWithObjects:_frontLabel, nil];
    
    if (_indicatorView) {
        [subviews insertObject:_indicatorView atIndex:0];
    }
    
    NSMutableArray *bezelConstraints = [NSMutableArray array];
    
    if (_frontLabel.text.length == 0) {
        [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_backgroundView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.f
                                                                  constant:0.f]];
    }
    
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_backgroundView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.f
                                                                  constant:0.f]];
        
        [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[view]-(>=margin)-|"
                                                                                      options:0
                                                                                      metrics:@{@"margin": @(15.f)}
                                                                                        views:NSDictionaryOfVariableBindings(view)]];
        if (idx == 0) {
            [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_backgroundView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.f
                                                                      constant:marginUpDown]];
        }
        if(idx == subviews.count - 1) {
            [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_backgroundView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.f
                                                                      constant:-marginUpDown]];
        }
        if (idx > 0) {
            
            CGFloat margin_frontLabel = (view == _frontLabel) && (_frontLabel.text.length != 0) && (_mode != CBProgressHUDModeText) ? 8.f : 0.f;
            
            [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:subviews[idx - 1]
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.f
                                                                      constant:margin_frontLabel]];
        }
    }];
    
    [_backgroundView addConstraints:bezelConstraints];
    
    [super updateConstraints];
}


@end

#pragma 进度视图
@interface CBProgressView()
@end

@implementation CBProgressView


- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)setProgress:(float)progress {
    if (progress != _progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(40.f, 40.f);
}


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *backgroundPath = [UIBezierPath bezierPath];
    backgroundPath.lineWidth = 2.f;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = (self.bounds.size.width - 2.f)/2;
    CGFloat startAngle = - ((float)M_PI / 2);
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    [backgroundPath addArcWithCenter:center
                              radius:radius
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];
    [[UIColor colorWithRed:0.503 green:0.519 blue:0.568 alpha:0.550] set];
    [backgroundPath stroke];
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineWidth = 2.f;
    endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    [processPath addArcWithCenter:center
                           radius:radius
                       startAngle:startAngle
                         endAngle:endAngle
                        clockwise:YES];
    [[UIColor colorWithWhite:0.188 alpha:0.700] set];
    [processPath stroke];
    
}

@end
