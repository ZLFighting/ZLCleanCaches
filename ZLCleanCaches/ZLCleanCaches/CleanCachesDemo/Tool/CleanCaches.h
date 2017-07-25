//
//  CleanCaches.h
//  ZLCleanCaches
//
//  Created by ZL on 2017/7/25.
//  Copyright © 2017年 ZL. All rights reserved.
//  利用SDWebImage计算并清理缓存

#import <Foundation/Foundation.h>

@interface CleanCaches : NSObject

+ (float)fileSizeAtPath:(NSString *)path;

+ (float)folderSizeAtPath:(NSString *)path;

+ (void)clearCache:(NSString *)path;

@end
