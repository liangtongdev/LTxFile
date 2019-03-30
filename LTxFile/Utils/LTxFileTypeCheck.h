//
//  LTxFileTypeCheck.h
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import <Foundation/Foundation.h>
#import "LTxFileType.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTxFileTypeCheck : NSObject

/**
 * 根据文件扩展，检查文件格式

 @param path 路径
 @return 图片、视频、PDF、其他
 */
+(LTxFileType)fileTypeWithPath:(NSString*)path;

/**
 * 根据文件扩展，获取文件扩展名(小写)
 
 @param path 路径
 @return 文件扩展名
 */
+(NSString*)fileExtensionWithPath:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
