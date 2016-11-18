//
//  WeatherModel.h
//  PSWeather
//
//  Created by 思 彭 on 16/11/17.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayModel: NSObject


/**
 "date": "2016-11-17",
 "week": "星期三",
 "curTemp": "4℃",
 "aqi": "177",
 "fengxiang": "无持续风向",
 "fengli": "微风级",
 "hightemp": "11℃",
 "lowtemp": "2℃",
 "type": "晴",
 "index": [
 {
 "name": "感冒指数",
 "code": "gm",
 "index": "",
 "details": "将有一次强降温过程，天气寒冷，且空气湿度较大，极易发生感冒，请特别注意增加衣服保暖防寒。",
 "otherName": ""
 },
 */

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSString *curTemp;
@property (nonatomic, copy) NSString *aqi;
@property (nonatomic, copy) NSString *fengxiang;
@property (nonatomic, copy) NSString *fengli;
@property (nonatomic, copy) NSString *hightemp;
@property (nonatomic, copy) NSString *lowtemp;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *index;

@end

@interface WeatherModel : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, strong) TodayModel *today;
@property (nonatomic, strong) NSArray *forecast;
@property (nonatomic, strong) NSArray *history;

@end
