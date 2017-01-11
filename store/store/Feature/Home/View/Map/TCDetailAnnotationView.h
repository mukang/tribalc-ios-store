//
//  TCDetailAnnotationView.h
//  individual
//
//  Created by WYH on 16/11/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCDetailAnnotation.h"
#import "TCComponent.h"

@interface TCDetailAnnotationView : MKAnnotationView

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView ;

@end
