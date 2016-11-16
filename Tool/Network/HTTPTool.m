//
//  HTTPTool.m
//  GeneralProject
//
//  Created by 王楠 on 16/1/18.
//  Copyright © 2016年 王楠. All rights reserved.
//

#import "HTTPTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"

#define TIMEOUTINTERVAL 30

@implementation HTTPTool

#pragma mark - GET
+ (void)getWithURL:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure {
    [self requestWithType:@"GET" url:url headers:headers params:params success:success failure:failure];
}

#pragma mark - POST
+ (void)postWithURL:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure {
    [self requestWithType:@"POST" url:url headers:headers params:params success:success failure:failure];
}

#pragma mark - SOAP
//+ (void)soapWithMethod:(NSString *)method param:(NSString *)params success:(HttpSuccess)success failure:(HttpFailure)failure {
//
//    NSString *soapMsg = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><n0:%@ id=\"o0\" c:root=\"1\" xmlns:n0=\"http://webservice.da.lcudp.com/\">%@</n0:%@></v:Body></v:Envelope>",method,params,method];
//    
//    NSLog(@"soapMsg ==\n%@",soapMsg);
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://webservice.da.lcudp.com/"]];
//    
//    manager.requestSerializer.timeoutInterval = 20;
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    //  text/xml    用其他的格式会有问题
//    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//
//    
//    NSString *msgLength=[NSString stringWithFormat:@"%lu",(unsigned long)[soapMsg length]];
//    [manager.requestSerializer setValue:msgLength forHTTPHeaderField:@"Content-Length"];
//    
////    NSString *service = @"http://223.71.216.206:8081/ad_combanc/AdapterService?";
//    
//    NSString *service = @"";
//    // KUSERDEFAULT_OBJ4KEY(KLOGININ_URL);
//    
////    [manager.requestSerializer setValue:[NSString stringWithFormat:@"http://223.71.216.206:8081/ad_combanc/AdapterService/validate"] forHTTPHeaderField:@"SOAPAction"];
//    
//    [manager SOAP:[NSString stringWithFormat:@"%@wsdl",service] constructingBodyWithBlock:^(NSMutableURLRequest *request) {
//        [request setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSData *data=[operation responseData];
//        
////        NSString *resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        
//        /*  resultStr
//         <?xml version='1.0' encoding='UTF-8'?>
//            <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
//                <S:Body>
//                    <ns2:validateResponse xmlns:ns2="http://webservice.da.lcudp.com/">
//                    <return>true</return>
//                    </ns2:validateResponse>
//                </S:Body>
//         </S:Envelope>
//         */
//        
//        // 根据NSData对象初始化GDataXMLDocument对象
//        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data
//                                                               options:0 error:nil];
//        GDataXMLElement *rootElement = [doc rootElement];
//        
//        NSArray *rootStr = rootElement.children;
//        
//        
//        for (GDataXMLElement *ele in rootStr) {
//            NSLog(@"ele.name--%@     ele.stringValue--   %@",ele.name,ele.stringValue);
//            
//            //success(ele.stringValue);
//
////            if ([ele.name isEqualToString:@"return"]) {
////                
////                NSLog(@"ele.stringValue--   %@",ele.stringValue);
////            }
//            
//        }
//        //将NSData返回
//        success(data);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
//        NSLog(@"erroropeartion===%@, error===%@,response===%@", operation, error,response);
//        // 请求失败的时候会调用这里的代码
//        // 通知外面的block，请求成功了
//        if (failure) {
//            failure(error);
//        }
//    }];
//
//}

#pragma mark - UpLoad
+ (void)upLoadWithURL:(NSString *)url param:(NSDictionary *)params image:(UIImage *)image imageName:(NSString *)imageName success:(HttpSuccess)success failure:(HttpFailure)failure{

    //将图片存至Temp文件夹下 并拿到其路径
    NSURL *imageUrl = [self writeImageToFile:image imageName:imageName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //  avatar
        [formData appendPartWithFileURL:imageUrl name:@"File" error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)upLoadMutiWithURL:(NSString *)url param:(NSDictionary *)params imageDicArray:(NSArray *)imageDicArray success:(HttpSuccess)success failure:(HttpFailure)failure {
    //存放保存至沙盒中的图片路径
    NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:10];
    
    dispatch_queue_t queue =  dispatch_queue_create("cccccccccccccc", NULL);
    
    // 将任务添加到队列中
    dispatch_async(queue, ^{
        
        for (NSDictionary *dic in imageDicArray) {
            UIImage *image = dic[@"image"];
            NSString *imageName = dic[@"imageName"];
            //将图片存至Temp文件夹下 并拿到其路径
            NSURL *imageUrl = [self writeImageToFile:image imageName:imageName];
            [imageUrlArr addObject:imageUrl];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // formData是遵守了AFMultipartFormData的对象
        [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //遍历
            for (NSURL *imageUrl in imageUrlArr) {
                [formData appendPartWithFileURL:imageUrl name:imageUrl.absoluteString error:NULL];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *tempPath = NSTemporaryDirectory();
                NSString *upLoadFilePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"upLoadFile"]];
                [fileManager removeItemAtPath:upLoadFilePath error:nil];
                success(json);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    });
}

+ (void)upLoadMutiWithURL:(NSString *)url headers:(NSDictionary *)headers param:(NSDictionary *)params imageDicArray:(NSArray *)imageDicArray success:(HttpSuccess)success failure:(HttpFailure)failure {
    
    //存放保存至沙盒中的图片路径
    NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:10];
    dispatch_queue_t queue =  dispatch_queue_create("cccccccccccccc", NULL);
    
    // 将任务添加到队列中
    dispatch_async(queue, ^{
        for (NSDictionary *dic in imageDicArray) {
            UIImage *image = dic[@"image"];
            NSString *imageName = dic[@"imageName"];
            //将图片存至Temp文件夹下 并拿到其路径
            NSURL *imageUrl = [self writeImageToFile:image imageName:imageName];
            [imageUrlArr addObject:imageUrl];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置请求头
        if (headers != nil) {
            for (id httpHeaderField in headers.allKeys) {
                id value = headers[httpHeaderField];
                if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                    [manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
                }else if ([value isKindOfClass:[NSNumber class]]) {
                    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",value] forHTTPHeaderField:(NSString *)httpHeaderField];
                }else{
                    NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
                }
            }
        }
        // formData是遵守了AFMultipartFormData的对象
        [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //遍历
            for (NSURL *imageUrl in imageUrlArr) {
                [formData appendPartWithFileURL:imageUrl name:imageUrl.absoluteString error:NULL];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *tempPath = NSTemporaryDirectory();
                NSString *upLoadFilePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"upLoadFile"]];
                [fileManager removeItemAtPath:upLoadFilePath error:nil];
                success(json);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    });
}

#pragma mark - DownLoad
+ (void)downLoadWithUrl:(NSString *)url withName:(NSString *)name withFilePath:(NSString *)path success:(HttpSuccess)success {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [docPath stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:filePath]){
        }else{
            //创建路径
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
        
        return [filePathURL URLByAppendingPathComponent:name];
        
        //        return [filePathURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        //        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        //加载下载后的文件
        success(filePath);
    }];
    
    [downloadTask resume];
    


}

+ (void)requestWithType:(NSString *)type url:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure {

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    manager.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;
    // 设置请求头
    if (headers != nil) {
        for (id httpHeaderField in headers.allKeys) {
            id value = headers[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            }else if ([value isKindOfClass:[NSNumber class]]) {
                [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",value] forHTTPHeaderField:(NSString *)httpHeaderField];
            }else{
                NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    if ([type isEqualToString:@"GET"]) {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // 请求成功的时候会调用这里的代码
            // 通知外面的block，请求成功了
            if (success) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                success(json);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // 请求失败的时候会调用这里的代码
            // 通知外面的block，请求失败了
            if (failure) {
                failure(error);
            }
        }];
    }else if ([type isEqualToString:@"POST"]){
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // 请求成功的时候会调用这里的代码
            // 通知外面的block，请求成功了
                                   
            if (success) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                success(json);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // 请求失败的时候会调用这里的代码
            // 通知外面的block，请求失败了
            if (failure) {
                failure(error);
            }
        }];
    }
    
}

+ (NSURL *)writeImageToFile:(UIImage *)image imageName:(NSString *)imageName{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = NSTemporaryDirectory();
    NSString *upLoadFilePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"upLoadFile"]];
    if([fileManager fileExistsAtPath:upLoadFilePath]){
    }else{
        //创建路径
        [fileManager createDirectoryAtPath:upLoadFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSData *data = [[NSData alloc] init];
    if ([image isKindOfClass:[NSString class]]) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)image]];
    }else{
    
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 0.2);
    } else {
        data = UIImagePNGRepresentation(image);
    }
        
    }
    //创建文件
    if (data) {
        
        [fileManager createFileAtPath:[upLoadFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",imageName]] contents:data attributes:nil];
    }
    
    //根据路径得到URL
    NSString *thumbUrl = [NSString stringWithFormat:@"%@/%@",upLoadFilePath,imageName];
    //写入文件
    [data writeToFile:thumbUrl atomically:YES];
    NSURL *imgUrl = [NSURL fileURLWithPath:thumbUrl];
    
    return imgUrl;
}
@end
