//
//  ViewController.m
//  RACUsingMethod
//
//  Created by aipai on 16/6/2.
//  Copyright © 2016年 xp. All rights reserved.
//

#import "MainViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MainViewController ()

@property (nonatomic,strong) NSString *inputStr;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、监听对象的成员变量变化，当成员变量值被改变时，触发做一些事情。
    //场景：当前类有一个成员变量 NSString *input，当它的值被改变时，发送一个请求。
    [RACObserve(self, self.inputStr)
         subscribeNext:^(id x) {
             if (x) {
                 NSLog(@"成员变量被改变了");
                 NSLog(@"%@",x);
             }
         }
     ];
    self.inputStr = @"changed";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
