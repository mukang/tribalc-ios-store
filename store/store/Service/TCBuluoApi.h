//
//  TCBuluoApi.h
//  store
//
//  Created by 穆康 on 2017/1/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCModelImport.h"

extern NSString *const TCBuluoApiNotificationUserDidLogin;
extern NSString *const TCBuluoApiNotificationUserDidLogout;
extern NSString *const TCBuluoApiNotificationUserInfoDidUpdate;

@interface TCBuluoApi : NSObject

/**
 获取api实例
 
 @return 返回TCBuluoApi实例
 */
+ (instancetype)api;

#pragma mark - 设备相关

@property (nonatomic, assign, readonly, getter=isPrepared) BOOL prepared;

/**
 准备工作
 
 @param completion 准备完成回调
 */
- (void)prepareForWorking:(void(^)(NSError * error))completion;

#pragma mark - 用户会话相关

/**
 检查是否需要重新登录
 
 @return 返回BOOL类型的值，YES表示需要，NO表示不需要
 */
- (BOOL)needLogin;

/**
 获取当前已登录用户的会话
 
 @return 返回currentUserSession实例，返回nil表示当前没有保留的已登录会话或会话已过期
 */
- (TCUserSession *)currentUserSession;

#pragma mark - 用户资源

/**
 用户登录，登录后会保留登录状态
 
 @param phoneInfo 用户登录信息，TCUserPhoneInfo对象
 @param resultBlock 结果回调，userSession为nil时表示登录失败，失败原因见error的code和userInfo
 */
- (void)login:(TCUserPhoneInfo *)phoneInfo result:(void (^)(TCUserSession *userSession, NSError *error))resultBlock;

/**
 用户注销，会检查登录状态，已登录的会撤销登录状态，未登录的情况下直接返回成功
 
 @param resultBlock 结果回调，success为NO时表示登出失败，失败原因见error的code和userInfo
 */
- (void)logout:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 验证资源

/**
 获取手机验证码
 
 @param phone 手机号码
 @param resultBlock 结果回调，success为NO时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchVerificationCodeWithPhone:(NSString *)phone result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 认证图片信息
 
 @param imageData 图片数据
 @param resultBlock 回调结果，uploadInfo是上传图片数据所需的信息，uploadInfo为nil时表示认证失败，失败原因见error的code和userInfo
 */
- (void)authorizeImageData:(NSData *)imageData result:(void (^)(TCUploadInfo *uploadInfo, NSError *error))resultBlock;

#pragma mark - 上传图片资源

/**
 上传图片资源
 
 @param image 要上传的图片
 @param progress 上传进度
 @param resultBlock 结果回调，success为NO时表示上传失败，失败原因见error的code和userInfo
 */
- (void)uploadImage:(UIImage *)image progress:(void (^)(NSProgress *progress))progress result:(void (^)(BOOL success, TCUploadInfo *uploadInfo, NSError *error))resultBlock;

#pragma mark - 商品类资源

/**
 获取商品列表
 
 @param limitSize 获取的数量
 @param sortSkip 默认查询止步的时间和跳过条数，以逗号分隔，如“1478513563773,3”表示查询早于时间1478513563773并跳过后3条记录，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCGoodsWrapper对象中属性nextSkip的值
 @param resultBlock 结果回调，goodsWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodsWrapper:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsWrapper *goodsWrapper, NSError *error))resultBlock;

/**
 获取商品详情
 
 @param goodsID 商品的ID
 @param resultBlock 结果回调，TCGoodDetail为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodDetail:(NSString *)goodsID result:(void (^)(TCGoodDetail *goodDetail, NSError *error))resultBlock;

/**
 获取商品规格
 
 @param goodStandardId 商品规格的ID
 @param resultBlock 结果回调，TCGoodStandards为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodStandards:(NSString *)goodStandardId result:(void (^)(TCGoodStandards *goodStandard, NSError *error))resultBlock;

#pragma mark - 服务类资源

/**
 获取服务列表
 
 @param category 类型
 @param limitSize 获取的数量
 @param sortSkip 默认查询止步的时间和跳过条数，以逗号分隔，如“1478513563773,3”表示查询早于时间1478513563773并跳过后3条记录，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCGoodsWrapper对象中属性nextSkip的值
 @param sort 排序类型
 @param resultBlock 结果回调，goodsWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchServiceWrapper:(NSString *)category limiSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip sort:(NSString *)sort result:(void (^)(TCServiceWrapper *serviceWrapper, NSError *error))resultBlock;

/**
 获取商品详情
 
 @param serviceID 服务的ID
 @param resultBlock 结果回调，TCGoodDetail为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchServiceDetail:(NSString *)serviceID result:(void (^)(TCServiceDetail *serviceDetail, NSError *error))resultBlock;

/**
 创建服务

 @param storeSetMealMeta TCStoreSetMealMeta对象
 @param resultBlock 结果回调，success为NO时表示创建失败，失败原因见error的code和userInfo
 */
- (void)createStoreSetMeal:(TCStoreSetMealMeta *)storeSetMealMeta result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 商户查询自己的服务

 @param resultBlock 结果回调，storeSetMeals为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchStoreSetMeals:(void (^)(NSArray *storeSetMeals, NSError *error))resultBlock;

/**
 修改服务信息（修改全部）

 @param storeSetMealMeta TCStoreSetMealMeta对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeStoreSetMeal:(TCStoreSetMealMeta *)storeSetMealMeta result:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 商铺资源

/**
 创建店铺

 @param storeDetailInfo TCStoreDetailInfo对象
 @param resultBlock 结果回调，storeInfo为nil时表示创建失败，失败原因见error的code和userInfo
 */
- (void)createStore:(TCStoreDetailInfo *)storeDetailInfo result:(void (^)(TCStoreInfo *storeInfo, NSError *error))resultBlock;

/**
 获取店铺基本信息

 @param resultBlock 结果回调，storeInfo为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchStoreInfo:(void (^)(TCStoreInfo *storeInfo, NSError *error))resultBlock;

/**
 获取店铺详细信息

 @param resultBlock 结果回调，storeDetailInfo为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchStoreDetailInfo:(void (^)(TCStoreDetailInfo *storeDetailInfo, NSError *error))resultBlock;

/**
 修改店铺信息（修改全部）
 
 @param storeDetailInfo TCStoreDetailInfo对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeStoreDetailInfo:(TCStoreDetailInfo *)storeDetailInfo result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改店铺名称

 @param name 店铺名称
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeStoreName:(NSString *)name result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改店铺联系人

 @param linkman 店铺联系人
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeStoreLinkman:(NSString *)linkman result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改手机号
 
 @param phoneInfo TCUserPhoneInfo对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changePhone:(TCUserPhoneInfo *)phoneInfo result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改店铺logo

 @param logo 店铺logo
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeStoreLogo:(NSString *)logo result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改店铺壁纸
 
 @param cover 店铺壁纸
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeStoreCover:(NSString *)cover result:(void (^)(BOOL success, NSError *error))resultBlock;



/**
 提交认证信息

 @param info 认证信息
 @param resultBlock 结果回调 success为NO时表示修改失败，失败原因见error的code
 */
- (void)putStoreAuthenticationInfo:(TCAuthenticationInfo *)info result:(void (^)(TCStoreInfo *storeInfo, NSError *error))resultBlock;


/**
 商家获取产品列表

 @param isPublished 是否上架
 @param limitSize 获取数量
 @param sort 排序
 @param sortSkip 默认查询起步的时间和跳过时间，以逗号分隔
 @param resultBlock 结果回调
 */
- (void)fetchGoodsWrapper:(BOOL)isPublished limitSize:(NSUInteger)limitSize sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsWrapper *, NSError *))resultBlock;


/**
 获取商品规格组列表

 @param limitSize 获取数量
 @param sortSkip 默认查询起步的时间和跳过时间，以逗号分隔
 @param resultBlock 结果回调
 */
- (void)fetchGoodsStandardWarpper:(NSUInteger)limitSize sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsStandardWrapper *goodsStandardWrapper, NSError *error))resultBlock;

#pragma mark - 订单资源

/**
 商铺商品订单列表

 @param status 订单状态，传nil为查询全部，（NO_SETTLE, SETTLE, DELIVERY, RECEIVED）
 @param limitSize 获取数量，默认值 10
 @param sortSkip 默认查询起步的时间和跳过时间，以逗号分隔
 @param resultBlock 结果回调，goodsOrderWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodsOrderWrapper:(NSString *)status limitSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsOrderWrapper *goodsOrderWrapper, NSError *error))resultBlock;

/**
 修改订单状态(发货)

 @param goodsOrderChangeInfo TCGoodsOrderChangeInfo对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeGoodsOrderStatus:(TCGoodsOrderChangeInfo *)goodsOrderChangeInfo result:(void (^)(BOOL success, NSError *error))resultBlock;

@end
