//
//  TCRecommendInfoViewController.m
//  individual
//
//  Created by WYH on 16/11/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendInfoViewController.h"
#import "UIImage+Category.h"

@interface TCRecommendInfoViewController () {
    TCGoodDetail *mGoodDetail;
    CGFloat titleViewHeight;
    TCGoodStandards *goodStandard;
    NSString *mGoodId;

    TCGoodSelectView *goodSelectView;
    UIScrollView *mScrollView;
    TCImgPageControl *imgPageControl;
    UICollectionView *imageCollectionView;
    TCGoodTitleView *goodTitleView;
    UIWebView *textAndImageView;
}

@end

@implementation TCRecommendInfoViewController {
    __weak TCRecommendInfoViewController *weakSelf;
}

- (instancetype)initWithGoodId:(NSString *)goodID {
    self = [super init];
    if (self) {
        mGoodId = goodID;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    if (mScrollView == nil) {
        [self createEntiretyScrollView];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weakSelf = self;

    [self loadGoodDetailInfoWithGoodId:mGoodId];
}


#pragma mark - GetData
- (void)loadGoodDetailInfoWithGoodId:(NSString *)goodId {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchGoodDetail:goodId result:^(TCGoodDetail *goodDetail, NSError *error) {
        if (goodDetail) {
            [MBProgressHUD hideHUD:YES];
            mGoodDetail = goodDetail;
            [weakSelf initMainView];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取商品信息失败, %@", reason]];
        }
    }];
}

- (void)reloadDetailViewWithTouchGoodDetail:(TCGoodDetail *)goodDetail {
    
    mGoodDetail = goodDetail;
    [imageCollectionView reloadData];
    //    [goodTitleView setupTitleWithText:goodDetail.title];
    titleViewHeight = goodTitleView.height;
    [goodTitleView setupTitleWithText:goodDetail.title];
    [goodTitleView setSalePriceWithPrice:goodDetail.salePrice];
    [goodTitleView setOriginPriceLabWithOriginPrice:goodDetail.originPrice];
    [goodTitleView setTagLabWithTagArr:goodDetail.tags];
    [self changeViewCoordinates];
    imgPageControl.numberOfPages = goodDetail.pictures.count;
    [self reloadWebViewWithUrlStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, goodDetail.detailURL]];
    
}

- (void)changeViewCoordinates {
    NSArray *views = mScrollView.subviews;
    CGFloat changeHeight = 0;
    for (int i = 0; i < views.count; i++) {
        UIView *view = views[i];
        if (changeHeight != 0) {
            view.y += changeHeight;
        }
        if ([views[i] isEqual:goodTitleView]) {
            changeHeight = goodTitleView.height - titleViewHeight;
        }
        
    }
}




#pragma mark - UI
- (void)createEntiretyScrollView {
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, self.view.height + 20)];
    mScrollView.contentSize = CGSizeMake(self.view.width, TCRealValue(1500));
    mScrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:mScrollView];
}

- (void)initMainView {

    UIView *titleImageView = [self createTitleImageViewWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(394))];
    [mScrollView addSubview:titleImageView];
    
    goodTitleView = [[TCGoodTitleView alloc] initWithFrame:CGRectMake(0, titleImageView.y + titleImageView.height, self.view.width, TCRealValue(87)) WithTitle:mGoodDetail.title AndPrice:mGoodDetail.salePrice AndOriginPrice:mGoodDetail.originPrice AndTags:mGoodDetail.tags];
    [mScrollView addSubview:goodTitleView];
    
    UIButton *standardSelectBtn = [self createStandardSelectButtonWithFrame:CGRectMake(0, goodTitleView.y + goodTitleView.height + TCRealValue(7.5), self.view.width, TCRealValue(38))];
    [mScrollView addSubview:standardSelectBtn];
    
    UIView *shopView = [[TCGoodShopView alloc] initWithFrame:CGRectMake(0, standardSelectBtn.y + standardSelectBtn.height + TCRealValue(7.5), self.view.width, TCRealValue(64)) AndShopDetail:mGoodDetail];
    [mScrollView addSubview:shopView];
    
    UISegmentedControl *selectGoodInfoSegment = [self createSelectGoodGraphicAndParameterView:CGRectMake(0, shopView.y + shopView.height, self.view.width, TCRealValue(39))];
    [mScrollView addSubview:selectGoodInfoSegment];
    
    textAndImageView = [self createURLInfoViewWithOrigin:CGPointMake(0, selectGoodInfoSegment.y + selectGoodInfoSegment.height) AndURLStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.detailURL]];
    [mScrollView addSubview:textAndImageView];

//    UIView *bottomView = [self createBottomViewWithFrame:CGRectMake(0, self.view.height - TCRealValue(49), self.view.width, TCRealValue(49))];
//    [self.view addSubview:bottomView];

    [self createSelectSizeView];
    
    [self createBackButton];

}



#pragma mark - Back Button
- (void)createBackButton {
    UIButton *backBtn = [self getBackButton];
    [backBtn addTarget:self action:@selector(touchBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (UIButton *)getBackButton {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(TCRealValue(13), TCRealValue(30), TCRealValue(27.5), TCRealValue(27.5))];
    backBtn.layer.cornerRadius = TCRealValue(27.5 / 2);
    backBtn.backgroundColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    [imgView sizeToFit];
    [imgView setFrame:CGRectMake(backBtn.width / 2 - imgView.width * 1.1 / 2 - 1.4, backBtn.height / 2 - imgView.height * 1.1 / 2, imgView.width * 1.1, imgView.height * 1.1)];
    [backBtn addSubview:imgView];

    return backBtn;
}


#pragma mark - Carousel ImageView
- (UIView *)createTitleImageViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    imageCollectionView = [self getTitleImageViewWithFrame:frame];
    imageCollectionView.bounces = NO;
    [view addSubview:imageCollectionView];
    
    NSArray *imgArr = mGoodDetail.pictures;
    imgPageControl = [[TCImgPageControl alloc] initWithFrame:CGRectMake(0, view.height - TCRealValue(20), self.view.width, TCRealValue(20))];
    imgPageControl.numberOfPages = imgArr.count;
    imgPageControl.userInteractionEnabled = NO;
    imgPageControl.currentPage = 0;
    [view addSubview:imgPageControl];
    
    return view;
}
- (UICollectionView *)getTitleImageViewWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(TCScreenWidth, frame.size.height);
    layout.minimumLineSpacing = 0.0f;
    
    UICollectionView *imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    imgCollectionView.delegate = self;
    imgCollectionView.dataSource = self;
    imgCollectionView.pagingEnabled = YES;
    imgCollectionView.showsHorizontalScrollIndicator = NO;
    imgCollectionView.showsVerticalScrollIndicator = NO;
    [imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    imgCollectionView.contentSize = CGSizeMake(mGoodDetail.pictures.count * frame.size.width, frame.size.height);
    
    return imgCollectionView;
}

#pragma mark - Standard Select
- (UIButton *)createStandardSelectButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    UILabel *selectLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(20), frame.size.height) AndFontSize:TCRealValue(15) AndTitle:@"请选择规格"];
    [button addSubview:selectLab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_select_standard"]];
    [imgView sizeToFit];
    [imgView setOrigin:CGPointMake(frame.size.width - TCRealValue(20) - imgView.width, frame.size.height / 2 - imgView.height / 2)];
    [button addSubview:imgView];
    
    [button addTarget:self action:@selector(touchSelectStandardBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)createSelectSizeView {
    goodSelectView = [[TCGoodSelectView alloc] initWithGoodDetail:mGoodDetail];
    goodSelectView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:goodSelectView];
    
}

#pragma mark - Bottom Button
- (UIView *)createBottomViewWithFrame:(CGRect)frame {
    UIView *view=  [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, frame.size.width, TCRealValue(0.5))];
    [view addSubview:lineView];
    
    UIButton *collectionView = [self createBottomLogoBtnWithFrame:CGRectMake(0, 0, frame.size.width / 4, frame.size.height) AndImageName:@"good_collection_gray" AndText:@"收藏" AndAction:@selector(touchCollectionBtn:)];
    [view addSubview:collectionView];
    UIButton *shopCarImgBtn = [self createBottomLogoBtnWithFrame:CGRectMake(collectionView.width, 0, frame.size.width / 4, frame.size.height) AndImageName:@"good_shoppingcar_gray" AndText:@"购物车" AndAction:@selector(touchShopCarBtn:)];
    [view addSubview:shopCarImgBtn];
    
    UIButton *shopCarBtn = [TCComponent createButtonWithFrame:CGRectMake(shopCarImgBtn. x + shopCarImgBtn.width, 0, frame.size.width / 2, frame.size.height) AndTitle:@"加入购物车" AndFontSize:TCRealValue(18)];
    [shopCarBtn addTarget:self action:@selector(touchAddShopCartBtnInDetailView:) forControlEvents:UIControlEventTouchUpInside];
    shopCarBtn.backgroundColor = TCRGBColor(81, 199, 209);
    [shopCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:shopCarBtn];
    
    return view;
}

- (UIButton *)createBottomLogoBtnWithFrame:(CGRect)frame AndImageName:(NSString *)imageName AndText:(NSString *)text AndAction:(SEL)action{
    UIButton *view = [[UIButton alloc] initWithFrame:frame];
    UIImage *img = [UIImage imageNamed:imageName];
    UIButton *button = [TCComponent createButtonWithFrame:CGRectMake((frame.size.width - img.size.width) / 2, TCRealValue(10), img.size.width, img.size.height) AndTitle:@"" AndFontSize:0];
    [button setImage:img forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    [view addSubview:button];
    
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(0, button.y + button.height + TCRealValue(3), frame.size.width, TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:text AndTextColor:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1]];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    [view addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    return view;
}


#pragma mark - SegmentControl
- (UISegmentedControl *)createSelectGoodGraphicAndParameterView:(CGRect)frame {
    
    UISegmentedControl *selectSegment = [self getSegmentControlWithFrame:frame];
    UIView *topLine = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, frame.size.width, TCRealValue(1))];
    UIView *downLine = [TCComponent createGrayLineWithFrame:CGRectMake(0, frame.size.height - TCRealValue(1), frame.size.width, TCRealValue(1))];
    [selectSegment addSubview:topLine];
    [selectSegment addSubview:downLine];
    
    UIView *centerLine = [TCComponent createGrayLineWithFrame:CGRectMake(frame.size.width / 2 - TCRealValue(0.25), frame.size.height / 2 - TCRealValue(13), TCRealValue(0.5), TCRealValue(26))];
    [selectSegment addSubview:centerLine];
    
    
    return selectSegment;
}

- (UISegmentedControl *)getSegmentControlWithFrame:(CGRect)frame {
    NSArray *segmentArr = @[ @"图文详情", @"产品参数" ];
    UISegmentedControl *selectSegment = [[UISegmentedControl alloc] initWithItems:segmentArr];
    [selectSegment setFrame:frame];
    selectSegment.tintColor = [UIColor clearColor];
    NSDictionary *normal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:TCRealValue(14)], NSFontAttributeName, nil];
    [selectSegment setTitleTextAttributes:normal forState:UIControlStateNormal];
    NSDictionary *select = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:TCRealValue(14)], NSFontAttributeName, nil];
    [selectSegment setTitleTextAttributes:normal forState:UIControlStateNormal];
    [selectSegment setTitleTextAttributes:select forState:UIControlStateSelected];
    selectSegment.selectedSegmentIndex = 0;
    [selectSegment addTarget:self action:@selector(touchSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    return selectSegment;
}


- (UIWebView *)createURLInfoViewWithOrigin:(CGPoint)point AndURLStr:(NSString *)urlStr{
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setOrigin:point];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [webView sizeToFit];
    UIScrollView *tempView = (UIScrollView *)[webView.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;

    return webView;
}

- (void)reloadWebViewWithUrlStr:(NSString *)urlStr {
    for (int i = 0; i < mScrollView.subviews.count; i++) {
        if ([mScrollView.subviews[i] isKindOfClass:[UISegmentedControl class]]) {
            UISegmentedControl *seg = mScrollView.subviews[i];
            textAndImageView = [self createURLInfoViewWithOrigin:CGPointMake(seg.x, seg.y + seg.height) AndURLStr:urlStr];
        }
    }
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height =  [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [webView setSize:CGSizeMake(self.view.frame.size.width, height)];
    mScrollView.contentSize = CGSizeMake(self.view.width, webView.y + webView.height);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *imageArr = mGoodDetail.pictures;
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.pictures[indexPath.row]]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, collectionView.width, collectionView.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:imageView.size];
    [imageView sd_setImageWithURL:imgUrl placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    imageView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:imageView];
    return cell;
}

#pragma mark - TCGoodSelectViewDelegate

- (void)selectView:(TCGoodSelectView *)goodSelectView didChangeStandardButtonWithGoodDetail:(TCGoodDetail *)goodDetail {
    [self reloadDetailViewWithTouchGoodDetail:goodDetail];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / self.view.width;
    imgPageControl.currentPage = index;
    
}

#pragma mark - Touch Action
- (void)touchBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchSegmentedControlAction: (UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    UIWebView *webView;
    if (index == 0) {
        webView = NULL;
        webView = [self createURLInfoViewWithOrigin:CGPointMake(0, seg.y + seg.height) AndURLStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.detailURL]];
    } else {
        webView = NULL;
        webView = [self createURLInfoViewWithOrigin:CGPointMake(0, seg.y + seg.height) AndURLStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.detailURL]];
    }
    UIScrollView *tempView = (UIScrollView *)[webView.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    [mScrollView addSubview:webView];


}


- (void)touchAddShopCartBtnInDetailView:(UIButton *) btn {
    if (mGoodDetail.standardId == nil) {
        [weakSelf showStandardView:nil];
        return ;
    }
    TCBuluoApi *api = [TCBuluoApi api];
    [MBProgressHUD showHUD:YES];
    [api fetchGoodStandards:mGoodDetail.standardId result:^(TCGoodStandards *result, NSError *error) {
        if (result) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf showStandardView:result];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取商品规格失败, %@", reason]];
        }
        
    }];
}


- (void)touchShopCarBtn:(id)sender {
    
}

- (void)touchSelectStandardBtn:(UIButton *)btn {
    if (mGoodDetail.standardId == nil) {
        [weakSelf showStandardView:nil];
        return ;
    }
    TCBuluoApi *api = [TCBuluoApi api];
    [MBProgressHUD showHUD:YES];
    [api fetchGoodStandards:mGoodDetail.standardId result:^(TCGoodStandards *result, NSError *error) {
        if (result) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf showStandardView:result];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取商品规格失败, %@", reason]];
        }
        
    }];
    
}

- (void)showStandardView:(TCGoodStandards *)result {
    goodStandard = result;
    
    if (!goodSelectView.goodStandard) {
        [goodSelectView setupGoodStandard:goodStandard];
        
    }
    [goodSelectView show];
}


- (void)touchCollectionBtn:(id)sender {
    
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
