//
//  ViewController.h
//  SLSwitch
//
//  Created by fengsonglin on 16/6/4.
//  Copyright © 2016年 fengsonglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLSwitch.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet SLSwitch *smallestSwitch;
@property (weak, nonatomic) IBOutlet SLSwitch *smallSwitch;
@property (weak, nonatomic) IBOutlet SLSwitch *mediumSwitch;
@property (weak, nonatomic) IBOutlet SLSwitch *bigSwitch;
@property (weak, nonatomic) IBOutlet SLSwitch *biggestSwitch;

@end

