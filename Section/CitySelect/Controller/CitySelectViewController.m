//
//  CitySelectViewController.m
//  PSWeather
//
//  Created by 思 彭 on 16/11/17.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import "CitySelectViewController.h"

@interface CitySelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *cityDic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allKeysArray;

@end

@implementation CitySelectViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setUI];
}

#pragma mark - initData

- (void)loadData {
   
    NSString *path = [[NSBundle mainBundle]pathForResource:@"citydict.plist" ofType:nil];
    self.cityDic = [NSDictionary dictionaryWithContentsOfFile:path];
    // 排序
    NSArray *tempArray = [[self.cityDic allKeys]sortedArrayUsingSelector:@selector(compare:)];
    [self.allKeysArray addObjectsFromArray:tempArray];
}

#pragma mark - 设置界面

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview: self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cityDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray *)(self.cityDic[self.allKeysArray[section]])).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = ((NSArray *)(self.cityDic[self.allKeysArray[indexPath.section]]))[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 30)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, K_SCREEN_WIDTH - 15, 30)];
    [headerView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    NSString *titleStr = self.allKeysArray[section];
    titleLabel.text = titleStr;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectStr = ((NSArray *)(self.cityDic[self.allKeysArray[indexPath.section]]))[indexPath.row];
    if (self.block) {
        self.block(selectStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Method

#pragma mark - 懒加载

- (NSMutableArray *)allKeysArray {
    
    if (!_allKeysArray) {
        _allKeysArray = [NSMutableArray array];
    }
    return _allKeysArray;
}

@end
