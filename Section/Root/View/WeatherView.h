//
//  WeatherView.h
//  PSWeather
//
//  Created by 思 彭 on 16/11/17.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
#import "WeekWeatherView.h"

@interface WeatherView : UIView

/**
 温度的Label
 */
@property (strong, nonatomic) UILabel *weatherLabel;

/**
 今日天气的图片
 */
@property (strong, nonatomic) UIImageView *weatherImgView;

/**
 数据的model
 */
@property (nonatomic, strong) WeatherModel *model;

@property (nonatomic, strong) WeekWeatherView *firstView;
@property (nonatomic, strong) WeekWeatherView *twoView;
@property (nonatomic, strong) WeekWeatherView *threeView;

@property (nonatomic, strong) UILabel *contentlabel;

@end
