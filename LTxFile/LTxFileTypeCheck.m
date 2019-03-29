//
//  LTxFileTypeCheck.m
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import "LTxFileTypeCheck.h"

@implementation LTxFileTypeCheck
/**
 * 根据文件扩展，检查文件格式
 
 @param path 路径
 @return 图片、视频、PDF、其他
 */
+(LTxFileType)fileTypeWithPath:(NSString*)path{
    if (!path) {
        return LTxFileTypeUnkonwn;
    }
    NSString* extension = [[path pathExtension] lowercaseString];
    if ([extension isEqualToString:@""]) {
        return LTxFileTypeUnkonwn;
    }
    
    if ([@[@"png",@"bmp",@"gif",@"jpg",@"jpeg",@"ico"] containsObject:extension]) {
        return LTxFileTypeImage;
    }
    
    if ([@[@"mp4",@"mov",@"m3u8",@"mp3"] containsObject:extension]) {
        return LTxFileTypeVideo;
    }
    
    if ([@[@"doc",@"docx",@"pdf",@"ppt",@"pptx",@"xls",@"xlsx"] containsObject:extension]) {
        return LTxFileTypeDocument;
    }
    return LTxFileTypeUnkonwn;
}

/**
 * 根据文件扩展，获取文件扩展名(小写)
 
 @param path 路径
 @return 文件扩展名
 */
+(NSString*)fileExtensionWithPath:(NSString*)path{
    if (!path) {
        return nil;
    }
    return [[path pathExtension] lowercaseString];
}

@end
