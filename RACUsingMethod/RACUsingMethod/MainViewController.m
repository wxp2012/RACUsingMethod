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
@property (nonatomic,strong) NSString *isConnected;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、监听对象的成员变量变化，当成员变量值被改变时，触发做一些事情。
    //场景：当前类有一个成员变量 NSString *input，当它的值被改变时打印。
    [RACObserve(self, self.inputStr)
         subscribeNext:^(id x) {
             if (x) {
                 NSLog(@"成员变量被改变了");
                 NSLog(@"%@",x);
             }
         }
     ];
    self.inputStr = @"changed";
    
    //2、场景：在上面场景中，当用户输入的值以2开头时，才打印.
    self.inputStr = @"2changed";
    [[RACObserve(self, self.inputStr)
        filter:^BOOL(id value) {
            if ([value hasPrefix:@"2"]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
     ]
    subscribeNext:^(id x) {
        if (x) {
            NSLog(@"有2开头的字符串");
        }
    }];
    
    //3、场景：上面场景是监听自己的成员变量，如果想监听UITextField输入值变化，框架也做了封装可以代替系统回调
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, 150, 30)];
    textF.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.0];
    [self.view addSubview:textF];
    
    [[[textF rac_textSignal]
         filter:^BOOL(id value) {
             
             NSString *str = value;
             if (str.integerValue > 20) {
                 return YES;
             }
             else
             {
                 return NO;
             }
         }]
    subscribeNext:^(id x) {
        if (x) {
            NSLog(@"输入的值大于20了");
        }
    }];
    
    
    //4、同时监听多个变量变化，当这些变量满足一定条件时，使button为可点击状态
    UITextField *textF2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, 150, 30)];
    textF2.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1.0];
    [self.view addSubview:textF2];
    
    UIButton *clickedBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 115, 130, 30)];
    [clickedBtn setTitle:@"点击" forState:UIControlStateNormal];
    [clickedBtn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [clickedBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:254/255.f green:115/255.f blue:85/255.f alpha:1.0]] forState:UIControlStateNormal];
    [self.view addSubview:clickedBtn];
    
    self.isConnected = @"1";
    RAC(clickedBtn,enabled) = [RACSignal
                                   combineLatest:@[textF.rac_textSignal,
                                                   textF2.rac_textSignal,
                                                   RACObserve(self, self.isConnected)
                                                   ]
                                   reduce:^(NSString *price, NSString *name, NSNumber *connect){
                                       return @(price.length > 0 && name.length > 0 && [connect boolValue]);
                                   }];
    
    //5、满足上面条件时，直接打印
    [[RACSignal
      combineLatest:@[textF.rac_textSignal,
                      textF2.rac_textSignal,
                      RACObserve(self, self.isConnected)
                      ]
      reduce:^(NSString *price, NSString *name, NSNumber *connect){
          return @(price.length > 0 && name.length > 0 && ![connect boolValue]);
      }]
     subscribeNext:^(NSNumber *res){
         if ([res boolValue]) {
             NSLog(@"直接打印");
         }
     }];
}

//颜色转换 背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
