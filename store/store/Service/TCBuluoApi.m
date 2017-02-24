//
//  TCBuluoApi.m
//  store
//
//  Created by 穆康 on 2017/1/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBuluoApi.h"
#import "TCClient.h"
#import "TCArchiveService.h"
#import "NSObject+TCModel.h"

NSString *const TCBuluoApiNotificationUserDidLogin = @"TCBuluoApiNotificationUserDidLogin";
NSString *const TCBuluoApiNotificationUserDidLogout = @"TCBuluoApiNotificationUserDidLogout";
NSString *const TCBuluoApiNotificationUserInfoDidUpdate = @"TCBuluoApiNotificationUserInfoDidUpdate";
NSString *const TCBuluoApiNotificationStoreDidCreated = @"TCBuluoApiNotificationStoreDidCreated";

@implementation TCBuluoApi {
    TCUserSession *_userSession;
}

+ (instancetype)api {
    static TCBuluoApi *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[self class] new];
        [api loadArchivedUserSession];
    });
    return api;
}

#pragma mark - 设备相关

- (void)prepareForWorking:(void (^)(NSError *))completion {
    _prepared = YES;
    
    if (completion) {
        completion(nil);
    }
}

#pragma mark - 用户会话相关

- (void)loadArchivedUserSession {
    NSString *sessionModelName = NSStringFromClass([TCUserSession class]);
    TCArchiveService *archiveService = [TCArchiveService sharedService];
    TCUserSession *session = [archiveService unarchiveObject:sessionModelName
                                                forLoginUser:nil
                                                 inDirectory:TCArchiveDocumentDirectory];
    _userSession = session;
}

- (BOOL)isUserSessionValid {
    if (_userSession) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)needLogin {
    return ![self isUserSessionValid];
}

- (TCUserSession *)currentUserSession {
    if ([self isUserSessionValid]) {
        return _userSession;
    } else {
        return nil;
    }
}

- (void)setUserSession:(TCUserSession *)userSession {
    _userSession = userSession;
    if (userSession) {
        BOOL success = [[TCArchiveService sharedService] archiveObject:userSession
                                                          forLoginUser:nil
                                                           inDirectory:TCArchiveDocumentDirectory];
        if (success) {
            TCLog(@"UserSession归档成功");
        } else {
            TCLog(@"UserSession归档失败");
        }
    }
}

- (void)cleanUserSession {
    if (_userSession) {
        _userSession = nil;
    }
    BOOL success = [[TCArchiveService sharedService] cleanObject:NSStringFromClass([TCUserSession class])
                                                    forLoginUser:nil
                                                     inDirectory:TCArchiveDocumentDirectory];
    if (success) {
        TCLog(@"UserSession清除成功");
    } else {
        TCLog(@"UserSession清除失败");
    }
}

- (void)fetchStoreInfoWithID:(NSString *)ID {
    [self fetchStoreInfo:^(TCStoreInfo *storeInfo, NSError *error) {
        if (storeInfo) {
            TCUserSession *userSession = self.currentUserSession;
            userSession.storeInfo = storeInfo;
            [self setUserSession:userSession];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserDidLogin object:nil];
        }
    }];
}

#pragma mark - 用户资源

- (void)login:(TCUserPhoneInfo *)phoneInfo result:(void (^)(TCUserSession *, NSError *))resultBlock {
    NSString *apiName = @"stores/login";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
    NSDictionary *dic = [phoneInfo toObjectDictionary];
    for (NSString *key in dic.allKeys) {
        [request setValue:dic[key] forParam:key];
    }
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        TCUserSession *userSession = nil;
        NSError *error = response.error;
        if (error) {
            [self setUserSession:nil];
        } else {
            userSession = [[TCUserSession alloc] initWithObjectDictionary:response.data];
            [self setUserSession:userSession];
            [self fetchStoreInfoWithID:userSession.assigned];
        }
        if (resultBlock) {
            if (error) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, error));
            } else {
                TC_CALL_ASYNC_MQ(resultBlock(userSession, nil));
            }
        }
    }];
}

- (void)logout:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
        }
    } else {
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
        }
    }
    [self cleanUserSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserDidLogout object:nil];
}

#pragma mark - 验证资源

- (void)fetchVerificationCodeWithPhone:(NSString *)phone result:(void (^)(BOOL, NSError *))resultBlock {
    NSString *apiName = @"verifications/phone";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
    request.token = self.currentUserSession.token;
    [request setValue:phone forParam:@"value"];
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.statusCode == 202) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
            }
        } else {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
            }
        }
    }];
}

- (void)authorizeImageData:(NSData *)imageData result:(void (^)(TCUploadInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"oss_authorization/picture?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:@"iOS_image.jpg" forParam:@"key"];
        [request setValue:@"image/jpeg" forParam:@"contentType"];
        [request setValue:TCDigestMD5ToData(imageData) forParam:@"contentMD5"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCUploadInfo *uploadInfo = [[TCUploadInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(uploadInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

#pragma mark - 上传图片资源

- (void)uploadImage:(UIImage *)image progress:(void (^)(NSProgress *))progress result:(void (^)(BOOL, TCUploadInfo *, NSError *))resultBlock {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [self authorizeImageData:imageData result:^(TCUploadInfo *uploadInfo, NSError *error) {
        if (error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(NO, nil, error));
            }
        } else {
            NSString *uploadURLString = uploadInfo.url;
            TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut uploadURLString:uploadURLString];
            [request setImageData:imageData];
            [[TCClient client] upload:request progress:progress finish:^(TCClientResponse *response) {
                if (response.statusCode == 200) {
                    if (resultBlock) {
                        TC_CALL_ASYNC_MQ(resultBlock(YES, uploadInfo, nil));
                    }
                } else {
                    if (resultBlock) {
                        TC_CALL_ASYNC_MQ(resultBlock(NO, nil, response.error));
                    }
                }
            }];
        }
    }];
}

#pragma mark - 商品类资源

- (void)fetchGoodsWrapper:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsWrapper *, NSError *))resultBlock {
    NSString *limitSizePart = [NSString stringWithFormat:@"limitSize=%zd", limitSize];
    NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
    NSString *apiName = [NSString stringWithFormat:@"goods?%@%@", limitSizePart, sortSkipPart];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCGoodsWrapper *goodsWrapper = [[TCGoodsWrapper alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodsWrapper, nil));
            }
        }
    }];
}

- (void)fetchGoodDetail:(NSString *)goodsID result:(void (^)(TCGoodDetail *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"goods/%@", goodsID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            
            TCGoodDetail *goodDetail = [[TCGoodDetail alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodDetail, nil));
            }
        }
    }];
}

- (void)fetchGoodStandards:(NSString *)goodStandardId result:(void (^)(TCGoodStandards *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"goods_standards/%@", goodStandardId];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCGoodStandards *goodStandard = [[TCGoodStandards alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodStandard, nil));
            }
        }
    }];
}

#pragma mark - 服务类资源

- (void)fetchServiceWrapper:(NSString *)category limiSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip sort:(NSString *)sort result:(void (^)(TCServiceWrapper *, NSError *))resultBlock {
    NSString *sortPart = sort ? [NSString stringWithFormat:@"sort=%@", sort] : @"sort=popularValue,desc";
    NSString *categoryPart = category ? [NSString stringWithFormat:@"category=%@&", category] : @"";
    NSString *limitSizePart = [NSString stringWithFormat:@"limitSize=%zd&", limitSize];
    NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"sortSkip=%@&", sortSkip] : @"";
    NSString *coordinateStr = @"";
    
    if ([sort isKindOfClass:[NSString class]]) {
        if ([sort isEqualToString:@"coordinate,asc"]) {
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationLatAndLog"];
            if ([str isKindOfClass:[NSString class]]) {
                NSArray *strArr = [str componentsSeparatedByString:@","];
                if ([strArr isKindOfClass:[NSArray class]]) {
                    if (strArr.count == 2) {
                        
                        NSString *lonStr = strArr[1];
                        NSString *latStr = strArr[0];
                        
                        if ([lonStr isKindOfClass:[NSString class]] && [latStr isKindOfClass:[NSString class]]) {
                            coordinateStr = [NSString stringWithFormat:@"coordinate=%@,%@&",lonStr,latStr];
                        }
                        
                    }
                }
            }
        }
    }
    
    NSString *apiName = [NSString stringWithFormat:@"store_set_meals?%@%@%@%@%@", categoryPart, limitSizePart, sortSkipPart,coordinateStr, sortPart];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCServiceWrapper *serviceWrapper = [[TCServiceWrapper alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(serviceWrapper, nil));
            }
        }
    }];
}

- (void)fetchServiceDetail:(NSString *)serviceID result:(void (^)(TCServiceDetail *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"store_set_meals/%@", serviceID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCServiceDetail *serviceDetail = [[TCServiceDetail alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(serviceDetail, nil));
            }
        }
    }];
}

- (void)createStoreSetMeal:(TCStoreSetMealMeta *)storeSetMealMeta result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"store_set_meals?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [storeSetMealMeta toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forKey:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 201) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchStoreSetMeals:(void (^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"store_set_meals?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                NSArray *array = response.data;
                NSMutableArray *temp = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    TCStoreSetMealMeta *storeSetMealMeta = [[TCStoreSetMealMeta alloc] initWithObjectDictionary:dic];
                    [temp addObject:storeSetMealMeta];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock([temp copy], nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeStoreSetMeal:(TCStoreSetMealMeta *)storeSetMealMeta result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"store_set_meals/%@", storeSetMealMeta.ID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [storeSetMealMeta toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forKey:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

#pragma mark - 商铺资源

- (void)createStore:(TCStoreDetailInfo *)storeDetailInfo result:(void (^)(TCStoreInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [storeDetailInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forKey:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 201) {
                TCStoreInfo *storeInfo = [[TCStoreInfo alloc] initWithObjectDictionary:response.data];
                TCUserSession *userSession = self.currentUserSession;
                userSession.storeInfo = storeInfo;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(storeInfo, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchStoreInfo:(void (^)(TCStoreInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCStoreInfo *storeInfo = [[TCStoreInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(storeInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchStoreDetailInfo:(void (^)(TCStoreDetailInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCStoreDetailInfo *detailInfo = [[TCStoreDetailInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(detailInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeStoreDetailInfo:(TCStoreDetailInfo *)storeDetailInfo result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [storeDetailInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forKey:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.storeInfo.name = storeDetailInfo.name;
                userSession.storeInfo.logo = storeDetailInfo.logo;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeStoreName:(NSString *)name result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/name", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:name forKey:@"name"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.storeInfo.name = name;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeStoreLinkman:(NSString *)linkman result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/linkman", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:linkman forKey:@"linkman"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.storeInfo.linkman = linkman;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changePhone:(TCUserPhoneInfo *)phoneInfo result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/phone", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [phoneInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.storeInfo.phone = phoneInfo.phone;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeStoreLogo:(NSString *)logo result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/logo", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:logo forKey:@"logo"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.storeInfo.logo = logo;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeStoreCover:(NSString *)cover result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/cover", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:cover forKey:@"cover"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.storeInfo.cover = cover;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)putStoreAuthenticationInfo:(TCAuthenticationInfo *)info result:(void (^)(BOOL success, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/authentication", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        
        NSDictionary *dic = [info toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forKey:key];
        }
            
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    
//                    TCStoreInfo *uploadInfo = [[TCStoreInfo alloc] initWithObjectDictionary:response.data];
                    
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchGoodsWrapper:(BOOL)isPublished limitSize:(NSUInteger)limitSize sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsMetaWrapper *, NSError *))resultBlock {
    
    NSString *published;
    if (isPublished) {
        published = @"true";
    }else {
        published = @"false";
    }
    
    NSString *limitSizePart = [NSString stringWithFormat:@"&limitSize=%zd", limitSize];
    NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
    NSString *sor = sort ? [NSString stringWithFormat:@"&sort=%@",sort] : @"";
    NSString *apiName = [NSString stringWithFormat:@"goods?me=%@&published=%@%@%@%@",[[TCBuluoApi api] currentUserSession].storeInfo.ID,published, limitSizePart, sortSkipPart,sor];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCGoodsMetaWrapper *goodsWrapper = [[TCGoodsMetaWrapper alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodsWrapper, nil));
            }
        }
    }];
}

- (void)fetchGoodsStandardWarpper:(NSUInteger)limitSize category:(NSString *)category sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsStandardWrapper *goodsStandardWrapper, NSError *error))resultBlock {
    NSString *limitSizePart = [NSString stringWithFormat:@"&limitSize=%zd", limitSize];
    NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
    NSString *sor = sort ? [NSString stringWithFormat:@"&sort=%@",sort] : @"";
    NSString *categoryStr = category ? [NSString stringWithFormat:@"&category=%@",category] : @"";
    NSString *apiName = [NSString stringWithFormat:@"goods_standards?me=%@%@%@%@%@",[[TCBuluoApi api] currentUserSession].storeInfo.ID,categoryStr, limitSizePart, sortSkipPart,sor];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCGoodsStandardWrapper *goodsStandardWarpper = [[TCGoodsStandardWrapper alloc] initWithObjectDictionary:response.data];
            
            NSArray *arr = goodsStandardWarpper.content;
            for (int i = 0; i < arr.count; i++) {
                TCGoodsStandardMate *goodsStandard = arr[i];
                NSDictionary *dict = goodsStandard.priceAndRepertoryMap;
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dict];
                for (int j = 0; j < mutableDic.allKeys.count; j++) {
                    NSString *key = mutableDic.allKeys[j];
                    NSDictionary *dic = mutableDic[key];
                    TCGoodsPriceAndRepertory *priceAndRep = [[TCGoodsPriceAndRepertory alloc] initWithObjectDictionary:dic];
                    mutableDic[key] = priceAndRep;
                }
                goodsStandard.priceAndRepertoryMap = mutableDic;
            }
            
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodsStandardWarpper, nil));
            }
        }
    }];
}

- (void)createGoods:(TCGoodsMeta *)goods goodsStandardMate:(TCGoodsStandardMate *)goodsStandardMate mainGoodsStandardKey:(NSString *)key result:(void (^)(NSArray *goodsArr, NSError *error))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"goods?me=%@",[[TCBuluoApi api] currentUserSession].storeInfo.ID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
    request.token = self.currentUserSession.token;
    NSDictionary *goodDic = [goods toObjectDictionary];
    
    
    if (goodsStandardMate && key) {
        
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        
        NSDictionary *standardMateDic = [goodsStandardMate toObjectDictionary];
        for (NSString *key in standardMateDic.allKeys) {
            if ([standardMateDic[key] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = standardMateDic[key];
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithCapacity:0];
                for (NSString *subKey in dic.allKeys) {
                    if ([dic[subKey] isKindOfClass:[TCGoodsPriceAndRepertory class]]) {
                        
                        TCGoodsPriceAndRepertory *priceAndRepertory = dic[subKey];
                        
                        [mutableDic setValue:[priceAndRepertory toObjectDictionary]  forKey:subKey];
                    }else {
                        [mutableDic setValue:dic[subKey] forKey:subKey];
                    }
                }
                [mutableDictionary setValue:mutableDic forKey:key];
            }else {
                [mutableDictionary setValue:standardMateDic[key] forKey:key];
            }
            
        }
        [request setValue:mutableDictionary forKey:@"standardMeta"];
        
        NSMutableDictionary *goodsMutableDic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSString *key in goodDic.allKeys) {
            if (![key isEqualToString:@"standardId"]) {
                [goodsMutableDic setValue:goodDic[key] forKey:key];
            }
            
        }
        
        [request setValue:goodsMutableDic forKey:@"goodsMeta"];
        [request setValue:key forKey:@"primaryStandardKey"];
    }else {
        
        [request setValue:goodDic forKey:@"goodsMeta"];
        
    }
    
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        }else {
            NSArray *arr = (NSArray *)response.data;
            NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
            if ([arr isKindOfClass:[NSArray class]]) {
                if (arr.count) {
                    for (int i = 0; i < arr.count; i++) {
                        NSDictionary *dic = arr[i];
                        TCGoodsMeta *good = [[TCGoodsMeta alloc] initWithObjectDictionary:dic];
                        if (good) {
                            [mutableArr addObject:good];
                        }
                    }
                }
                
                if (resultBlock && mutableArr.count) {
                    TC_CALL_ASYNC_MQ(resultBlock(mutableArr, nil));
                }else {
                    if (resultBlock) {
                        TC_CALL_ASYNC_MQ(resultBlock(nil, nil));
                    }
                }
            }else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, nil));
                }
            }
            
        }
    }];
}

- (void)modifyGoodsState:(NSString *)goodsId published:(NSString *)published result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"goods/%@/published?me=%@", goodsId,self.currentUserSession.storeInfo.ID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        
        [request setValue:published forKey:@"value"];
        
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)deleteGoods:(NSString *)goodsId result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"goods/%@?me=%@", goodsId,self.currentUserSession.storeInfo.ID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 204) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)getGoodsStandard:(NSString *)standardId result:(void (^)(TCGoodsStandardMate *goodsStandardMate, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"goods_standards/%@", standardId];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    
                    TCGoodsStandardMate *mate = [[TCGoodsStandardMate alloc] initWithObjectDictionary:response.data];
                    
                    TC_CALL_ASYNC_MQ(resultBlock(mate, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)modifyGoods:(TCGoodsMeta *)goods result:(void (^)(BOOL success, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"goods/%@?me=%@", goods.ID,self.currentUserSession.storeInfo.ID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        
        NSDictionary *dic = [goods toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forKey:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}
    
#pragma mark - 订单资源
    
- (void)fetchGoodsOrderWrapper:(NSString *)status limitSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsOrderWrapper *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *statusPart = status ? [NSString stringWithFormat:@"&status=%@", status] : @"";
        NSString *limitSizePart = [NSString stringWithFormat:@"&limitSize=%zd", limitSize];
        NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
        NSString *apiName = [NSString stringWithFormat:@"orders?type=store&me=%@%@%@%@",self.currentUserSession.assigned, statusPart, limitSizePart, sortSkipPart];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCGoodsOrderWrapper *goodsOrderWrapper = [[TCGoodsOrderWrapper alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(goodsOrderWrapper, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeGoodsOrderStatus:(TCGoodsOrderChangeInfo *)goodsOrderChangeInfo result:(void (^)(BOOL, TCGoodsOrder *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"orders/%@/status?type=store&me=%@", goodsOrderChangeInfo.orderID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [goodsOrderChangeInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    TCGoodsOrder *goodsOrder = [[TCGoodsOrder alloc] initWithObjectDictionary:response.data];
                    TC_CALL_ASYNC_MQ(resultBlock(YES, goodsOrder, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, nil, sessionError));
        }
    }
}

- (void)fetchStoreAuthenticationInfo:(void (^)(TCAuthenticationInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/authentication", self.currentUserSession.storeInfo.ID];

        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {

                TCAuthenticationInfo *detailInfo = [[TCAuthenticationInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(detailInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

         
- (void)fetchReservationWrapper:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCReservationWrapper *, NSError *))resultBlock {
 if ([self isUserSessionValid]) {
     NSString *limitSizePart = [NSString stringWithFormat:@"&limitSize=%zd", limitSize];
     NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
     NSString *apiName = [NSString stringWithFormat:@"reservations?type=store&me=%@%@%@",self.currentUserSession.assigned, limitSizePart, sortSkipPart];
     
     TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
     request.token = self.currentUserSession.token;
     [[TCClient client] send:request finish:^(TCClientResponse *response) {
         if (response.error) {
             if (resultBlock) {
                 TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
             }
         } else {
             TCReservationWrapper *reservationWrapper = [[TCReservationWrapper alloc] initWithObjectDictionary:response.data];
             if (resultBlock) {
                 TC_CALL_ASYNC_MQ(resultBlock(reservationWrapper, nil));
                 
             }
         }
     }];
    }else {
         TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
         if (resultBlock) {
             TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
         }
 }
}

- (void)fetchDetailReservation:(NSString *)reservationID result:(void (^)(TCReservation *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"reservations/%@?type=store&me=%@", reservationID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCReservation *reservation = [[TCReservation alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(reservation, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeReservationStatus:(NSString *)status reservationID:(NSString *)reservationID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"reservations/%@/status?type=store&me=%@", reservationID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:status forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

#pragma mark - 钱包资源

- (void)fetchWalletAccountInfo:(void (^)(TCWalletAccount *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCWalletAccount *walletAccount = [[TCWalletAccount alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(walletAccount, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchWalletBillWrapper:(NSString *)tradingType count:(NSUInteger)count sortSkip:(NSString *)sortSkip result:(void (^)(TCWalletBillWrapper *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *tradingTypePart = tradingType ? [NSString stringWithFormat:@"tradingType=%@&", tradingType] : @"";
        NSString *limitSizePart = [NSString stringWithFormat:@"limitSize=%zd", count];
        NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bills?%@%@%@", self.currentUserSession.assigned, tradingTypePart, limitSizePart, sortSkipPart];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCWalletBillWrapper *walletBillWrapper = [[TCWalletBillWrapper alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(walletBillWrapper, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeWalletPassword:(NSString *)messageCode anOldPassword:(NSString *)anOldPassword aNewPassword:(NSString *)aNewPassword result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName;
        if (messageCode) {
            apiName = [NSString stringWithFormat:@"wallets/%@/password?vcode=%@", self.currentUserSession.assigned, messageCode];
        } else {
            apiName = [NSString stringWithFormat:@"wallets/%@/password", self.currentUserSession.assigned];
        }
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:anOldPassword forParam:@"oldPassword"];
        [request setValue:aNewPassword forParam:@"newPassword"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchBankCardList:(void (^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                NSMutableArray *bankCardList = [NSMutableArray array];
                NSArray *dics = response.data;
                for (NSDictionary *dic in dics) {
                    TCBankCard *bankCard = [[TCBankCard alloc] initWithObjectDictionary:dic];
                    [bankCardList addObject:bankCard];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock([bankCardList copy], nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)addBankCard:(TCBankCard *)bankCard withVerificationCode:(NSString *)verificationCode result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards?vcode=%@", self.currentUserSession.assigned, verificationCode];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [bankCard toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 201) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)deleteBankCard:(NSString *)bankCardID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards/%@", self.currentUserSession.assigned, bankCardID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 204) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

@end
