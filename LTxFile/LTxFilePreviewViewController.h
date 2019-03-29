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
@property (nonatomic, strong) UIColor* progressTintColor;

#pragma mark - 本地文件
//本地文件地址
@property (nonatomic, strong) NSURL* filePath;

//在线文件地址
@property (nonatomic, strong) NSURL* fileURL;

@end

NS_ASSUME_NONNULL_END
