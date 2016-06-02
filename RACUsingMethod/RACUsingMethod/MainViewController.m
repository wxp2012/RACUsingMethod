//
//  MainViewController.m
//  RACUsingMethod
//
//  Created by aipai on 16/6/2.
//  Copyright © 2016年 xp. All rights reserved.
//

#import "MainViewController.h"
#import "FirstViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *listTableV;
@property (nonatomic,strong) NSArray *listArr;

@end

@implementation MainViewController

- (void) viewDidLoad
{
    self.listArr = [NSArray array];
    self.listArr = @[@"第一个",@"第二个"];
    
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.listTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.listTableV];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.listArr[indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FirstViewController *firstVC = [[FirstViewController alloc] init];
        [self.navigationController pushViewController:firstVC animated:YES];
    }
}

@end
