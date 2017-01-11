//
//  TCLocationViewController.h
//  individual
//
//  Created by WYH on 16/11/13.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TCAnnotation.h"
#import "TCCalloutAnnotationView.h"
#import "TCUserLocationAnnotation.h"
#import "TCUserLocationAnnotationView.h"
#import "TCDetailAnnotation.h"
#import "TCDetailAnnotationView.h"

@interface TCLocationViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *mMapView;
    CLLocationManager *mLocationManager;
    
}

@end
