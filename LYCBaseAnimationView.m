//
//  LYCBaseAnimationView.m
//  LYCCarProgressAnimation
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import "LYCBaseAnimationView.h"
#import "LYCCircleAnimationView.h"
#import "Masonry.h"

@interface LYCBaseAnimationView ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) LYCCircleAnimationView *caView;
@property(strong,nonatomic)UIImageView *backImgView;
@property(strong,nonatomic)UIImageView *FabulousImgView;
@property (strong, nonatomic) UIButton *clickBtn;
@property (assign, nonatomic) NSInteger btnTag;
@end
@implementation LYCBaseAnimationView

- (instancetype)initWithFrame:(CGRect)frame withType:(AnimationType)rateType
{
    self = [super initWithFrame:frame];
    if (self) {
        if (rateType == AnimationPerform) {
            [self creatAnimationPerformUI];
        }else{
            [self creatRateTypeFinishFinishUI];
        }
    }
    return self;
}

//Finish
- (void)creatRateTypeFinishFinishUI
{
    [self addSubview:self.backImgView];
    [self.backImgView addSubview:self.FabulousImgView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.FabulousImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImgView);
        make.centerY.equalTo(self.backImgView).offset(-10);
        
    }];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@0, @0.25, @0.5, @0.75, @1.0,@1.5,@1.0];
    animation.duration = 1.f;
    animation.calculationMode = kCAAnimationPaced;
    [self.FabulousImgView.layer addAnimation:animation forKey:@"transform.scale"];
    
}

// perform
- (void)creatAnimationPerformUI
{
    self.caView= [[LYCCircleAnimationView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, 162)];
    self.caView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.caView];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.caView.mas_bottom).offset(24);
    }];
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

- (void)setPercentStr:(NSString *)percentStr
{
    _percentStr = percentStr;
    self.caView.percentStr = percentStr;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:16.f];
    }
    return _titleLab;
}


- (UIImageView *)backImgView
{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ppc_finish"]];
        [_backImgView sizeToFit];
    }
    return _backImgView;
}

- (UIImageView *)FabulousImgView
{
    if (!_FabulousImgView) {
        _FabulousImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ppc_commend"]];
        [_FabulousImgView sizeToFit];
    }
    return _FabulousImgView;
}

@end
