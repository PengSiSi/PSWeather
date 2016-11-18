//
//  WeekWeatherView.h
//  PSWeather
//
//  Created by 思 彭 on 16/11/18.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekWeatherView : UIView


/**
 周次Label
 */
@property (strong, nonatomic)  UILabel *weekLabel;

/**
 天气类型图片
 */
@property (strong, nonatomic)  UIImageView *weatherImgView;

/**
 温度Label
 */
@property (strong, nonatomic)  UILabel *tempLabel;

@end
