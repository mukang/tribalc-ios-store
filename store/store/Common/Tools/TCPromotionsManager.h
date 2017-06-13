//
//  TCPromotionsManager.h
//  individual
//
//  Created by 穆康 on 2017/5/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPromotions.h"

typedef void(^TCPromotionsQueryBlock)(TCPromotions * _Nullable promotions, UIImage * _Nullable image);

@interface TCPromotionsManager : NSObject

/**
 初始化方法
 */
+ (nonnull instancetype)sharedManager;

/**
 存储TCPromotions对象，并下载图像

 @param promotions TCPromotions对象
 */
- (void)storePromotionsAndLoadImageWithPromotions:(TCPromotions *_Nullable)promotions;

/**
 查询TCPromotions对象和对应的图像

 @param queryBlock 结果回调
 */
- (void)queryPromotionsAndImage:(TCPromotionsQueryBlock _Nullable)queryBlock;

@end
