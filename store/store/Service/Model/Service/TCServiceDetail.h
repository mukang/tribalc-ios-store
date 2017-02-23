//
//  TCServiceDetail.h
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCListStore.h"
#import "TCDetailStore.h"

@interface TCServiceDetail : NSObject

/** 服务ID */
@property (copy, nonatomic) NSString *ID;
/** 服务名称 */
@property (copy, nonatomic) NSString *name;
/** 服务主图 */
@property (copy, nonatomic) NSString *mainPicture;
/** 人均消费 */
@property (nonatomic) CGFloat personExpense;
/** 标签 */
@property (nonatomic) NSArray *tags;
/** 是否接受预订 */
@property (nonatomic) BOOL reservable;
/** 店铺信息 */
@property TCListStore *store;

/** 推荐主题 */
@property (copy, nonatomic) NSString *topics;
/** 服务 */
@property (copy, nonatomic) NSArray *pictures;
/** H5详情URI */
@property (copy, nonatomic) NSString *detailURL;
/** 收藏人数 */
@property (nonatomic) NSInteger collectionNum;
/** 预定人数 */
@property (nonatomic) NSInteger reservationNum;
/** 推荐理由 */
@property (copy, nonatomic) NSString *recommendedReason;
/** 店铺详情信息 */
@property TCDetailStore *detailStore;



@end


