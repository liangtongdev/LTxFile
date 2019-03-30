//
//  LTxFilePreviewViewModel.h
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LTxFileDownloadProgressChanged)(CGFloat);
typedef void (^LTxFileDownloadComplete)(void);
typedef void (^LTxFileDownloadFailed)(NSString*);

@interface LTxFilePreviewViewModel : NSObject


@property (nonatomic, strong, nullable) NSURLSession* session;//下载用

/****
 * 文件下载
 ****/
-(void)downloadFileWithURL:(NSURL*)url 
fileSavePath:(NSString*)fileSavePath 
progressChanged:(LTxFileDownloadProgressChanged)progressChanged
complete:(LTxFileDownloadComplete)complete
failed:(LTxFileDownloadFailed)failed;

@end

NS_ASSUME_NONNULL_END
