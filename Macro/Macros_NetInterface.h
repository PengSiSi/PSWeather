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
#pragma mark - 1.登录
// 1.登录 --GET
#define LOGIN_URL ([NSString stringWithFormat:@"%@/login", ZC_BASE_URL])
// 参数构造
NS_INLINE NSDictionary *ZCLoginParameter(NSString *loginname, NSString *password) {
    return NSDictionaryOfVariableBindings(loginname, password);
}

#endif /* Macro_NetInterface_h */
