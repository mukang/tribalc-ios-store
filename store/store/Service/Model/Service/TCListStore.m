//
//  TCListStore.m
//  individual
//
//  Created by WYH on 16/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCListStore.h"

@implementation TCListStore

- (void)setCoordinate:(NSArray *)coordinate {
    _coordinate = coordinate;
    
    if (coordinate.count == 2) {
        CLLocationDegrees latitude = [coordinate[1] doubleValue];
        CLLocationDegrees longitude = [coordinate[0] doubleValue];
        self.coordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
    }
}

@end
