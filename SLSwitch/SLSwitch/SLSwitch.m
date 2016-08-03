//
//  SLSwitch.m
//  SLSwitch
//
//  Created by fengsonglin on 16/6/4.
//  Copyright © 2016年 fengsonglin. All rights reserved.
//


#define kThumbOffset 1

#define kDefaultTrackOnColor [UIColor colorWithRed:83/255.0 green: 214/255.0 blue: 105/255.0 alpha: 1]
#define kDefaultTrackOffColor [UIColor colorWithWhite:0.9f alpha:1.0f]//关闭的时候显示的颜色
#define kDefaultTrackContrastColor [UIColor whiteColor]

#define kDefaultThumbTintColor [UIColor whiteColor]
#define kDefaultThumbBorderColor [UIColor colorWithWhite: 0.9f alpha:1.0f]

#define kDefaultAnimationContrastResizeLength 0.25f   //Length of time to slide from left/right,right/left
#define kDefaultAnimationSlideLength 0.15f            //Length of time for the thumb to grow on press down
#define kDefaultAnimationScaleLength 0.15f             //Length of time for the thumb to grow on press down
#define kThumbTrackingGrowthRatio 1.1f                //Amount to grow the thumb on press down

#import "SLSwitch.h"

@interface SLSwitchTrack : UIView

@property (nonatomic, strong) UIColor *contrastColor;//关闭时候显示的背景颜色
@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;

-(id) initWithFrame:(CGRect)frame onColor:(UIColor *)onColor offColor:(UIColor *)offColor constrastColor:(UIColor *)contrastColor;
-(void) setOn:(BOOL) on
     animated:(BOOL) animated;

@end


typedef enum {
    SLSwitchThumbJustifyLeft,
    SLSwitchThumbJustifyRight
} SLSwitchThumbJustify;

//开关点；
@interface SLSwitchThumb:UIView;
@property (nonatomic, assign) BOOL isTracking;
-(void)growThumbWithJustification:(SLSwitchThumbJustify) justifycation;

-(void)shrinkThumbWithJustification:(SLSwitchThumbJustify) justification;
@end

@interface SLSwitch ()<UIGestureRecognizerDelegate>
//轨迹
@property (nonatomic, strong) SLSwitchTrack *track;
//圆孔
@property (nonatomic, strong) SLSwitchThumb *thumb;

@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;

@end



@implementation SLSwitch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
//     [super drawRect:rect];
    [_thumb setBackgroundColor:[UIColor whiteColor]];
    CGFloat roundedCornerRadius = _thumb.frame.size.height/2.0f;
    [_thumb.layer setBorderWidth:0.5f];
    [_thumb.layer setBorderColor:[self.thumbBorderColor CGColor]];
    [_thumb.layer setCornerRadius:roundedCornerRadius];
    [_thumb.layer setShadowColor:[[UIColor grayColor] CGColor]];
    [_thumb.layer setShadowOffset:CGSizeMake(0, 3)];
    [_thumb.layer setShadowOpacity:0.4f];
    [_thumb.layer setShadowRadius:0.8];
}
-(void)setLocked:(BOOL)locked{
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
     if (self = [super initWithCoder: aDecoder]) {
    [self configureSwitch];
     }
    
    return self;
}

-(void)configureSwitch {
    [self initializeDefults];
    [self setBackgroundColor:[UIColor clearColor]];
    //tap gesture for toggling  the switch
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    self.tapGesture.delegate = self;
    [self addGestureRecognizer:self.tapGesture];
    
    //pan gesture for moving the switch knob manually
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didDrag:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];
    
    
    
    
    if (!_track) {
        _track = [[SLSwitchTrack alloc]initWithFrame:self.bounds onColor:self.onTintColor offColor:self.tintColor constrastColor:self.contrastColor];
    }
    [self addSubview:self.track];
    
    //圆点
    if (!_thumb) {
        _thumb = [[SLSwitchThumb alloc]initWithFrame:CGRectMake(kThumbOffset, kThumbOffset, self.bounds.size.height -  2 * kThumbOffset , self.bounds.size.height - 2 * kThumbOffset)];
        [self addSubview:self.thumb];
    }
    

}


-(void)didDrag:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self setThumbIsTracking:YES animated:YES];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint locationInThumb = [gesture locationInView:self.thumb];
        //toogle the switch if the user pans left or right past the switch thumb bounds
        if ((self.isOn && locationInThumb.x <= 0) || (!self.isOn && locationInThumb.x >= self.thumb.bounds.size.width)) {
            [self toogleState];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self setThumbIsTracking:NO animated:YES];
    }
}

-(void)didTap:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self toogleState];
    }
}

-(void)toogleState{
    //between on/off
    [self setOn:self.isOn ? NO:YES aninated:YES];
}

-(void) setThumbIsTracking:(BOOL)isTracking {
    if (isTracking) {
        //Grow
        [self.thumb growThumbWithJustification:self.isOn ? SLSwitchThumbJustifyRight:SLSwitchThumbJustifyLeft];
    }
    else{
        //Shrink
        [self.thumb shrinkThumbWithJustification:self.isOn ? SLSwitchThumbJustifyRight:SLSwitchThumbJustifyLeft];
    }
    
    [self.thumb setIsTracking:isTracking];
}

-(void) setThumbIsTracking:(BOOL)isTracking
                  animated:(BOOL) animated {
    __weak id weakSelf = self;
    [UIView animateWithDuration: kDefaultAnimationScaleLength
                          delay: fabs(kDefaultAnimationSlideLength - kDefaultAnimationScaleLength)
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [weakSelf setThumbIsTracking: isTracking];
                     }
                     completion:nil];
}
-(void)initializeDefults {
    _onTintColor = kDefaultTrackOnColor;
    _tintColor = kDefaultTrackOffColor;
    _thumbBorderColor = kDefaultThumbBorderColor;//圆圆的边框颜色
    _contrastColor = kDefaultThumbTintColor;//在关闭开关时候背景显示的颜色
}




-(void)setOnTintColor:(UIColor *)onTintColor{
    _onTintColor = onTintColor;
    [self.track setOnTintColor:_onTintColor];
}

-(void) setContrastColor:(UIColor *)contrastColor {
    _contrastColor = contrastColor;
    [self.track setContrastColor: _contrastColor];
}


-(void) setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.track setTintColor: _tintColor];
}


#pragma mark -Event Handlers
-(void)setOn:(BOOL)on aninated:(BOOL)animated {
    if (_on == on) {
        return;
    }
    
    //Move the thumb to the new position
    [self setThumbOn:on animated:animated];
    //Animate the constrast view of the track
    [self.track setOn:on animated:animated];//圆圈开始移动
    
    _on = on;
    
    //Trigger the completion block if exists
    if (self.didChangeHandler) {
        self.didChangeHandler(_on);
    }
    
}




-(void)setThumbOn:(BOOL)on animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setThumbOn:on animated:NO];
        }];
    }
    
    CGRect thumbFrame = self.thumb.frame;
    if (on) {
        thumbFrame.origin.x = self.bounds.size.width - (thumbFrame.size.width + kThumbOffset);
    }
    else{
        thumbFrame.origin.x = kThumbOffset;
    }
    [self.thumb setFrame:thumbFrame];
}

@end


@interface SLSwitchTrack ()

@property (nonatomic, strong) UIView *contrastView;
@property (nonatomic, strong) UIView *onView;

@end

@implementation SLSwitchTrack

-(void)setOnTintColor:(UIColor *)onTintColor {
    _onTintColor = onTintColor;
    [self.onView setBackgroundColor:_onTintColor];
}

-(void) setContrastColor:(UIColor *)contrastColor {
    _contrastColor = contrastColor;
    [self.contrastView setBackgroundColor: _contrastColor];
}


-(void) setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self setBackgroundColor: _tintColor];
}

-(id) initWithFrame:(CGRect)frame onColor:(UIColor *)onColor offColor:(UIColor *)offColor constrastColor:(UIColor *)contrastColor {
    if (self = [super initWithFrame:frame]) {
        _onTintColor = onColor;
        _tintColor = offColor;
        CGFloat cornerRadius = frame.size.height / 2.0f;
        [self.layer setCornerRadius:cornerRadius];
        [self setBackgroundColor:_tintColor];
        
        CGRect contrstRect = frame;
        contrstRect.size.width = frame.size.width - 2*kThumbOffset;
        contrstRect.size.height = frame.size.height - 2*kThumbOffset;
        CGFloat contrastRdius = contrstRect.size.height/2.0f;
        
        _contrastView = [[UIView alloc]initWithFrame:contrstRect];
        [_contrastView setBackgroundColor:contrastColor];
        [_contrastView setCenter:self.center];
        [_contrastView.layer setCornerRadius:contrastRdius];
        [self addSubview:_contrastView]; //关闭开关时候的背景
        
        _onView = [[UIView alloc]initWithFrame:frame];
        [_onView setBackgroundColor:_onTintColor];
        [_onView setCenter:self.center];
        [_onView.layer setCornerRadius:cornerRadius];
        [self addSubview:_onView];//开关on的时候显示的背景颜色
    }
    
    return self;
}


-(void)setOn:(BOOL)on animated:(BOOL)animated {
    if (animated) {
        __weak id weakSelf  = self;
        [UIView animateWithDuration:kDefaultAnimationContrastResizeLength delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
        } completion:^(BOOL finished) {
            [weakSelf setOn:on animated:NO];
        }];
    }
    else{
        [self setOn:on];
    }
}



-(void)setOn:(BOOL)on {
    if (on) {
        [self.onView setAlpha:1.0];
        
    }else{
        [self.onView setAlpha:0.0];
    }
}


//-(void)shrinkContrastView {
//    
//}


@end



@implementation SLSwitchThumb


-(void) growThumbWithJustification:(SLSwitchThumbJustify) justification {
    if (self.isTracking)
        return;
    
    CGRect thumbFrame = self.frame;
    
    CGFloat deltaWidth = self.frame.size.width * (kThumbTrackingGrowthRatio - 1);
    thumbFrame.size.width += deltaWidth;
    if (justification == SLSwitchThumbJustifyRight) {
        thumbFrame.origin.x -= deltaWidth;
    }
    [self setFrame: thumbFrame];
}
-(void)shrinkThumbWithJustification:(SLSwitchThumbJustify) justification {
    if (!self.isTracking) {
        return;
    }
    CGRect thumbFrame = self.frame;
    CGFloat deltaWidth = self.frame.size.width * (1 - 1 / kThumbTrackingGrowthRatio);
    thumbFrame.size.width -= deltaWidth;
    if (justification == SLSwitchThumbJustifyRight) {
        thumbFrame.origin.x += deltaWidth;
    }
    [self setFrame:thumbFrame];
}

@end