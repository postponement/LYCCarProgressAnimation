//
//  LYCPointerView.m
//  LYCCarProgressAnimation
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import "LYCPointerView.h"

#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface LYCPointerView ()<CAAnimationDelegate>
@property (nonatomic, assign) CGFloat startAngle;
@property (strong, nonatomic) CALayer *carLayer;
@property (strong, nonatomic) UIImage *img;
@property (assign, nonatomic) CGFloat angle;
@property (nonatomic, strong) CAShapeLayer *animtionLayer;
@end
@implementation LYCPointerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addPointer];
    }
    return self;
}

-(void)addPointer{
    
    CALayer *carlayer = [CALayer layer];
    carlayer.frame = CGRectMake(self.bounds.size.width / 2 - 8, self.bounds.size.height / 2 - 75-12.5, 14, 27);
    UIImage *image = [UIImage imageNamed:@"ppc_car"];
    self.img = image;
    carlayer.contents = (id)image.CGImage;
    [self.layer addSublayer:carlayer];
    carlayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    self.carLayer = carlayer;
    
}

- (void)startAnimation:(CGFloat)number
{
    CGFloat count = 100;
    CGFloat angle = number / count ;
    self.angle = angle;
    
    // 角度(象限计算角度)
    double a0 = 0;
    if (self.angle>= 0 && self.angle<=0.25) {
        a0 = -M_PI / 2 + self.angle *M_PI*2;
    }else if (self.angle>0.25 && self.angle<=0.5){
        a0 = self.angle*M_PI*2 - M_PI/2;
    }else if (self.angle>0.5 && self.angle<=0.75){
        a0 = M_PI/2 + (self.angle*M_PI*2 - M_PI);
    }else if (self.angle>0.75 && self.angle<=1){
        a0 = M_PI + (self.angle*M_PI*2 - M_PI*1.5);
    }
    
    // 起始位置(调转车头)
    self.carLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2- 75);
    CABasicAnimation* headingAnimation;
    headingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    headingAnimation.toValue = @(M_PI_2);
    headingAnimation.duration = 1.0f;
    headingAnimation.cumulative = YES;
    headingAnimation.beginTime = 0.0f;
    headingAnimation.fillMode = kCAFillModeForwards;
    
    // 小车轨迹
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint ptCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:ptCenter radius:75 startAngle:-M_PI/2  endAngle:a0  clockwise:YES];
    anima.path = path.CGPath;
    anima.duration = 1.5f ;
    anima.beginTime = 1.0f;
    anima.fillMode = kCAFillModeForwards;
    anima.calculationMode = kCAAnimationPaced;// 帧动画平分时间
    // 小车车头角度
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(0.5* M_PI +  self.angle*M_PI*2);
    rotationAnimation.duration = 1.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.beginTime = 1.0f;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionLinear];
    
    // 尾部车头动画
    CABasicAnimation* headingUpAnimation;
    headingUpAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    headingUpAnimation.fromValue = @(M_PI_2);
    headingUpAnimation.toValue = @(0);
    headingUpAnimation.duration = 1.0f;
    headingUpAnimation.cumulative = YES;
    headingUpAnimation.beginTime = 2.5f;
    headingUpAnimation.fillMode = kCAFillModeForwards;
    
    // 向前移动动画
    CABasicAnimation *removeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    removeAnimation.toValue = @(-40);
    removeAnimation.beginTime = 3.5;
    removeAnimation.duration = 2;
    removeAnimation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    removeAnimation.fillMode = kCAFillModeForwards;
    
    // 隐藏动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0];
    opacityAnimation.beginTime = 3.5;
    opacityAnimation.duration = 2.0f;
    opacityAnimation.autoreverses= NO;
    
    // 组动画
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    if (angle == 1) {
        animationGroup.animations = @[headingAnimation,anima,rotationAnimation,headingUpAnimation,removeAnimation,opacityAnimation];
        animationGroup.duration = 5.5f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 颜色覆盖
            [self addCircle];
        });
    }else{
        animationGroup.animations = @[headingAnimation,anima,rotationAnimation];
        animationGroup.duration = 2.5f;
    }
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO;
    [self.carLayer addAnimation:animationGroup forKey:@"pathAnimation"];
    
}

-(void)addCircle{
    
    //animtionLayer默认为整个圆圈路径（为了产生动画）
    UIBezierPath *animationPath = [UIBezierPath bezierPath];
    [animationPath addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:75 startAngle:-M_PI*0.5 endAngle:M_PI*1.5 clockwise:YES];
    
    if(!self.animtionLayer){
        self.animtionLayer = [CAShapeLayer layer];
        self.animtionLayer.fillColor = self.backgroundColor.CGColor;
        self.animtionLayer.strokeColor = RGBA(247, 195, 84, 1).CGColor;
        self.animtionLayer.lineWidth = 12;
        self.animtionLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.animtionLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:self.animtionLayer];
    }
    
    self.animtionLayer.path = animationPath.CGPath;
    [self addMakeAnimation:self.animtionLayer];
    
}
//过程动画
-(void)addMakeAnimation:(CAShapeLayer *)shapeLayer{
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0];
    pathAnimation.toValue = [NSNumber numberWithFloat:1];
    pathAnimation.autoreverses = NO;
    pathAnimation.delegate = self;
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}

-(void)updatePointer:(NSInteger)percent withAnimationTime:(CGFloat)animationTime{
    [self startAnimation:percent];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    // 隐式动画取消
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    // 圆心
    CGFloat x0 = self.bounds.size.width / 2;
    CGFloat y0 = self.bounds.size.height / 2;
    // 角度（象限计算旋转角度）
    double a1 = 0;
    double a2 = 0;
    if (self.angle>= 0 && self.angle<0.25) {
        a1 = M_PI / 2 - self.angle *M_PI*2;
        a2 = self.angle *M_PI*2;
    }else if (self.angle>=0.25 && self.angle<=0.5){
        a1 = M_PI*2 - (self.angle*M_PI*2 - M_PI/2);
        a2 = self.angle*M_PI*2;
    }else if (self.angle>0.5 && self.angle<=0.75){
        a1 = M_PI*2 - (M_PI/2 + (self.angle*M_PI*2 - M_PI));
        a2 = self.angle*M_PI*2;
    }else if (self.angle>0.75 && self.angle<=1){
        a1 = M_PI/2 + (M_PI*2 - self.angle*M_PI*2);
        a2 = self.angle*M_PI*2;
    }
    // 所在位置
    CGFloat x1 = x0 + 75 *cos(a1);
    CGFloat y1 = y0 - 75 *sin(a1);
    self.carLayer.position = CGPointMake(x1, y1);
    if (self.angle<1) {
        self.carLayer.transform = CATransform3DMakeRotation(0.5*M_PI+a2, 0, 0, 1);
    }else{
        [self.carLayer removeFromSuperlayer];
    }
    [CATransaction commit];
}

@end

