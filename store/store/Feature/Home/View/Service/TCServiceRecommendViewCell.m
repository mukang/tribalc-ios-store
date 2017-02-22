//
//  TCServiceRecommendViewCell.m
//  individual
//
//  Created by 穆康 on 2017/2/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceRecommendViewCell.h"

@interface TCServiceRecommendViewCell ()

@property (weak, nonatomic) UIButton *titleButton;
@property (weak, nonatomic) UILabel *contentLabel;
@property (weak, nonatomic) UIView *lineView;

@end

@implementation TCServiceRecommendViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    titleButton.userInteractionEnabled = NO;
    [self.contentView addSubview:titleButton];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:lineView];
    
    self.titleButton = titleButton;
    self.contentLabel = contentLabel;
    self.lineView = lineView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(22.5);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.height.mas_equalTo(24.5);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(60);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.bottom.equalTo(weakSelf.contentView).offset(-27.5);
        
//        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(60, 20, -27.5, -20));
//        make.height.mas_lessThanOrEqualTo(16);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Public Methods

- (void)setType:(TCServiceRecommendViewCellType)type {
    _type = type;
    
    NSString *imageName, *titleStr;
    if (type == TCServiceRecommendViewCellTypeReason) {
        imageName = @"service_recommend_reason";
        titleStr = @"推荐理由";
    } else {
        imageName = @"service_recommend_topic";
        titleStr = @"推荐话题";
    }
    [self.titleButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.titleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:titleStr
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:22.5],
                                                                                      NSForegroundColorAttributeName: TCRGBColor(42, 42, 42)
                                                                                      }]
                                forState:UIControlStateNormal];
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 9;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName: TCRGBColor(42, 42, 42),
                                     NSParagraphStyleAttributeName: paragraphStyle
                                     };
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:content
                                                                       attributes:textAttributes];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
