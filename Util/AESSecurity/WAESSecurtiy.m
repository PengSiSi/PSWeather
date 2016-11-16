//
//  WAESSecurtiy.m
//  PSInteract
//
//  Created by 王楠 on 15/11/23.
//  Copyright © 2015年 王楠. All rights reserved.
//  AES加密辅助类

#import "WAESSecurtiy.h"
//AES加密
#import "SecurityUtil.h"
#import "GTMBase64.h"

@implementation WAESSecurtiy
+(void)AESSecurtiy{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUsername];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    timeStr = [[timeStr componentsSeparatedByString:@"."] objectAtIndex:0];
    //按照 用户名：时间：密码 格式进行加密
    NSString *cSrc = [NSString stringWithFormat:@"%@:%@:%@",userName,timeStr,password];
    NSData *aesdataresult = [SecurityUtil encryptAESData:cSrc];
    
    NSString *handshakePassword = [SecurityUtil encodeBase64Data:aesdataresult];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:handshakePassword forKey:kHandshakePassword];
    [ud synchronize];
}
@end
