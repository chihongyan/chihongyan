//
//  MyAnnotation.h
//  MyMap
//
//  Created by lanou3g on 15/10/12.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>
#pragma mark 自定义大头针
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * subtitle;

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property(nonatomic,strong)UIImage *icon;

@end
