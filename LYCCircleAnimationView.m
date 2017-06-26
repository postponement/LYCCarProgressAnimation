//
//  LYCCircleAnimationView.m
//  LYCCarProgressAnimation
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import "LYCCircleAnimationView.h"
#import "LYCCircleView.h"
#import "LYCPointerView.h"
#import "Masonry.h"


#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define AnimationIntertime 1.5

@interface LYCCircleAnimationView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) LYCCircleView *circleView;
@property (nonatomic, strong) LYCPointerView *pointerView;
@property(strong,nonatomic)UILabel *targetLab;
@property (strong, nonatomic) UILabel *finishLab;
@property (strong, nonatomic) UILabel *practiceLab;
@property (strong, nonatomic) UIImageView *imgView;
@end
@implementation LYCCircleAnimationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

-(void)configViews{
    [self addSubview:self.finishLab];
    [self addSubview:self.practiceLab];
    [self addSubview:self.targetLab];
    [self addSubview:self.imgView];
    [self instanceCircle];
    [self instancePointerView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.practiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.finishLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.practiceLab);
        make.bottom.equalTo(self.practiceLab.mas_top).offset(-7);
    }];
    
    [self.targetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.practiceLab);
        make.top.equalTo(self.practiceLab.mas_bottom).offset(7);
    }];
    
    
    //图像添加点击事件（手势方法）
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    PrivateLetterTap.delegate= self;
    self.imgView.contentMode = UIViewContentModeScaleToFill;
    [self.imgView addGestureRecognizer:PrivateLetterTap];
}

- (void)tapAvatarView: (UITapGestureRecognizer *)gesture
{
    
    
    
}

//初始化圆圈
-(void)instanceCircle{
    self.circleView = [[LYCCircleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:self.circleView];
}

-(void)instancePointerView{
    self.pointerView = [[LYCPointerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:self.pointerView];
}

//set
-(void)setPercentStr:(NSString *)percentStr{
    self.practiceLab.text = [NSString stringWithFormat:@"%.2f",[percentStr floatValue]];
    if(![_percentStr isEqualToString:percentStr]){
        [self.pointerView updatePointer:[percentStr integerValue] withAnimationTime:[percentStr integerValue]/100 *AnimationIntertime];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.96 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.circleView makeCircle:[percentStr integerValue] withAnimationTime:AnimationIntertime];
        });
    }
    _percentStr = percentStr;
}

- (UILabel *)finishLab
{
    if (!_finishLab) {
        _finishLab = [[UILabel alloc] init];
        _finishLab.text = @"已完成";
        _finishLab.textColor = [UIColor whiteColor];
        _finishLab.font = [UIFont systemFontOfSize:14.f];
    }
    return _finishLab;
}

- (UILabel *)targetLab
{
    if (!_targetLab) {
        _targetLab = [[UILabel alloc] init];
        _targetLab.text = @"目标:100小时";
        _targetLab.textColor = [UIColor whiteColor];
        _targetLab.font = [UIFont systemFontOfSize:12.f];
    }
    return _targetLab;
};

- (UILabel *)practiceLab
{
    if (!_practiceLab) {
        _practiceLab = [[UILabel alloc] init];
        _practiceLab.text = @"0.00";
        _practiceLab.textColor = [UIColor whiteColor];
        _practiceLab.font = [UIFont boldSystemFontOfSize:29.f];
    }
    return _practiceLab;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ppc_track"]];
        [_imgView sizeToFit];
        _imgView.userInteractionEnabled = YES;
    }
    return _imgView;
}

@end
