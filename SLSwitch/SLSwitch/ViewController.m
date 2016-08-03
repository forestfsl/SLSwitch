//
//  ViewController.m
//  SLSwitch
//
//  Created by fengsonglin on 16/6/4.
//  Copyright © 2016年 fengsonglin. All rights reserved.
//

#define kGreenColor [UIColor colorWithRed:144/255.0 green: 202/255.0 blue: 119/255.0 alpha: 1.0]
#define kGrayColor [UIColor colorWithRed:81.0/255.0 green: 159.0/255.0 blue: 241.0/255.0 alpha: 1.0]
#define kBlueColor [UIColor colorWithRed:129/255.0 green: 198/255.0 blue: 221/255.0 alpha: 1.0]
#define kYellowColor [UIColor colorWithRed:233/255.0 green: 182/255.0 blue: 77/255.0 alpha: 1.0]
#define kOrangeColor [UIColor colorWithRed:288/255.0 green: 135/255.0 blue: 67/255.0 alpha: 1.0]
#define kRedColor [UIColor colorWithRed:158/255.0 green: 59/255.0 blue: 51/255.0 alpha: 1.0]

#import "ViewController.h"
#import "SLSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.smallSwitch setOnTintColor:kBlueColor];
    [self.smallestSwitch setOnTintColor:kGrayColor];
    [self.mediumSwitch setOnTintColor:kYellowColor];
    [self.bigSwitch setOnTintColor:kOrangeColor];
    [self.biggestSwitch setOnTintColor:kRedColor];
    [self.smallSwitch setOn:YES aninated:YES];
    [self.smallestSwitch setOn:YES aninated:YES];
    [self.mediumSwitch setOn:YES aninated:YES];
    [self.bigSwitch setOn:YES aninated:YES];
    [self.biggestSwitch setOn:YES aninated:YES];
    [self.biggestSwitch setTintColor:[UIColor greenColor]];
    [self.biggestSwitch setContrastColor:[UIColor purpleColor]];
    [self.smallSwitch setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"smallSwitch switch changed to %d", isOn);
    }];
    [self.smallestSwitch setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"Smallest switch changed to %d", isOn);
    }];
    [self.mediumSwitch setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"mediumSwitch switch changed to %d", isOn);
    }];

    [self.bigSwitch setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"bigSwitch switch changed to %d", isOn);
    }];

    [self.biggestSwitch setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"biggestSwitch switch changed to %d", isOn);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
