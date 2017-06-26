//
//  LYCPointerView.h
//  LYCCarProgressAnimation
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 com.liuyanchi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYCPointerView : UIView

// 所占百分比
-(void)updatePointer:(NSInteger)percent withAnimationTime:(CGFloat)animationTime;

@end
