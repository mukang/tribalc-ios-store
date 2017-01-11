//
//  TCCalloutAnnotationView.m
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCalloutAnnotationView.h"

@implementation TCCalloutAnnotationView {

    UILabel *titleLab;
}

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

    titleLab = [[UILabel alloc] init];
    

    [self addSubview:titleLab];
}

- (void)setAnnotation:(TCAnnotation *)annotation {
    [super setAnnotation:annotation];

    titleLab.text = annotation.name;
    titleLab.font = [UIFont systemFontOfSize:13];
    [titleLab sizeToFit];
    [titleLab setOrigin:CGPointMake(22, 4)];
    
    
}

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView {
    static NSString *calloutKey = @"calloutKey";
    TCCalloutAnnotationView *calloutView = (TCCalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:calloutKey];
    if (!calloutView) {
        calloutView = [[TCCalloutAnnotationView alloc] init];
    }
    
    return calloutView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
