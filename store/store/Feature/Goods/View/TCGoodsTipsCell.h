//
//  TCGoodsTipsCell.h
//  store
//
//  Created by 王帅锋 on 17/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCGoodsTipsCellDelegate <NSObject>

- (void)didSelectedLib:(NSArray *)arr;
- (void)textFieldShouldBeginEditting:(UITextField *)field;
- (void)textFieldDidEndEditting:(UITextField *)field;

@end

@interface TCGoodsTipsCell : UITableViewCell

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSArray *libsArr;

@property (weak, nonatomic) id<TCGoodsTipsCellDelegate> delegate;

- (CGFloat)cellHeight;

@end
