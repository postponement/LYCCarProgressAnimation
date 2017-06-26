//
//  LYCBaseAnimationView.h
//  LYCCarProgressAnimation
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AnimationType){
    AnimationPerform = 0,
    AnimationFinish = 1
};
@interface LYCBaseAnimationView : UIView

@property (copy, nonatomic) NSString *titleStr;
@property (nonatomic, strong) NSString *percentStr;

-(instancetype)initWithFrame:(CGRect)frame withType:(AnimationType)rateType;

@end
