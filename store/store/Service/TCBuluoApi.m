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

@end
