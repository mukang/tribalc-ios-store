//
//  TCInfoEditViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCInfoEditViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UITextField *textField;
@property (copy, nonatomic) NSString *placeholder;

@end
