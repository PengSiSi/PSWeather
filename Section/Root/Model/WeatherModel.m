//
//  WeatherModel.m
//  PSWeather
//
//  Created by 思 彭 on 16/11/17.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import "WeatherModel.h"

@implementation TodayModel

@end

@implementation WeatherModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    
//    return @{
//             @"forecast": @"forecast"
//             };
//}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"forecast": NSStringFromClass([TodayModel class]),
              @"history": NSStringFromClass([TodayModel class])
             };
    
}

@end
