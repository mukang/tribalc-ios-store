//
//  TCServiceLocationViewController.m
//  store
//
//  Created by 穆康 on 2017/3/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceLocationViewController.h"

#import "TCDetailStore.h"
#import "TCServiceAnnotation.h"
#import "TCServiceAnnotationView.h"

#import <MAMapKit/MAMapKit.h>

@interface TCServiceLocationViewController () <MAMapViewDelegate>

@property (weak, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) TCServiceAnnotation *annotation;

@property (copy, nonatomic) NSDictionary *categoryImageDic;

@end

@implementation TCServiceLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.detailStore.name;
    [self setupAnnotation];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView addAnnotation:self.annotation];
}

#pragma mark - Private Methods

- (void)setupAnnotation {
    TCServiceAnnotation *annotation = [[TCServiceAnnotation alloc] init];
    annotation.coordinate = self.detailStore.coordinate2D;
    annotation.title = self.detailStore.name;
    annotation.subtitle = self.detailStore.address;
    annotation.imageName = self.categoryImageDic[self.detailStore.category];
    self.annotation = annotation;
}

- (void)setupSubviews {
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    mapView.zoomLevel = 12.5;
    mapView.centerCoordinate = self.detailStore.coordinate2D;
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
        TCServiceAnnotation *serviceAnnotation = annotation;
        annotationView.image = [UIImage imageNamed:serviceAnnotation.imageName];
        annotationView.nameLabel.text = annotation.title;
        return annotationView;
    }
    return nil;
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
