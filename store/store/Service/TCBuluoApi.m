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
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
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
            
            TC_CALL_ASYNC_MQ({
                [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserDidLogin object:nil];
            });
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
    NSString *apiName = [NSString stringWithFormat:@"store_set_meals?%@%@%@%@", categoryPart, limitSizePart, sortSkipPart, sortPart];
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
        NSString *apiName = [NSString stringWithFormat:@"stores/%@/propNames", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [storeDetailInfo toObjectDictionary];
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

- (void)putStoreAuthenticationInfo:(TCAuthenticationInfo *)info result:(void (^)(TCStoreInfo *storeInfo, NSError *error))resultBlock {
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
                    
                    TCStoreInfo *uploadInfo = [[TCStoreInfo alloc] initWithObjectDictionary:response.data];
                    
                    TC_CALL_ASYNC_MQ(resultBlock(uploadInfo, nil));
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

- (void)fetchGoodsWrapper:(BOOL)isPublished limitSize:(NSUInteger)limitSize sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsWrapper *, NSError *))resultBlock {
    
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
            TCGoodsWrapper *goodsWrapper = [[TCGoodsWrapper alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodsWrapper, nil));
            }
        }
    }];
}

- (void)fetchGoodsStandardWarpper:(NSUInteger)limitSize sort:(NSString *)sort sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsStandardWrapper *goodsStandardWrapper, NSError *error))resultBlock {
    NSString *limitSizePart = [NSString stringWithFormat:@"&limitSize=%zd", limitSize];
    NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
    NSString *sor = sort ? [NSString stringWithFormat:@"&sort=%@",sort] : @"";
    NSString *apiName = [NSString stringWithFormat:@"goods_standards?me=%@%@%@%@",[[TCBuluoApi api] currentUserSession].storeInfo.ID, limitSizePart, sortSkipPart,sor];
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

@end
