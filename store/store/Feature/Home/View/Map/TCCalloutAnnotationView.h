//
//  TCCalloutAnnotationView.h
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TCAnnotation.h"

@interface TCCalloutAnnotationView : MKAnnotationView

@property (nonatomic, strong) TCAnnotation *mAnnotation;

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;

@property (nonatomic, retain) UIButton *imgBtn;

@end
