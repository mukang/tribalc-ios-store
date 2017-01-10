//
//  TCUploadInfo.h
//  individual
//
//  Created by 穆康 on 2016/11/25.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCUploadInfo : NSObject

/** 对象名字 */
@property (copy, nonatomic) NSString *objectKey;
/** 上传路径 */
@property (copy, nonatomic) NSString *url;

@end
