//
//  LYCCircleView.m
//  LYCCarProgressAnimation
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import "LYCCircleView.h"

#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#define pi 3.14159265359
#define DEGREES_DefaultStart(degrees)  ((pi * (degrees+270))/ 180) //默认270度为开始的位置
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)         //转化为度


@interface LYCCircleView ()<CAAnimationDelegate>
@property (nonatomic, assign) CGFloat endDegree;
@property (nonatomic, assign) CGFloat startPercent;
@property (nonatomic, assign) CGFloat endPercent;
@property (nonatomic, strong) CAShapeLayer *animtionLayer;
@property (nonatomic, assign) CGFloat animationTime;
@end
@implementation LYCCircleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self drawCircle];
        //默认从零开始
        self.endPercent = 0.0f;
    }
    return self;
}

//初始化(自定义路径)
-(void)drawCircle{
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = 12;
    layer.lineCap = kCALineCapRound;
    //圆环的颜色
    layer.strokeColor = RGBA(90, 97, 119, 1).CGColor;
    //背景填充色
    layer.fillColor = [UIColor clearColor].CGColor;
    //设置半径为10
    CGFloat radius = 75;
    //按照顺时针方向
    BOOL clockWise = true;
    //初始化一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:(0*M_PI) endAngle:2*M_PI clockwise:clockWise];
    layer.path = [path CGPath];
    [self.layer addSublayer:layer];
}

//加入圆弧layer
-(void)makeCircle:(NSInteger)percent withAnimationTime:(CGFloat)animationTime{
    self.startPercent = self.endPercent;
    self.endPercent = percent/100.0;
    self.animationTime = animationTime;
    self.endDegree = DEGREES_DefaultStart(percent/100.0 * 360);
    [self addCircle];
}
-(void)addCircle{
    
    //animtionLayer默认为整个圆圈路径（为了产生动画）
    UIBezierPath *animationPath = [UIBezierPath bezierPath];
    [animationPath addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:75 startAngle:-M_PI*0.5 endAngle:M_PI*1.5 clockwise:YES];
    
    if(!self.animtionLayer){
        self.animtionLayer = [CAShapeLayer layer];
        self.animtionLayer.fillColor = self.backgroundColor.CGColor;
        self.animtionLayer.strokeColor = RGBA(244, 145, 127, 1).CGColor;
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
    pathAnimation.duration = self.animationTime;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:self.startPercent];
    pathAnimation.toValue = [NSNumber numberWithFloat:self.endPercent];
    pathAnimation.autoreverses = NO;
    pathAnimation.delegate = self;
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //真正的弧形路径
    UIBezierPath *animationPath = [UIBezierPath bezierPath];
    [animationPath addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:75 startAngle:DEGREES_DefaultStart(0) endAngle:self.endDegree clockwise:YES];
    
    self.animtionLayer.path = animationPath.CGPath;
}

@end
