//
//  RootViewController.m
//  PSWeather
//
//  Created by 思 彭 on 16/11/16.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import "RootViewController.h"
#import "UIBarButtonItem+Create.h"
#import "CitySelectViewController.h"
#import "WeatherView.h"
#import "HTTPTool.h"
#import "RetDataModel.h"
#import "WeatherModel.h"
#import <CoreLocation/CoreLocation.h>

#define apikey @"68263df2935d265f87b2eb49f066953a"

@interface RootViewController ()<CLLocationManagerDelegate>

{
    UIImageView *imgView;
    CLGeocoder *geocoder;
}

@property (nonatomic, strong) WeatherView *weatherView;
@property (nonatomic, strong) NSArray *cityIdArray;
@property (nonatomic, copy) NSString *selectStr;
@property (nonatomic, strong) WeatherModel *model;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"看看天气";
//    [self setImageView];
//    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setWeatherView];
    [self setActivityView];
    [self setNavItem];
    [self alertShow];
}

// 请求城市ID
- (void)requestCityIdWithCityName: (NSString *)cityName {
    
    [SVProgressHUD showWithStatus:KREQUESTLOADING];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSDictionary *param = getCityIdParameter(cityName);
    [HTTPTool getWithURL:GetCityId_URL headers:@{@"apikey": apikey} params:param success:^(id json) {
       
        NSLog(@"json = %@",json);
        if ([json[@"errMsg"] isEqualToString:@"success"]) {
            
            self.cityIdArray = [RetDataModel mj_objectArrayWithKeyValuesArray:json[@"retData"]];
            [self dealData];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:KREQUESTERROR];
    }];
}

// 取得当前选择的城市ID
- (void)dealData {

    for (RetDataModel *model in self.cityIdArray) {
        if ([model.name_cn isEqualToString:self.selectStr]) {
            [self requestWeatherData:model.area_id];
        }
    }
}

// 请求城市天气情况
- (void)requestWeatherData: (NSString *)cityId {
    
    [SVProgressHUD showWithStatus:KREQUESTLOADING];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSDictionary *param = getCityWeatherParameter(cityId, self.selectStr);
    [HTTPTool getWithURL:GetCityWeather_URL headers:@{@"apikey": apikey} params:param success:^(id json) {
        
        self.model = [[WeatherModel alloc]init];
        NSLog(@"json = %@",json);
        if ([json[@"errMsg"] isEqualToString:@"success"]) {
            
            self.model = [WeatherModel mj_objectWithKeyValues:json[@"retData"]];
            self.weatherView.model = self.model;
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:KREQUESTERROR];
    }];
}

// 弹出视图先定位或者是选择地区
- (void)alertShow {
   
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请先定位或者是选择查询的地区哟！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

// 设置背景图片
- (void)setImageView {
    
    imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sun"]];
    imgView.frame = CGRectMake((K_SCREEN_WIDTH - 100) / 2, (K_SCREEN_HEIGHT - 200) / 2, 100, 100);
    [self.view addSubview:imgView];
}

- (void)setWeatherView {
    
    self.weatherView = [[WeatherView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.weatherView];
}

- (void)setNavItem {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"选择地区" tintColor:[UIColor whiteColor] target:self action:@selector(selectCityClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"定位" tintColor:[UIColor whiteColor] target:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setActivityView {
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.frame = CGRectMake((K_SCREEN_WIDTH - 80) / 2, 200, 80, 80);
    self.activityView.backgroundColor = [UIColor greenColor];
    [self.weatherView addSubview:self.activityView];
//    [self.activityView startAnimating];
}

#pragma mark - Private Method

// 城市选择
- (void)selectCityClick: (UIBarButtonItem *)barItem {
    
    CitySelectViewController *citySelectVc = [[CitySelectViewController alloc]init];
    [self.navigationController pushViewController:citySelectVc animated:YES];
    __weak typeof(self) weakSelf = self;
    citySelectVc.block = ^(NSString *selectStr) {
        self.selectStr = selectStr;
        weakSelf.title = selectStr;
        [weakSelf requestCityIdWithCityName:selectStr];
    };
}

// 定位
- (void)locationClick: (UIBarButtonItem *)barItem {
    
    [self.activityView startAnimating];
    [self initialLocationManager];
    
    NSLog(@"start gps");
    
}

- (void)initialLocationManager {

    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - CoreLocation 代理

#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）

//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}

#pragma mark 根据坐标取得地名

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSLog(@"error = %@",error);
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        [self.activityView stopAnimating];
    }];
}

//当定位出现错误时就会调用这个方法。
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error-%@",error);
    
}

#pragma mark - 懒加载

@end
