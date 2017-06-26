//
//  ViewController.m
//  LYCCarProgressAnimation
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import "ViewController.h"
#import "LYCBaseAnimationView.h"

#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
@interface ViewController ()
@property (strong, nonatomic) LYCBaseAnimationView *circleAniView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = RGBA(55, 61, 80, 1);
    LYCBaseAnimationView *aniView = [[LYCBaseAnimationView alloc] initWithFrame:CGRectMake(15,150, 162, 210) withType:AnimationPerform];
    aniView.titleStr = @"时长";
    [self.view addSubview:aniView];
    self.circleAniView = [[LYCBaseAnimationView alloc] initWithFrame:CGRectMake(200,150, 162, 210) withType:AnimationPerform];
    self.circleAniView.titleStr = @"高峰时长";
    [self.view addSubview:self.circleAniView];
    
    LYCBaseAnimationView *FabulousView = [[LYCBaseAnimationView alloc] initWithFrame:CGRectMake(15,400, 162, 210) withType:AnimationFinish];
    FabulousView.titleStr = @"时长";
    [self.view addSubview:FabulousView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    self.circleAniView.percentStr = @"100";
}

@end
