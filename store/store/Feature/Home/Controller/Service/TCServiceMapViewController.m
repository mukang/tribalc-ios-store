//
//  TCServiceMapViewController.m
//  store
//
//  Created by 穆康 on 2017/2/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceMapViewController.h"
#import "TCServiceDetailViewController.h"

#import "TCService.h"

#import "TCServiceAnnotation.h"
#import "TCServiceAnnotationView.h"

#import <MAMapKit/MAMapKit.h>

@interface TCServiceMapViewController () <MAMapViewDelegate, TCServiceAnnotationViewDelegate>

@property (copy, nonatomic) NSArray *annotations;
@property (copy, nonatomic) NSDictionary *categoryImageDic;

@property (weak, nonatomic) MAMapView *mapView;

@end

@implementation TCServiceMapViewController {
    __weak TCServiceMapViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupAnnotations];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView addAnnotations:self.annotations];
}

#pragma mark - Private Methods

- (void)setupAnnotations {
    NSMutableArray *temp = [NSMutableArray array];
    for (TCService *service in self.dataList) {
        if (!service.store.coordinate) continue;
        
        TCServiceAnnotation *annotation = [[TCServiceAnnotation alloc] init];
        annotation.coordinate = service.store.coordinate2D;
        annotation.title = service.store.name;
        annotation.subtitle = service.store.address;
        annotation.imageName = self.categoryImageDic[service.store.category];
        annotation.serviceID = service.ID;
        [temp addObject:annotation];
    }
    self.annotations = [NSArray arrayWithArray:temp];
}

- (void)setupSubviews {
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    mapView.zoomLevel = 12.5;
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[TCServiceAnnotation class]]) {
        TCServiceAnnotationView *annotationView = (TCServiceAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"TCServiceAnnotationView"];
        if (annotationView == nil) {
            annotationView = [[TCServiceAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TCServiceAnnotationView"];
        }
        annotationView.canShowCallout = YES;
        TCServiceAnnotation *serviceAnnotation = annotation;
        annotationView.image = [UIImage imageNamed:serviceAnnotation.imageName];
        annotationView.nameLabel.text = annotation.title;
        annotationView.delegate = self;
        return annotationView;
    }
    return nil;
}

//- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
//    NSLog(@"--->%f", mapView.zoomLevel);
//}

#pragma mark - TCServiceAnnotationViewDelegate

- (void)didClickInfoButtonInServiceAnnotationView:(TCServiceAnnotationView *)view {
    TCServiceDetailViewController *vc = [[TCServiceDetailViewController alloc] init];
    TCServiceAnnotation *annotation = view.annotation;
    vc.serviceID = annotation.serviceID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Override Methods

- (NSDictionary *)categoryImageDic {
    if (_categoryImageDic == nil) {
        _categoryImageDic = @{
                              @"REPAST"       : @"map_repast",
                              @"HAIRDRESSING" : @"map_hairdressing",
                              @"FITNESS"      : @"map_fitness",
                              @"ENTERTAINMENT": @"map_entertainment",
                              @"KEEPHEALTHY"  : @"map_keephealthy"
                              };
    }
    return _categoryImageDic;
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
