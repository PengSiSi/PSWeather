//
//  Macro_NetInterface.h
//  zichan
//
//  Created by Mike on 16/5/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macro_NetInterface_h
#define Macro_NetInterface_h

#define isNilOrNull(obj) (obj == nil || [obj isEqual:[NSNull null]])

#define setObjectForKey(object) \
do { \
    [dictionary setObject:object forKey:@#object]; \
} while (0)

#define setOptionalObjectForKey(object) \
do { \
    isNilOrNull(object) ?: [dictionary setObject:object forKey:@#object]; \
} while (0)

//// baseURL
#define ZC_BASE_URL ([NSString stringWithFormat:@"%@/services/V1", USERDEFAULT_OBJ4KEY(kServerURL)])

// ----------------------------------------------------------------------------

// 1.获取城市ID --GET
#define GetCityId_URL ([NSString stringWithFormat:@"http://apis.baidu.com/apistore/weatherservice/citylist"])
// 参数构造
NS_INLINE NSDictionary *getCityIdParameter(NSString *cityname) {
    return NSDictionaryOfVariableBindings(cityname);
}

// 2.获取城市天气 --GET
#define GetCityWeather_URL ([NSString stringWithFormat:@"http://apis.baidu.com/apistore/weatherservice/recentweathers"])
// 参数构造
NS_INLINE NSDictionary *getCityWeatherParameter(NSString *cityid, NSString *cityname) {
    return NSDictionaryOfVariableBindings(cityid, cityname);
}

#endif /* Macro_NetInterface_h */
