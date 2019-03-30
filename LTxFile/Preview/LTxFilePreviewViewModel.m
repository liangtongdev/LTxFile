//
//  LTxFilePreviewViewModel.m
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import "LTxFilePreviewViewModel.h"

@interface LTxFilePreviewViewModel()<NSURLSessionDelegate>
@property (nonatomic, copy) NSString* fileSavePath;
@property (nonatomic, copy) LTxFileDownloadProgressChanged progressCallback;
@property (nonatomic, copy) LTxFileDownloadComplete completeCallback;
@property (nonatomic, copy) LTxFileDownloadFailed failedCallback;
@end

@implementation LTxFilePreviewViewModel

-(instancetype)init{
	self = [super init];
	if (self){/* code */
		[self setupDownloadTaskService];
	}
	return self;
}

-(void)setupDownloadTaskService{
	NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
	NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	_session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:operationQueue];
}

-(void)downloadFileWithURL:(NSURL*)url 
fileSavePath:(NSString*)fileSavePath 
progressChanged:(LTxFileDownloadProgressChanged)progressChanged
complete:(LTxFileDownloadComplete)complete
failed:(LTxFileDownloadFailed)failed{
	self.fileSavePath = fileSavePath;
	self.progressCallback = progressChanged;
	self.completeCallback = complete;
	self.failedCallback = failed;
	NSURLSessionDownloadTask* downloadTask = [self.session downloadTaskWithURL:url];
    downloadTask.taskDescription = [url absoluteString];
    [downloadTask resume];
}
#pragma mark - NSURLSessionDelegate
-(void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    if (self.progressCallback){
    	CGFloat progress = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
    	self.progressCallback(progress);
    }
}
-(void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location{
  
     	NSError* error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager moveItemAtPath:location.path toPath:self.fileSavePath error:&error];
        if (error) {
            if (self.failedCallback)
            {
            	self.failedCallback(error.description);
            }
        }
}
/*
 4.请求完成之后调用
 如果请求失败，那么error有值
 */
-(void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    if (error) {
            if (self.failedCallback){
            	self.failedCallback(error.description);
            }
        }else{
        	if (self.completeCallback){
            	self.completeCallback();
            } 
        }
}
@end
