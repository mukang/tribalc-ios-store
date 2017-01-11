//
//  TCDetailAnnotationView.m
//  individual
//
//  Created by WYH on 16/11/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCDetailAnnotationView.h"
#import <MapKit/MapKit.h>

@implementation TCDetailAnnotationView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    
    return self;
}

- (void)layoutUI {
    
    
}

- (void)setAnnotation:(TCDetailAnnotation *)annotation {
    [super setAnnotation:annotation];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_background"]];
    [self addSubview:backImgView];
    [backImgView setOrigin:CGPointMake(-backImgView.width / 2, -backImgView.height - 12)];
    backImgView.alpha = 0.6;
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(backImgView.x + 1, backImgView.y + 16, backImgView.width - 2, 16) AndFontSize:16 AndTitle:annotation.mainTitle AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    [self addSubview:titleLab];
    
    UILabel *addressLab = [TCComponent createLabelWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + 4 , titleLab.width, 11) AndFontSize:11 AndTitle:annotation.detailText AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [self addSubview:addressLab];
    
    titleLab.textAlignment = NSTextAlignmentCenter;
    addressLab.textAlignment = NSTextAlignmentCenter;
    
    
}

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView {
    static NSString *calloutKey = @"calloutKey";
    TCDetailAnnotationView *calloutView = (TCDetailAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:calloutKey];
    if (!calloutView) {
        calloutView = [[TCDetailAnnotationView alloc] init];
    }
    
    return calloutView;
}



@end
