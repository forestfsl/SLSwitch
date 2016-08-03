//
//  SLSwitch.h
//  SLSwitch
//
//  Created by fengsonglin on 16/6/4.
//  Copyright © 2016年 fengsonglin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeHandler)(BOOL isOn);

@interface SLSwitch : UIControl

//开关on时候的颜色
@property (nonatomic, strong) UIColor *onTintColor;//onView 图片的颜色
@property (nonatomic, strong) UIColor *tintColor; //背景图片的颜色

@property(nonatomic, strong) UIColor *contrastColor;//关闭的时候的颜色
@property(nonatomic, strong) UIColor *thumbBorderColor;//开关圆点的外边框架
@property(nonatomic, copy) changeHandler didChangeHandler;

@property(nonatomic, getter=isOn) BOOL on;



//Events
-(void)setOn:(BOOL)on aninated:(BOOL)animated;
//-(void)setLocked:(BOOL)locked;
@end
