//
//  TCArchiveService.m
//  individual
//
//  Created by 穆康 on 2016/10/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCArchiveService.h"
#import "TCFunctions.h"

@implementation TCArchiveService

+ (instancetype)sharedService {
    static TCArchiveService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

- (BOOL)archiveObject:(id)object forLoginUser:(NSString *)uid inDirectory:(TCArchiveDirectory)directory {
    NSString *modelName = NSStringFromClass([object class]);
    NSURL *fileURL = [self archiveFileURLForLoginUser:uid andModel:modelName inDirectory:directory];
    return [NSKeyedArchiver archiveRootObject:object toFile:fileURL.path];
}

- (id)unarchiveObject:(NSString *)modelName forLoginUser:(NSString *)uid inDirectory:(TCArchiveDirectory)directory {
    NSURL *fileURL = [self archiveFileURLForLoginUser:uid andModel:modelName inDirectory:directory];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:fileURL.path];
}

- (BOOL)cleanObject:(NSString *)modelName forLoginUser:(NSString *)uid inDirectory:(TCArchiveDirectory)directory {
    NSURL *fileURL = [self archiveFileURLForLoginUser:uid andModel:modelName inDirectory:directory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileURL.path]) {
        return [fileManager removeItemAtURL:fileURL error:nil];
    } else {
        return YES;
    }
}

#pragma mark - Private Methods

- (NSURL *)archiveFileURLForLoginUser:(NSString *)uid andModel:(NSString *)modelName inDirectory:(TCArchiveDirectory)directory {
    NSAssert(modelName, @"modelName不可为nil");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSSearchPathDirectory pathDirectory;
    switch (directory) {
        case TCArchiveCachesDirectory:
            pathDirectory = NSCachesDirectory;
            break;
        case TCArchiveDocumentDirectory:
            pathDirectory = NSDocumentDirectory;
            break;
            
        default:
            pathDirectory = NSCachesDirectory;
            break;
    }
    NSURL *dirURL = [[fileManager URLsForDirectory:pathDirectory inDomains:NSUserDomainMask] firstObject];
    dirURL = [dirURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/tcArchiveService", TCGetAppIdentifier()] isDirectory:YES];
    
    NSURL *archiveDirURL = nil;
    if (uid == nil) {
        archiveDirURL = [dirURL URLByAppendingPathComponent:@"data/archive/common" isDirectory:YES];
    } else {
        archiveDirURL = [dirURL URLByAppendingPathComponent:[NSString stringWithFormat:@"data/archive/%@", TCDigestMD5(uid)] isDirectory:YES];
    }
    
    // 检查目录
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:archiveDirURL.path isDirectory:&isDirectory]) {
        NSError *error = nil;
        [fileManager createDirectoryAtURL:archiveDirURL withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            //TODO: 处理目录创建错误
            return nil;
        }
    } else {
        if (isDirectory == NO) {
            //TODO: 处理目录名已被占用错误
            return nil;
        }
    }
    
    NSURL *fileURL = [archiveDirURL URLByAppendingPathComponent:TCDigestMD5(modelName)];
    return fileURL;
}

@end
