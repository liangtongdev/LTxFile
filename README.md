# LTxFile
目前包括以下功能：

+ 文件预览
  + 在线（可选：缓存）
    + 可选：使用缓存
    + 格式：图片、文稿、音视频、网页
  + 本地
    + 格式：图片、文稿、音视频、网页
    + 使用其他应用打开
+ UI可定制
+ 文件相关工具类



#### 使用

推荐使用`Cocoapods`的方式，在你的`Podfile`中添加以下内容之后，执行`pod install`即可

```shell
  pod 'LTxFile'
```

在你需要使用的地方，引入头文件即可

```objective-c
#import <LTxFile/LTxFile.h>
```



#### 例子

例如，你要预览一个在线文件，优先使用沙盒中的缓存文件，你还想将该文件分享给其他应用，代码如下：

```objective-c
LTxFilePreviewViewController* previewVC = [[LTxFilePreviewViewController alloc] init];
previewVC.fileURL = [NSURL URLWithString:@"https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf"];
previewVC.useCache = true;
previewVC.pathInSandbox = @"Library/Caches";
previewVC.shareWithOtherApp = true;
previewVC.shareBtnTextColor = [UIColor brownColor];
dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:previewVC animated:true];
});
```



###### 配置

对于文件预览，你可以进行以下配置

```objective-c
#pragma mark - 设置
//进度条颜色
@property (nonatomic, strong) UIColor* progressTintColor;

//是否支持其他应用打开
@property (nonatomic, assign) BOOL shareWithOtherApp;
@property (nonatomic, strong) UIColor* shareBtnTextColor;

#pragma mark - 在线文件
//是否缓存在线文件
@property (nonatomic, assign) BOOL useCache;
//存放于沙盒的路径
@property (nonatomic, copy) NSString* pathInSandbox;
//在线文件地址
@property (nonatomic, strong) NSURL* fileURL;

#pragma mark - 本地文件
//本地文件地址
@property (nonatomic, strong) NSURL* filePath;
```



#### 其他

相关工具类，参照**`Utils`** 文件夹。

如果你有更多的功能需求，请留言或者发生邮件到liangtongdev@163.com



#### License

MIT

 



