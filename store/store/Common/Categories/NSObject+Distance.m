//
//  NSObject+Distance.m
//  store
//
//  Created by 王帅锋 on 17/2/16.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "NSObject+Distance.h"
#import <CoreLocation/CoreLocation.h>

@implementation NSObject (Distance)

+(CGFloat)distanceWithCoordinateArr:(NSArray *)arr {
    if ([arr isKindOfClass:[NSArray class]]) {
        if (arr.count == 2) {
            CLLocationCoordinate2D storeCoordinate;
            storeCoordinate.latitude = [arr[1] floatValue];
            
            storeCoordinate.longitude = [arr[0] floatValue];
            
            NSString *coordinateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationLatAndLog"];
            if ([coordinateStr isKindOfClass:[NSString class]]) {
                NSRange range = [coordinateStr rangeOfString:@","];
                
                if (range.location != NSNotFound) {
                    
                    CLLocationCoordinate2D coordinate;
                    
                    NSArray *arr = [coordinateStr componentsSeparatedByString:@","];
                    
                    coordinate.latitude = [arr[0] floatValue];
                    
                    coordinate.longitude = [arr[1] floatValue];
                    
                    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:storeCoordinate.latitude longitude:storeCoordinate.longitude] ;
                    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:coordinate.latitude  longitude:coordinate.longitude];
                    CLLocationDistance kilometers = [location1 distanceFromLocation:location2];
                    return kilometers/1000;
                }
            }
            
        }
    }
    return 0.0;
}

@end
