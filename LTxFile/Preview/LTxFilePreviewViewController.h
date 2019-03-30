//
//  LTxFilePreviewViewController.h
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * 文件预览
 */
@interface LTxFilePreviewViewController : UIViewController

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



@end

NS_ASSUME_NONNULL_END
