//
//  RetDataModel.h
//  PSWeather
//
//  Created by 思 彭 on 16/11/17.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetDataModel : NSObject

/**
 {
 "province_cn": "北京",
 "district_cn": "北京",
 "name_cn": "北京",
 "name_en": "beijing",
 "area_id": "101010100"
 },

 */
@property (nonatomic, copy) NSString *province_cn;
@property (nonatomic, copy) NSString *district_cn;
@property (nonatomic, copy) NSString *name_cn;
@property (nonatomic, copy) NSString *name_en;
@property (nonatomic, copy) NSString *area_id;

@end
