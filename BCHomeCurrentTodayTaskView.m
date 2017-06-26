//
//  BCHomeCurrentTodayTaskView.m
//  LYCCarProgressAnimation
//
//  Created by liuyanchi on 2017/6/22.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import "BCHomeCurrentTodayTaskView.h"
#import "LYCBaseAnimationView.h"

@implementation BCHomeCurrentTodayTaskView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    LYCBaseAnimationView *aniView = [[LYCBaseAnimationView alloc] initWithFrame:CGRectMake(15,150, 162, 210) withType:AnimationPerform];
    aniView.percentStr = @"0";
    aniView.titleStr = @"时长";
    [self addSubview:aniView];
    LYCBaseAnimationView *circleAniView = [[LYCBaseAnimationView alloc] initWithFrame:CGRectMake(200,150, 162, 210) withType:AnimationPerform];
    circleAniView.titleStr = @"高峰时长";
    circleAniView.percentStr = @"100";
    [self addSubview:circleAniView];
}
@end
