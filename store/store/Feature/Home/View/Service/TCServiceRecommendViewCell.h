//
//  TCServiceRecommendViewCell.h
//  individual
//
//  Created by 穆康 on 2017/2/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCServiceDetail;

typedef NS_ENUM(NSInteger, TCServiceRecommendViewCellType) {
    TCServiceRecommendViewCellTypeReason,
    TCServiceRecommendViewCellTypeTopics
};

@interface TCServiceRecommendViewCell : UITableViewCell

@property (nonatomic) TCServiceRecommendViewCellType type;
@property (copy, nonatomic) NSString *content;

@end
