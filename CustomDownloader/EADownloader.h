//
//  EADownloader.h
//  CustomDownloader
//
//  Created by 苏刁 on 15/7/9.
//  Copyright (c) 2015年 苏刁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EADownloader : NSObject

/**
 *  url
 */
@property (nonatomic, strong) NSString *URL;

/**
 *  文件路径
 */
@property (nonatomic, strong) NSString *filePath;

/**
 *  下载进度
 */
@property (nonatomic, copy) void (^Progress)(double progress);

/**
 *  下载完成
 */
@property (nonatomic, copy) void (^downloadSuccess)();

/**
 *  下载错误
 */
@property (nonatomic, copy) void (^downloadFaild)(NSError *error);

/**
 *  是否正在下载
 */
@property (nonatomic, assign, readonly, getter=isDownloading) BOOL downloading;

/**
 *  开始\恢复下载
 */
- (void)start;

/**
 *  暂停下载
 */
- (void)pause;

@end
