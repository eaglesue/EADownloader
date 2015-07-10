//
//  EADownloader.m
//  CustomDownloader
//
//  Created by 苏刁 on 15/7/9.
//  Copyright (c) 2015年 苏刁. All rights reserved.
//

#import "EADownloader.h"

@interface EADownloader () <NSURLConnectionDataDelegate>

@property (nonatomic, assign) long long currentLength;
@property (nonatomic, assign) long long totalLength;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic ,strong) NSFileHandle *fileHandler;


@end

@implementation EADownloader

- (void)start {
    
    NSURL *url = [NSURL URLWithString:self.URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *value = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [request setValue:value forHTTPHeaderField:@"Range"];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    _downloading = YES;
    
}

- (void)pause {
    
    [self.connection cancel];
    self.connection = nil;
    _downloading = NO;
}

#pragma mark - <NSURLConnectionDataDelegate>


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if (self.totalLength) {
        return;
    }
    //获得文件总长度
    self.totalLength = response.expectedContentLength;
    
    //路径下的源文件
    NSData *originData = [NSData dataWithContentsOfFile:self.filePath];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    //判断重复下载
    if ([manager fileExistsAtPath:self.filePath] && self.totalLength == originData.length) {
        self.downloadSuccess();
        [self pause];
        return;
    }
    [manager createFileAtPath:self.filePath contents:nil attributes:nil];
    //创建文件句柄
    self.fileHandler = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    self.currentLength += data.length;
    if (self.Progress) {
        self.Progress( (double)self.currentLength / self.totalLength);
    }
    //定位文件尾部
    [self.fileHandler seekToEndOfFile];
    //写入数据
    [self.fileHandler writeData:data];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    self.totalLength = 0;
    self.currentLength = 0;
    
    [self.fileHandler closeFile];
    self.fileHandler = nil;
    if (self.downloadSuccess) {
        self.downloadSuccess();
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (self.downloadFaild) {
        self.downloadFaild(error);
    }
}



@end
