//
//  TCPromotionsManager.m
//  individual
//
//  Created by 穆康 on 2017/5/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPromotionsManager.h"
#import "TCPromotionsWrapper.h"

#import <TCCommonLibs/TCArchiveService.h>
#import <SDWebImageManager.h>

@implementation TCPromotionsManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)storePromotionsAndLoadImageWithPromotions:(TCPromotions *)promotions {
    
    TCArchiveService *archiveService = [TCArchiveService sharedService];
    TCPromotionsWrapper *promotionsWrapper = [archiveService unarchiveObject:NSStringFromClass([TCPromotionsWrapper class]) forLoginUser:nil inDirectory:TCArchiveDocumentDirectory];
    
    BOOL needLoadImage = NO;
    if (promotionsWrapper && promotionsWrapper.promotionsList.count) {
        TCPromotions *lastPromotions = [promotionsWrapper.promotionsList lastObject];
        if (![lastPromotions.url isEqualToString:promotions.url]) {
            needLoadImage = YES;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:promotionsWrapper.promotionsList];
            [temp addObject:promotions];
            promotionsWrapper.promotionsList = [temp copy];
        }
    } else {
        needLoadImage = YES;
        promotionsWrapper = [[TCPromotionsWrapper alloc] init];
        promotionsWrapper.promotionsList = @[promotions];
    }
    
    if (needLoadImage) {
        BOOL success = [archiveService archiveObject:promotionsWrapper forLoginUser:nil inDirectory:TCArchiveDocumentDirectory];
        if (!success) {
            TCLog(@"TCPromotions对象存储失败");
        }
        
        // 下载图像
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:promotions.url]
                                                    options:SDWebImageRetryFailed
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                      
                                                  }];
    }
}

- (void)queryPromotionsAndImage:(TCPromotionsQueryBlock)queryBlock {
    
    TCArchiveService *archiveService = [TCArchiveService sharedService];
    TCPromotionsWrapper *promotionsWrapper = [archiveService unarchiveObject:NSStringFromClass([TCPromotionsWrapper class]) forLoginUser:nil inDirectory:TCArchiveDocumentDirectory];
    
    NSInteger deleteIndex = -1;
    TCPromotions *promotions = nil;
    UIImage *image = nil;
    NSDate *currentDate = [NSDate date];
    
    if (promotionsWrapper && promotionsWrapper.promotionsList.count) {
        for (int i=0; i<promotionsWrapper.promotionsList.count; i++) {
            TCPromotions *tempPromotions = promotionsWrapper.promotionsList[i];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:tempPromotions.startTime / 1000.0];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:tempPromotions.endTime / 1000.0];
            if ([startDate compare:currentDate] == NSOrderedAscending && [endDate compare:currentDate] == NSOrderedDescending) {
                if (promotions) {
                    if ([startDate compare:[NSDate dateWithTimeIntervalSince1970:promotions.startTime / 1000.0]] == NSOrderedDescending) {
                        promotions = tempPromotions;
                    }
                } else {
                    promotions = tempPromotions;
                }
            } else if ([endDate compare:currentDate] == NSOrderedAscending) {
                deleteIndex = i;
            }
        }
    }
    
    if (deleteIndex >= 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:promotionsWrapper.promotionsList];
        [temp removeObjectAtIndex:deleteIndex];
        promotionsWrapper.promotionsList = [temp copy];
        
        BOOL success = [archiveService archiveObject:promotionsWrapper forLoginUser:nil inDirectory:TCArchiveDocumentDirectory];
        if (!success) {
            TCLog(@"promotionsWrapper对象存储失败");
        }
    }
    
    if (promotions) {
        NSURL *URL = [NSURL URLWithString:promotions.url];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
        image = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
        if (image == nil) {
            [[SDWebImageManager sharedManager] loadImageWithURL:URL
                                                        options:SDWebImageRetryFailed
                                                       progress:nil
                                                      completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                          
                                                      }];
        }
    }
    
    if (queryBlock) {
        queryBlock(promotions, image);
    }
}

@end
