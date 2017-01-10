//
//  TCArchiveService.h
//  individual
//
//  Created by 穆康 on 2016/10/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TCArchiveDirectory) {
    TCArchiveDocumentDirectory = 1,
    TCArchiveCachesDirectory
};

@interface TCArchiveService : NSObject

+ (instancetype)sharedService;

- (BOOL)archiveObject:(id)object forLoginUser:(NSString *)uid inDirectory:(TCArchiveDirectory)directory;
- (id)unarchiveObject:(NSString *)modelName forLoginUser:(NSString *)uid inDirectory:(TCArchiveDirectory)directory;
- (BOOL)cleanObject:(NSString *)modelName forLoginUser:(NSString *)uid inDirectory:(TCArchiveDirectory)directory;

@end
