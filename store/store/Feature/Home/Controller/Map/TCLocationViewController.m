//
//  TCLocationViewController.m
//  individual
//
//  Created by WYH on 16/11/13.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLocationViewController.h"

@interface TCLocationViewController () {
    TCUserLocationAnnotation *userAnnotation;
    
    NSArray *allShopArr;
}

@end

@implementation TCLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    

    
    userAnnotation = [[TCUserLocationAnnotation alloc] init];
    userAnnotation.userImage = [UIImage imageNamed:@"map_test"];

    [self initLocation];
    
    [self initMap];
    
    [self addAnnotation];
    
}

- (void)initLocation {
    
    mLocationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [mLocationManager requestWhenInUseAuthorization];
    }
    
    mLocationManager.delegate = self;
    
    mLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 5.0;
    mLocationManager.distanceFilter = distance;
    [mLocationManager startUpdatingLocation];
}

- (void)initMap {
    
    mMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mMapView.delegate = self;
    [self.view addSubview:mMapView];
    
    UITapGestureRecognizer *pressMapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMap:)];
    [mMapView addGestureRecognizer:pressMapRecognizer];
    
    mMapView.userTrackingMode = MKUserTrackingModeNone;
    mMapView.mapType = MKMapTypeStandard;
    
    [mMapView addAnnotation:userAnnotation];

}

- (void)touchMap:(UITapGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint touchPoint = [gestureRecognizer locationInView:mMapView];
    CLLocationCoordinate2D touchMapCoordinate = [mMapView convertPoint:touchPoint toCoordinateFromView:mMapView];
    

    
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(37.785834, -122.405417);
    
    for (int i = 0; i < allShopArr.count; i++) {
//        CLLocationCoordinate2D annotationCoordinate = allShopArr[i][@"coordinate"];
        CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(location1.latitude - 0.001 * i, location1.longitude - 0.001 * i);
        CGPoint annotationPoint = [mMapView convertCoordinate:annotationCoordinate toPointToView:mMapView];

        
        if (annotationPoint.x - 15.5 < touchPoint.x && touchPoint.x < annotationPoint.x + 15.5 && touchPoint.y > annotationPoint.y - 15.5 && touchPoint.y < annotationPoint.y + 15.5 ) {
            return;
        }
            
    }
    
    userAnnotation.coordinate = touchMapCoordinate;
}

- (void)initData {
    
    NSDictionary *dic1 = @{ @"name":@"麻辣烫", @"title":@"最好吃的麻辣烫", @"address":@"刘朝雪东路29号" };
    NSDictionary *dic2 = @{ @"name":@"刘朝雪", @"title":@"最好吃的刘朝雪", @"address":@"刘朝雪西路29号" };
    NSDictionary *dic3 = @{ @"name":@"超雪", @"title":@"单位的额外", @"address":@"刘朝雪东路29号" };
    NSDictionary *dic4 = @{ @"name":@"孟元", @"title":@"最好吃的孟元", @"address":@"刘孟元雪东路29号" };
    NSDictionary *dic5 = @{ @"name":@"梦园", @"title":@"最好梦园的麻辣烫", @"address":@"刘东路29号" };
    NSDictionary *dic6 = @{ @"name":@"麻辣烫", @"title":@"最好吃的麻辣烫", @"address":@"刘朝雪东路29号" };

    allShopArr = @[
                   dic1, dic2, dic3, dic4, dic5, dic6
                   ];
    
}

- (UIImageView *)createUserImageViewWithImageName:(NSString *)imgName {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    UIImageView *headImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    
    headImgView.frame = CGRectMake(3, 3, imageView.width - 6, imageView.width - 6);
    headImgView.layer.cornerRadius = headImgView.width / 2;
    headImgView.layer.masksToBounds = YES;
    
    [imageView addSubview:headImgView];
    return imageView;
}


- (void)addAnnotation {
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(37.785834, -122.405417);
    
    for (int i = 0; i < allShopArr.count; i++) {
        TCAnnotation *annotation = [[TCAnnotation alloc] init];
        annotation.image = [UIImage imageNamed:@"map_food"];
        annotation.name = allShopArr[i][@"name"];
        annotation.coordinate = CLLocationCoordinate2DMake(location1.latitude - 0.001 * i, location1.longitude - 0.001 * i);
        annotation.title = allShopArr[i][@"title"];
        annotation.address = allShopArr[i][@"address"];
        [mMapView addAnnotation:annotation];
    }
    
}


#pragma mark - delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    userAnnotation.coordinate = [locations firstObject].coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(userAnnotation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [mMapView setRegion:region];
}



-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    if ([annotation isKindOfClass:[TCAnnotation class]]) {
        TCCalloutAnnotationView *calloutAnnotationView = [TCCalloutAnnotationView calloutViewWithMapView:mapView];
        calloutAnnotationView.image = ((TCAnnotation *)annotation).image;
        [calloutAnnotationView setAnnotation:annotation];
        return calloutAnnotationView;
    } else if([annotation isKindOfClass:[TCUserLocationAnnotation class]]) {
        TCUserLocationAnnotationView *userLocationView = [TCUserLocationAnnotationView calloutViewWithMapView:mapView];
        [userLocationView setAnnotation:annotation];
        return userLocationView;
        
    } else if ([annotation isKindOfClass:[TCDetailAnnotation class]]) {
        TCDetailAnnotationView *detailView = [TCDetailAnnotationView calloutViewWithMapView:mapView];
        [detailView setAnnotation:annotation];
        return detailView;
    }
    else {
        return nil;
    }
    
}


- (MKAnnotationView *)createMKAnnotationViewWithAnnotationView:(MKAnnotationView *)annotationView AndMKMapView:(MKMapView *)mapView AndAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[TCAnnotation class]]) {
        annotationView.image = ((TCAnnotation *)annotation).image;
        [annotationView setAnnotation:annotation];
        return annotationView;
    } else {
        [annotationView setAnnotation:annotation];
        return annotationView;
    }
    
    
}

#pragma mark 选中大头针时触发
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[TCAnnotation class]]) {
        [self removeCustomAnnotation];
        
        TCAnnotation *selectAnnotation = view.annotation;
        TCDetailAnnotation *annotation = [[TCDetailAnnotation alloc] init];
        annotation.coordinate = selectAnnotation.coordinate;
        annotation.mainTitle = selectAnnotation.title;
        annotation.detailText = selectAnnotation.address;
        [mMapView addAnnotation:annotation];
    }

}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCustomAnnotation];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    [mMapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[TCDetailAnnotation class]]) {
            [mMapView removeAnnotation:obj];
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
