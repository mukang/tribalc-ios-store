//
//  TCResaurantInfoViewController.m
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantInfoViewController.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"

@interface TCRestaurantInfoViewController () {
    UIImageView *serviceTitleImageView;
    TCRestaurantLogoView *logoView;
    UIImageView *navBarBackImageView;
    UIView *serviceInfoView;
    
    TCServiceDetail *serviceDetail;
    NSString *mServiceId;
    BOOL isCollection;
    BOOL isStatusBarBlack;
}

@end

@implementation TCRestaurantInfoViewController


- (instancetype)initWithServiceId:(NSString *)serviceId {
    self = [super init];
    if (self) {
        mServiceId = serviceId;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isStatusBarBlack = NO;
    mScrollView.delegate = self;
    
    [self setupNavigationBar];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    
    [self loadServiceDetail];
    
    isCollection = NO;
    
}

#pragma mark - Navigation Bar
- (void)setupNavigationBarWithLeftImgName:(NSString *)leftName AndRightImgName:(NSString *)rightName {
    UIButton *leftBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 0, 30, 17) AndImageName:leftName];
    [leftBtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIButton *rightBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(20, 0, 20, 17) AndImageName:rightName];
    [rightBtn addTarget:self action:@selector(touchCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    navBarBackImageView = self.navigationController.navigationBar.subviews.firstObject;
    navBarBackImageView.backgroundColor = [UIColor whiteColor];
    navBarBackImageView.alpha = 0;
    [self setupNavigationBarWithLeftImgName:@"back" AndRightImgName:[self getCollectionImageName]];
}


#pragma mark - Get Data
- (void)loadServiceDetail {
    __weak TCRestaurantInfoViewController *weakSelf = self;
    TCBuluoApi *api = [TCBuluoApi api];
    [MBProgressHUD showHUD:YES];
    [api fetchServiceDetail:mServiceId result:^(TCServiceDetail *service, NSError *error) {
        if (service) {
            [MBProgressHUD hideHUD:YES];
            serviceDetail = service;
            [weakSelf createWholeView];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取服务详情失败, %@", reason]];
        }
    }];
}



#pragma mark - UI
- (void)createWholeScrollView {
    mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TCScreenWidth, self.view.frame.size.height)];
    [self.view addSubview:mScrollView];
    mScrollView.backgroundColor = [UIColor whiteColor];
    mScrollView.delegate = self;
}



- (void)createWholeView {
    
    [self createWholeScrollView];
    
    [self createTitleImageView];
    
//    [self createBottomButton];
    
    [self createServiceInfoView];
    
    mScrollView.contentSize = CGSizeMake(self.view.width, serviceInfoView.y + serviceInfoView.height);
    
    [mScrollView bringSubviewToFront:serviceTitleImageView];
}


- (void)createTitleImageView {
    serviceTitleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TCRealValue(270))];
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:serviceDetail.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:serviceTitleImageView.size];
    [serviceTitleImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    serviceTitleImageView.clipsToBounds = NO;
    
    float logoViewRadius = serviceTitleImageView.height * 0.12;
    logoView = [[TCRestaurantLogoView alloc] initWithFrame:CGRectMake(serviceTitleImageView.width / 2 - logoViewRadius, serviceTitleImageView.height - logoViewRadius, logoViewRadius * 2, logoViewRadius * 2) AndUrl:[TCImageURLSynthesizer synthesizeImageURLWithPath:serviceDetail.detailStore.logo]];
    
    [mScrollView addSubview:serviceTitleImageView];
    [serviceTitleImageView addSubview:logoView];
}

- (void)createBottomButton {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - TCRealValue(45), self.view.frame.size.width, TCRealValue(45))];
    UIColor *backColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    UIButton *orderBtn = [self createBottomBtnWithFrame:CGRectMake(0, 0, bottomView.width / 2, bottomView.height) AndText:@"优惠买单" AndImgName:@"res_discount" AndBackColor: [UIColor colorWithRed:112/255.0 green:206/255.0 blue:213/255.0 alpha:1]];
    [orderBtn addTarget:self action:@selector(touchPreferentialPay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reserveBtn = [self createBottomBtnWithFrame:CGRectMake(bottomView.width / 2, 0, bottomView.width / 2, bottomView.height) AndText:@"预订餐位" AndImgName:@"res_ordering" AndBackColor:backColor];
    [reserveBtn addTarget:self action:@selector(touchReserveRest) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:reserveBtn];
    [bottomView addSubview:orderBtn];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    [bottomView addSubview:lineView];
    
    [self.view addSubview:bottomView];
    
}

- (UIButton *)createBottomBtnWithFrame:(CGRect)frame AndText:(NSString *)text AndImgName:(NSString *)imgName AndBackColor:(UIColor *)backColor{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [imgView sizeToFit];
    [imgView setOrigin:CGPointMake(TCRealValue(53), frame.size.height / 2 - imgView.height / 2 + 1)];
    [button addSubview:imgView];
    
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:TCRealValue(17)];
    label.textColor = [UIColor whiteColor];
    [button addSubview:label];
    
    imgView.x = frame.size.width / 2 - (imgView.width + label.width) / 2;
    label.x = imgView.x + imgView.width;
    label.origin = CGPointMake(imgView.x + imgView.width, frame.size.height / 2 - label.height / 2);
    button.backgroundColor = backColor;
    
    return button;
}

- (void)createServiceInfoView {
    serviceInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceTitleImageView.y + serviceTitleImageView.height + TCRealValue(35), TCScreenWidth, 0)];
    serviceInfoView.backgroundColor =  TCRGBColor(239, 239, 239);
    
    UIView *serviceBaseInfoView = [self getServiceBaseInfoViewWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(125))];
    [serviceInfoView addSubview:serviceBaseInfoView];
    
    UIView *ContactInfoView = [self getContactWayViewWithFrame:CGRectMake(0, serviceBaseInfoView.y + serviceBaseInfoView.height, self.view.width, TCRealValue(82))];
    [serviceInfoView addSubview:ContactInfoView];
    
    UIView *recommendedReasonView = [self getParagraphViewWithFrame:CGRectMake(0, ContactInfoView.y + ContactInfoView.height, self.view.width, TCRealValue(175)) AndTitle:@"推荐理由" AndText:serviceDetail.recommendedReason AndimgName:@"res_recommend"];
    [serviceInfoView addSubview:recommendedReasonView];
    
    UIView *restTopicView = [self getParagraphViewWithFrame:CGRectMake(0, recommendedReasonView.y + recommendedReasonView.height, self.view.width, TCRealValue(175)) AndTitle:@"餐厅话题" AndText:serviceDetail.topics AndimgName:@"res_topic"];
    [serviceInfoView addSubview:restTopicView];
    
    UIView *promptView = [self getKindlyReminderViewWithFrame:CGRectMake(0, restTopicView.y + restTopicView.height, self.view.frame.size.width, TCRealValue(145))];
    [serviceInfoView addSubview:promptView];
    
    UIButton *phoneBtn = [self getPhoneCustomButtonWithFrame:CGRectMake(0, promptView.y + promptView.height + TCRealValue(7), self.view.frame.size.width, TCRealValue(45))];
    [serviceInfoView addSubview:phoneBtn];
    
    serviceInfoView.height = phoneBtn.y + phoneBtn.height + TCRealValue(8);
    [mScrollView addSubview:serviceInfoView];
}


#pragma mark - Title Base Info
- (UIView *)getServiceBaseInfoViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [TCComponent createCenterLabWithFrame:CGRectMake(0, TCRealValue(22.5), frame.size.width, TCRealValue(22.5)) AndFontSize:TCRealValue(22.5) AndTitle:serviceDetail.name];
    [view addSubview:titleLab];
    
    UIView *storeBaseInfoView = [self createServiceStoreBaseInfoViewWithFrame:CGRectMake(0, titleLab.y + titleLab.height + TCRealValue(16), frame.size.width, TCRealValue(14))];
    [view addSubview:storeBaseInfoView];

    UIView *averagePriceView = [self createAveragePriceViewWithFrame:CGRectMake(0, storeBaseInfoView.y + storeBaseInfoView.height + TCRealValue(14), frame.size.width / 2 - TCRealValue(20), TCRealValue(15))];
    [view addSubview:averagePriceView];
    
    UIView *collectionView = [self getCollectionAlreadyViewWithFrame:CGRectMake(frame.size.width / 2, averagePriceView.y + TCRealValue(4), frame.size.width / 2, TCRealValue(11)) AndPhoneNumber:serviceDetail.collectionNum];
    [view addSubview:collectionView];
    
    return view;
}

- (UIView *)createServiceStoreBaseInfoViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *markPlaceLab = [TCComponent createLabelWithText:serviceDetail.detailStore.markPlace AndFontSize:TCRealValue(14)];
    [markPlaceLab setOrigin:CGPointMake(frame.size.width / 2 - markPlaceLab.width / 2, 0)];
    [view addSubview:markPlaceLab];
    
    UIView *leftLine = [TCComponent createGrayLineWithFrame:CGRectMake(markPlaceLab.x - TCRealValue(8) - TCRealValue(0.25), markPlaceLab.y, TCRealValue(0.5), markPlaceLab.height)];
    [view addSubview:leftLine];
    
    UIView *rightLine = [TCComponent createGrayLineWithFrame:CGRectMake(markPlaceLab.x + markPlaceLab.width + TCRealValue(8), markPlaceLab.y, TCRealValue(0.5), markPlaceLab.height)];
    [view addSubview:rightLine];
    
    UILabel *typeLab = [TCComponent createLabelWithFrame:CGRectMake(0, markPlaceLab.y, leftLine.x - TCRealValue(8), markPlaceLab.height) AndFontSize:TCRealValue(14) AndTitle:serviceDetail.detailStore.brand];
    typeLab.textAlignment = NSTextAlignmentRight;
    [view addSubview:typeLab];
    
    UILabel *rangeLab = [TCComponent createLabelWithFrame:CGRectMake(rightLine.x + TCRealValue(0.5) + TCRealValue(8), markPlaceLab.y, TCScreenWidth - rightLine.x + TCRealValue(0.5) + TCRealValue(8), markPlaceLab.height) AndFontSize:TCRealValue(14) AndTitle:@"2222m"];
    rangeLab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:rangeLab];
    
    return view;
}


- (UIView *)createAveragePriceViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *tagLab = [TCComponent createLabelWithFrame:CGRectMake(frame.size.width - TCRealValue(28), frame.size.height - TCRealValue(11), TCRealValue(28), TCRealValue(12)) AndFontSize:TCRealValue(11) AndTitle:@"元/人" AndTextColor:TCRGBColor(154, 154, 154)];
    [view addSubview:tagLab];

    NSString *priceStr = [NSString stringWithFormat:@"%f", serviceDetail.personExpense];
    priceStr = [NSString stringWithFormat:@"%@", @(priceStr.floatValue)];
    UILabel *priceLabel = [TCComponent createLabelWithFrame:CGRectMake(0, 0, view.width - TCRealValue(28), frame.size.height) AndFontSize:frame.size.height AndTitle:priceStr AndTextColor:[UIColor blackColor]];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:priceLabel];
    
    return view;
}

- (UIView *)getCollectionAlreadyViewWithFrame:(CGRect)frame AndPhoneNumber:(NSInteger)phoneNumber{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImage *collectionImg = [UIImage imageNamed:@"res_collection_gray"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TCRealValue(1), TCRealValue(11), TCRealValue(9))];
    imgView.image = collectionImg;
    [view addSubview:imgView];
    
    NSString *numberStr = [NSString stringWithFormat:@"%li", (long)phoneNumber];
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(imgView.x + imgView.width + TCRealValue(1), 0, frame.size.width - imgView.x - imgView.width, frame.size.height) AndFontSize:frame.size.height AndTitle:[NSString stringWithFormat:@"%@已收藏", numberStr] AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [view addSubview:label];
    
    return view;
}

#pragma mark - Address And Phone
- (UIView *)getContactWayViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UIView *topLine = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(40), TCRealValue(0.5))];
    UIView *downLine = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), frame.size.height - TCRealValue(0.5), topLine.width, TCRealValue(0.5))];
    [view addSubview:topLine];
    [view addSubview:downLine];
    
    UIView *addressView = [self getContactViewWithFrame:CGRectMake(0, TCRealValue(19), TCScreenWidth, TCRealValue(14)) LogoName:@"res_phone" Text:serviceDetail.detailStore.address AndAction:@selector(touchPhoneBtn)];
    [view addSubview:addressView];
    UIView *phoneView = [self getContactViewWithFrame:CGRectMake(0, view.height - TCRealValue(19) - TCRealValue(14), TCScreenWidth, addressView.height) LogoName:@"res_location2" Text:serviceDetail.detailStore.phone AndAction:@selector(touchLocationBtn)];
    [view addSubview:phoneView];
    
    return view;
}

- (UIView *)getContactViewWithFrame:(CGRect)frame LogoName:(NSString *)logoName Text:(NSString *)text AndAction:(SEL)action{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(20) - TCRealValue(16), TCRealValue(14)) AndFontSize:TCRealValue(14) AndTitle:text];
    UIButton *logoBtn = [TCComponent createImageBtnWithFrame:CGRectMake(frame.size.width - TCRealValue(20) - TCRealValue(15), 0, TCRealValue(15), TCRealValue(15)) AndImageName:logoName];
    [logoBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:label];
    [view addSubview:logoBtn];
    return view;
}

#pragma mark - Recommend Boutique And Topic
- (UIView *)getParagraphViewWithFrame:(CGRect)frame AndTitle:(NSString *)title AndText:(NSString *)text AndimgName:(NSString *)imgName{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];

    UIView *titleView = [self getParagraphTitleViewWithFrame:CGRectMake(0, TCRealValue(22.5), frame.size.width, TCRealValue(23)) AndImgName:imgName AndTitle:title];
    
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(TCRealValue(62), titleView.y + titleView.height + TCRealValue(8), view.width - TCRealValue(62) * 2, view.height - TCRealValue(96) + TCRealValue(15))];
    textLab.numberOfLines = TCRealValue(4);
    textLab.font = [UIFont systemFontOfSize:TCRealValue(14)];
    textLab.attributedText = [self getAttributedStringWithText:text];
   
    UIView *line = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), view.size.height - TCRealValue(0.5), view.width - TCRealValue(20), TCRealValue(0.5))];
    if (text.length > TCRealValue(80)) {
        UIButton *moreInfoBtn = [self getMoreInfoButtonWithFrame:CGRectMake(0, frame.size.height - TCRealValue(10) - TCRealValue(12), frame.size.width, TCRealValue(12)) AndTitle:title];
        [view addSubview:moreInfoBtn];
    }
    
    [view addSubview:titleView];
    [view addSubview:textLab];
    [view addSubview:line];
    
    return view;
}

- (UIView *)getParagraphTitleViewWithFrame:(CGRect)frame AndImgName:(NSString *)imgName AndTitle:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imgName];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    UILabel *titleLab = [TCComponent createLabelWithText:title AndFontSize:TCRealValue(22)];
    [imgView setOrigin:CGPointMake(view.width / 2 - (titleLab.width + image.size.width) / 2, TCRealValue(4))];
    [titleLab setOrigin:CGPointMake(imgView.x + imgView.width + TCRealValue(2), 0)];
    
    [view addSubview:imgView];
    [view addSubview:titleLab];
    
    return view;
}

- (UIButton *)getMoreInfoButtonWithFrame:(CGRect)frame AndTitle:(NSString *)title{
    UIButton *moreInfoButton = [[UIButton alloc] initWithFrame:frame];
    [moreInfoButton setTitle:@"更多详情>" forState:UIControlStateNormal];
    [moreInfoButton setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
    moreInfoButton.titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
    if ([title isEqualToString:@"推荐理由"]) {
        [moreInfoButton addTarget:self action:@selector(touchMoreRecommendInfo) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [moreInfoButton addTarget:self action:@selector(touchMoreTopicInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return moreInfoButton;
}

- (NSMutableAttributedString *)getAttributedStringWithText:(NSString *)text {
    text = text ? text : @"" ;
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = TCRealValue(5);
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    return attrText;
}

#pragma mark - Kindly Reminder
- (UIView *)getKindlyReminderViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [self getParagraphTitleViewWithFrame:CGRectMake(0, TCRealValue(21), self.view.frame.size.width, TCRealValue(23)) AndImgName:@"res_prompt" AndTitle:@"温馨提示"];
    [view addSubview:titleView];
    
    UIView *storeTagsView = [self getStoreTagsView];
    [storeTagsView setOrigin:CGPointMake(self.view.frame.size.width / 2 - storeTagsView.width / 2, titleView.y + titleView.height + TCRealValue(13))];
    [view addSubview:storeTagsView];
    serviceDetail.detailStore.businessHours = serviceDetail.detailStore.businessHours == nil ? @"0:00" :serviceDetail.detailStore.businessHours;
    NSString *time = [NSString stringWithFormat:@"每天 %@",serviceDetail.detailStore.businessHours];
    UILabel *timeLab = [TCComponent createLabelWithFrame:CGRectMake(0, storeTagsView.y + storeTagsView.height + TCRealValue(12), self.view.frame.size.width, TCRealValue(13)) AndFontSize:TCRealValue(13) AndTitle:time AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:timeLab];
    
    return view;
}

- (UIView *)getStoreTagsView {
    UIView *view = [[UIView alloc] init];
    NSArray *tagArr = [self getStoreTagLogoTitleArr:serviceDetail.detailStore.faclities];
    NSArray *tagLogoArr = serviceDetail.detailStore.faclities;
    CGFloat width = TCRealValue(37);
    for (int i = 0; i < tagLogoArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * TCRealValue(24) + width, 0, TCRealValue(24), TCRealValue(24))];
        if (i == 0) {
            [imgView setX:0];
        }
        imgView.image = [UIImage imageNamed:tagLogoArr[i]];
        UILabel *titleLab = [self getStoreTagsTitleLabelWithImgFrame:imgView.frame AndTitle:tagArr[i]];
        width = titleLab.width > 70 ?  TCRealValue(50): TCRealValue(37);
        [view addSubview:imgView];
        [view addSubview:titleLab];
    }
    [view setSize:CGSizeMake(TCRealValue(24) * tagArr.count + (tagArr.count - 1) * width, TCRealValue(24 + 5 + 13))];
    return view;
}

- (NSMutableArray *)getStoreTagLogoTitleArr:(NSArray *)faclities {
    NSMutableArray *facArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < faclities.count; i++) {
        NSString *facStr = [self getStoreTagLogoTitleStr:faclities[i]];
        [facArr addObject:facStr];
    }
    
    return facArr;
}

- (NSString *)getStoreTagLogoTitleStr:(NSString *)faclities {
    if ([faclities isEqualToString:@"room"]) {
        return @"包间";
    } else if([faclities isEqualToString:@"facilities_for_disabled"]) {
        return @"残疾人设施";
    } else if([faclities isEqualToString:@"valet_parking"]) {
        return @"代客泊车";
    } else if([faclities isEqualToString:@"subway"]) {
        return @"地铁";
    } else if([faclities isEqualToString:@"vip_rights"]) {
        return @"会员权限";
    } else if([faclities isEqualToString:@"restaurants_of_hotel"]) {
        return @"酒店内有餐厅";
    } else if([faclities isEqualToString:@"pet_ok"]) {
        return @"可带宠物";
    } else if([faclities isEqualToString:@"business_circle"]) {
        return @"商圈";
    } else if([faclities isEqualToString:@"business_dinner"]) {
        return @"商务宴请";
    } else if([faclities isEqualToString:@"small_party"]) {
        return @"适合小聚";
    } else if([faclities isEqualToString:@"parking"]) {
        return @"停车";
    } else if([faclities isEqualToString:@"scene_seat"]) {
        return @"有观景位";
    } else if([faclities isEqualToString:@"organic_food"]) {
        return @"有机食物";
    } else if([faclities isEqualToString:@"bar"]) {
        return @"有酒吧";
    } else if([faclities isEqualToString:@"baby_chair"]) {
        return @"有婴儿椅";
    } else if([faclities isEqualToString:@"weekend_brunch"]) {
        return @"周末早午餐";
    } else {
        return faclities;
    }
}



- (UILabel *)getStoreTagsTitleLabelWithImgFrame:(CGRect)imgFrame AndTitle:(NSString *)title{
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:TCRealValue(13)];
    titleLab.textColor = TCRGBColor(154, 154, 154);
    [titleLab sizeToFit];
    [titleLab setOrigin:CGPointMake(imgFrame.origin.x + imgFrame.size.width / 2 - titleLab.width / 2, imgFrame.origin.y + imgFrame.size.height + TCRealValue(5))];
    return titleLab;
}

#pragma mark - Customer Phone
- (UIButton *)getPhoneCustomButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"res_phone-1"]];
    [phoneImgView setFrame:CGRectMake(0, (frame.size.height - TCRealValue(18)) / 2 + 1 , TCRealValue(18), TCRealValue(18))];
    
    UILabel *phoneLab = [TCComponent createLabelWithText:@"电话客服" AndFontSize:TCRealValue(14)];
    phoneLab.textColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"res_phone_mark"]];
    [arrowImgView setFrame:CGRectMake(0, frame.size.height / 2 - TCRealValue(7) + TCRealValue(1.7), TCRealValue(10), TCRealValue(14))];
    [phoneImgView setX:frame.size.width / 2 - (phoneImgView.width + phoneLab.width + arrowImgView.width + TCRealValue(6)) / 2];
    [phoneLab setOrigin:CGPointMake(phoneImgView.x + phoneImgView.width + TCRealValue(3), frame.size.height / 2 - TCRealValue(7))];
    [arrowImgView setX:phoneLab.x + phoneLab.width + TCRealValue(3)];
    [button addTarget:self action:@selector(touchCallCustomerService) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:phoneImgView];
    [button addSubview:phoneLab];
    [button addSubview:arrowImgView];
    

    return button;
}


#pragma mark - Touch Action
- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchCollectionBtn:(UIButton *)button {
    if (mScrollView.contentOffset.y < 70) {
        isCollection = !isCollection;
        UIButton *rightBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(20, 10, 20, 17) AndImageName:[self getCollectionImageName]];
        [rightBtn addTarget:self action:@selector(touchCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
}

//- (void)touchReserveRest {
//    NSString *storeSetMealId = serviceDetail.ID;
//    TCReserveOnlineViewController *reserveOnlineViewController = [[TCReserveOnlineViewController alloc] initWithStoreSetMealId:storeSetMealId];
//    [self.navigationController pushViewController:reserveOnlineViewController animated:YES];
//}

//- (void)touchPreferentialPay
//{
//    NSLog(@"点击优惠买单");
//}

-(void)touchPhoneBtn {
    TCDetailStore *detailStore = serviceDetail.detailStore;
    UIWebView *callView = [TCComponent callWithPhone:detailStore.phone];
    [self.view addSubview:callView];
}

- (void)touchCallCustomerService {
    NSLog(@"点击电话客服");
        UIWebView *callView = [TCComponent callWithPhone:@"15733108692"];
        [self.view addSubview:callView];
    
}

- (void)touchLocationBtn {
    
    TCLocationViewController *locationViewController = [[TCLocationViewController alloc] init];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (void)touchMoreRecommendInfo {
    NSLog(@"点击推荐理由更多详情");
}

- (void)touchMoreTopicInfo {
    NSLog(@"点击餐厅话题更多详情");
}

- (NSString *)getCollectionImageName {
    if (isCollection == YES) {
        return @"res_collection";
    } else {
        return @"res_collection_not";
    }
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = TCRealValue(270);
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    navBarBackImageView.alpha = alpha;
    

    CGPoint point = scrollView.contentOffset;
    
    if (point.y > 70) {
        [self setupNavigationBarWithLeftImgName:@"back_black" AndRightImgName:@"res_collection_black"];
        isStatusBarBlack = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [self setupNavigationBarWithLeftImgName:@"back" AndRightImgName:[self getCollectionImageName]];
        isStatusBarBlack = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if (point.y < 0) {
        double height = -point.y + TCRealValue(270);
        double number = height / TCRealValue(270);
        double width = self.view.frame.size.width * number;
        double logoRadius = height * 0.12;
        double addHeight = logoRadius * 2 - logoView.height;
    
        [serviceTitleImageView setFrame:CGRectMake(self.view.frame.size.width / 2 - width / 2, point.y, width, height)];
        [logoView setLogoFrame:CGRectMake(serviceTitleImageView.frame.size.width / 2 - logoRadius, serviceTitleImageView.frame.size.height - logoRadius, logoRadius * 2, logoRadius * 2)];
        serviceInfoView.y = serviceInfoView.y + addHeight;
        
    }
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    mScrollView.delegate = nil;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    navBarBackImageView.alpha = 1.0;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (isStatusBarBlack) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
