//
//  TCGoodShopView.h
//  individual
//
//  Created by WYH on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCaChe.h"
#import "TCModelImport.h"

@interface TCGoodShopView : UIView <SDWebImageManagerDelegate>

- (instancetype)initWithFrame:(CGRect)frame AndShopDetail:(TCGoodDetail *)shopDetail;

@end
