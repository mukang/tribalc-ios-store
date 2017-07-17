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
extern NSString *const TCBuluoApiNotificationUserLoginFailure;
extern NSString *const TCBuluoApiNotificationUserDidLogout;
extern NSString *const TCBuluoApiNotificationUserInfoDidUpdate;
extern NSString *const TCBuluoApiNotificationStoreDidCreated;

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

/**
 商家获取产品列表
 
 @param isPublished 是否上架
 @param limitSize 获取数量
 @param sort 排序
 @param sortSkip 默认查询起步的时间和跳过时间，以逗号分隔
 @param resultBlock 结果回调
 */
- (void)fetchGoodsWrapper:(BOOL)isPublished limitSize:(NSUInteger)limitSize sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsMetaWrapper *, NSError *))resultBlock;


/**
 获取商品规格组列表
 
 @param limitSize 获取数量
 @param sortSkip 默认查询起步的时间和跳过时间，以逗号分隔
 @param resultBlock 结果回调
 */
- (void)fetchGoodsStandardWarpper:(NSUInteger)limitSize category:(NSString *)category sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsStandardWrapper *goodsStandardWrapper, NSError *error))resultBlock;

/**
 创建商品
 
 @param goods 商品
 @param goodsStandardMate 规格
 @param resultBlock 回调
 */
- (void)createGoods:(TCGoodsMeta *)goods goodsStandardMate:(TCGoodsStandardMate *)goodsStandardMate mainGoodsStandardKey:(NSString *)key result:(void (^)(NSArray *goodsArr, NSError *error))resultBlock;


/**
 修改商品发布状态
 
 @param goodsId 商品id
 @param published 是否上架
 @param resultBlock 回调
 */
- (void)modifyGoodsState:(NSString *)goodsId published:(NSString *)published result:(void (^)(BOOL, NSError *))resultBlock;


/**
 删除商品
 
 @param goodsId 商品id
 @param resultBlock 回调
 */
- (void)deleteGoods:(NSString *)goodsId result:(void (^)(BOOL, NSError *))resultBlock;


/**
 获取商品规格组
 
 @param standardId 规格组id
 @param resultBlock 回调
 */
- (void)getGoodsStandard:(NSString *)standardId result:(void (^)(TCGoodsStandardMate *goodsStandardMate, NSError *error))resultBlock;


/**
 修改商品
 
 @param goods 商品
 @param resultBlock 回调
 */
- (void)modifyGoods:(TCGoodsMeta *)goods result:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 服务类资源

/**
 获取服务列表

 @param query query
 @param resultBlock 结果回调，serviceWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchServiceWrapperWithQuery:(NSString *)query result:(void (^)(TCServiceWrapper *serviceWrapper, NSError *error))resultBlock;

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

///**
// 获取店铺基本信息
//
// @param resultBlock 结果回调，storeInfo为nil时表示获取失败，失败原因见error的code和userInfo
// */
//- (void)fetchStoreInfo:(void (^)(TCStoreInfo *storeInfo, NSError *error))resultBlock;

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
- (void)putStoreAuthenticationInfo:(TCAuthenticationInfo *)info result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 获取店铺认证信息
 
 @param resultBlock 回调
 */
- (void)fetchStoreAuthenticationInfo:(void (^)(TCAuthenticationInfo *authenticationInfo, NSError *error))resultBlock;

#pragma mark - 订单资源

/**
 商铺商品订单列表
 
 @param status 订单状态，传nil为查询全部，（NO_SETTLE, SETTLE, DELIVERY, RECEIVED）
 @param limitSize 获取数量，默认值 10
 @param sortSkip 默认查询起步的时间和跳过时间，以逗号分隔，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCGoodsOrderWrapper对象中属性nextSkip的值
 @param resultBlock 结果回调，goodsOrderWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodsOrderWrapper:(NSString *)status limitSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsOrderWrapper *goodsOrderWrapper, NSError *error))resultBlock;

/**
 修改订单状态(发货)
 
 @param goodsOrderChangeInfo TCGoodsOrderChangeInfo对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeGoodsOrderStatus:(TCGoodsOrderChangeInfo *)goodsOrderChangeInfo result:(void (^)(BOOL success, TCGoodsOrder *goodsOrder, NSError *error))resultBlock;

/**
 服务预定列表

 @param limitSize 获取数量，默认值 10
 @param sortSkip 默认查询起步的时间和跳过时间，以逗号分隔，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCReservationWrapper对象中属性nextSkip的值
 @param resultBlock 结果回调，reservationWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchReservationWrapper:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCReservationWrapper *reservationWrapper, NSError *error))resultBlock;

/**
 查询服务预定详细信息

 @param reservationID 服务预定ID
 @param resultBlock 结果回调，reservation为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchDetailReservation:(NSString *)reservationID result:(void (^)(TCReservation *reservation, NSError *error))resultBlock;

/**
 修改预定状态

 @param status 预定状态，只能传入（FAILURE、SUCCEED）
 @param reservationID 服务预定ID
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeReservationStatus:(NSString *)status reservationID:(NSString *)reservationID result:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 钱包资源

/**
 获取钱包信息
 
 @param resultBlock 结果回调，walletAccount为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchWalletAccountInfo:(void (^)(TCWalletAccount *walletAccount, NSError *error))resultBlock;

/**
 获取钱包明细
 
 @param tradingType 交易类型，传nil表示获取全部类型的账单
 @param count  获取数量
 @param sortSkip 默认查询止步的时间和跳过条数，以逗号分隔，如“1478513563773,3”表示查询早于时间1478513563773并跳过后3条记录，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCWalletBillWrapper对象中属性nextSkip的值
 @param face2face 是否面对面
 @param resultBlock 结果回调，walletBillWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchWalletBillWrapper:(NSString *)tradingType count:(NSUInteger)count sortSkip:(NSString *)sortSkip face2face:(NSString *)face2face result:(void (^)(TCWalletBillWrapper *walletBillWrapper, NSError *error))resultBlock;

/**
 修改钱包支付密码（首次设置：messageCode和anOldPassword传nil，重置密码：messageCode传nil，找回密码：anOldPassword传nil）
 
 @param messageCode 短信验证码，找回密码时使用
 @param anOldPassword 旧密码，重置密码时使用
 @param aNewPassword 新密码
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeWalletPassword:(NSString *)messageCode anOldPassword:(NSString *)anOldPassword aNewPassword:(NSString *)aNewPassword result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 获取银行卡列表
 
 @param resultBlock 结果回调，bankCardList为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchBankCardList:(void (^)(NSArray *bankCardList, NSError *error))resultBlock;

/**
 添加银行卡（弃用接口）
 
 @param bankCard 银行卡信息
 @param verificationCode 手机验证码
 @param resultBlock 结果回调，success为NO时表示添加失败，失败原因见error的code和userInfo
 */
- (void)addBankCard:(TCBankCard *)bankCard withVerificationCode:(NSString *)verificationCode result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 准备添加银行卡信息
 
 @param bankCard 银行卡信息
 @param resultBlock 结果回调，bankCard为nil时表示添加失败，失败原因见error的code和userInfo
 */
- (void)prepareAddBankCard:(TCBankCard *)bankCard result:(void (^)(TCBankCard *card, NSError *error))resultBlock;

/**
 确认添加银行卡信息
 
 @param bankCardID 银行卡ID
 @param verificationCode 验证码
 @param resultBlock 结果回调，success为NO时表示添加失败，失败原因见error的code和userInfo
 */
- (void)confirmAddBankCardWithID:(NSString *)bankCardID verificationCode:(NSString *)verificationCode result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 删除银行卡
 
 @param bankCardID 银行卡ID
 @param resultBlock 结果回调，success为NO时表示删除失败，失败原因见error的code和userInfo
 */
- (void)deleteBankCard:(NSString *)bankCardID result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 提交银行卡提现请求

 @param amount 总计金额
 @param bankCardID 银行卡id
 @param resultBlock 结果回调，success为NO时表示提交申请失败，失败原因见error的code和userInfo
 */
- (void)commitWithdrawReqWithAmount:(double)amount bankCardID:(NSString *)bankCardID result:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 系统初始化接口

/**
 查询应用上下文信息
 
 @param resultBlock 结果回调
 */
- (void)fetchAppInitializationInfo:(void(^)(TCAppInitializationInfo *info, NSError *error))resultBlock;

/**
 获取版本信息
 
 @param resultBlock 结果回调
 */
- (void)fetchAppVersionInfo:(void(^)(TCAppVersion *versionInfo, NSError *error))resultBlock;


/**
 获取首页消息

 @param limit 条数
 @param createDate 创建时间
 @param isNew 是否获取最新消息
 */
- (void)fetchHomeMessageWithLimit:(NSInteger)limit createDate:(NSInteger)createDate isNew:(NSString *)isNew result:(void (^)(NSArray *, NSError *))resultBlock;

@end
