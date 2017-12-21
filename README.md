# ZLCleanCaches
iOS利用SDWebImage实现缓存的计算与清理

> 思路如下:
可以仅仅清理图片缓存, 也可以清理所有的缓存文件(包括图片、视频、音频等).
一般我们项目中的缓存一般分为2大块：
一个是自己缓存的一些数据;
还有一个就是我们使用的SDWebImage这个第三方库给我们自动缓存的图片文件缓存了.

![清理缓存.png](https://github.com/ZLFighting/ZLCleanCaches/blob/master/ZLCleanCaches/实际项目截图.jpeg)


## 1、仅仅清理图片缓存
如果你只想清理图片缓存，且是用SDWebImage加载的网络图片，那么你可以用SDWebImage内部封装方法清除图片缓存

```

//导入头文件
#import <SDImageCache.h>

//获取缓存图片的大小(字节)
NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];

//换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
float MBCache = bytesCache/1000/1000;

//异步清除图片缓存 （磁盘中的）
dispatch_async(dispatch_get_global_queue(0, 0), ^{

[[SDImageCache sharedImageCache] clearDisk];
});
```

## 2、清理所有缓存文件
如果你想清理所有的缓存文件(包括图片、视频、音频等)， 那你可以用如下方法。需要你把caches的路径传过去，然后计算caches文件夹下内容的大小，然后根据其大小再判断是否清除缓存。(根据路径删除文件或文件夹)

为了让代码看起来更整洁，这里将缓存的计算及清理封装自定义一个工具类：

```
//  利用SDWebImage计算并清理缓存

#import <Foundation/Foundation.h>

@interface QTXCleanCaches : NSObject

+ (float)fileSizeAtPath:(NSString *)path;

+ (float)folderSizeAtPath:(NSString *)path;

+ (void)clearCache:(NSString *)path;

@end
```

```
#import "QTXCleanCaches.h"
#import "SDImageCache.h"

@implementation QTXCleanCaches

// 1.计算单个文件大小
+ (float)fileSizeAtPath:(NSString *)path {
NSFileManager *fileManager=[NSFileManager defaultManager];
if([fileManager fileExistsAtPath:path]){
long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
return size/1024.0/1024.0;
}
return 0;
}

// 2.计算文件夹大小(要利用上面的1提供的方法)
+ (float)folderSizeAtPath:(NSString *)path {
NSFileManager *fileManager=[NSFileManager defaultManager];
float folderSize;
if ([fileManager fileExistsAtPath:path]) {
NSArray *childerFiles=[fileManager subpathsAtPath:path];
for (NSString *fileName in childerFiles) {
NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
folderSize += [self fileSizeAtPath:absolutePath];
}
// SDWebImage框架自身计算缓存的实现
folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
return folderSize;
}
return 0;
}

// 3.清除缓存
+ (void)clearCache:(NSString *)path {
NSFileManager *fileManager=[NSFileManager defaultManager];
if ([fileManager fileExistsAtPath:path]) {
NSArray *childerFiles=[fileManager subpathsAtPath:path];
for (NSString *fileName in childerFiles) {
//如有需要，加入条件，过滤掉不想删除的文件
NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
[fileManager removeItemAtPath:absolutePath error:nil];
}
}
[[SDImageCache sharedImageCache] cleanDisk];
}

@end
```

只需要在所使用的控制器里调取计算和清理缓存的方法即可：
```
#import "QTXSetupController.h"
#import "QTXAlterView.h"
#import "QTXCleanCaches.h"

@interface QTXSetupController () <QTXAlterViewDelegate>

@end
```

```
// 在清理缓存的点击事件里处理

// 1.计算缓存大小
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
NSString *cachesDir = [paths objectAtIndex:0];
float size = [QTXCleanCaches folderSizeAtPath:cachesDir];

// 2.这里是我自定义的弹框QTXAlterView，可以选择系统自带的使用
QTXAlterView *alter = [[QTXAlterView alloc] initWithMessage:[NSString stringWithFormat:@"已清理%.2lfM缓存", size] delegate:self rightButtonTitle:@"确定" otherButtonTitles:nil];
[alter show];
// 清理缓存
[QTXCleanCaches clearCache:cachesDir];
```


思路详情请移步技术文章:[iOS利用SDWebImage实现缓存的计算与清理](http://blog.csdn.net/smilezhangli/article/details/78548752)

您的支持是作为程序媛的我最大的动力, 如果觉得对你有帮助请送个Star吧,谢谢啦
