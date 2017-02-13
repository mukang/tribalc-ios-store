//
//  TCGoodsDetailTitleCell.h
//  store
//
//  Created by 王帅锋 on 17/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <YYText.h>

@protocol TCGoodsDetailTitleCellDelegate <NSObject>

- (void)textViewShouldBeginEditting:(UITextView *)textView;

- (void)textViewDidEndEditting:(UITextView *)textView;

- (void)textViewShouldReturnn;

@end

@interface TCGoodsDetailTitleCell : UITableViewCell

@property (weak, nonatomic) id<TCGoodsDetailTitleCellDelegate> delegate;

- (void)setTitle:(NSString *)str;

@end
