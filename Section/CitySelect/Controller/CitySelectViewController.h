//
//  CitySelectViewController.h
//  PSWeather
//
//  Created by 思 彭 on 16/11/17.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^selectCityBlock)(NSString *selectCityStr);

@interface CitySelectViewController : BaseViewController

@property (nonatomic, copy) selectCityBlock block;

@end
