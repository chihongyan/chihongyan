//
//  ViewController.m
//  MyMap
//
//  Created by lanou3g on 15/10/12.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import <MAMapKit/MAMapKit.h>

@interface ViewController ()<MKMapViewDelegate,MAMapViewDelegate>

//创建一个地图视图
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark 授权 定位
    //请求定位服务
    self.manager = [[CLLocationManager alloc]init];
    // 如果不是这个kCLAuthorizationStatusAuthorizedWhenInUse 向设备请求授权
    if ([CLLocationManager authorizationStatus] !=kCLAuthorizationStatusAuthorizedWhenInUse) {
        // 向设备申请"程序使用中时,使用定位功能" //requestAlwaysAuthorization
        [self.manager requestWhenInUseAuthorization];  
    }
#pragma mark 地图
    self.mapView = [[MKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.mapView];
    // 设置地图样式  
    self.mapView.mapType = MKMapTypeHybrid;
    // 设置地图显示的中心 //引入#import <CoreLocation/CoreLocation.h>
    CLLocationCoordinate2D locate = CLLocationCoordinate2DMake(40, 116);
    [self.mapView setCenterCoordinate:locate];
     // 设置地图的显示范围
    [self.mapView setRegion:MKCoordinateRegionMake(locate, MKCoordinateSpanMake(10, 10))];
    
    // 跟踪用户,打开用户的位置
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    // MKUserTrackingModeNone = 0不跟踪用户
    // 是否允许地图旋转
    self.mapView.rotateEnabled = NO;
    // 设置代理
    self.mapView.delegate = self;
    
    
    
//    [MAMapServices sharedServices].apiKey = @"d942843f6a26764589d9f758e5436a10";
//    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    

}
// 定位成功的代理方法
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"获取用户位置完成");
}

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"定位失败");
}
// 屏幕区域开始发生变化
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"屏幕取将要发生变化");
}
// 屏幕区域变化结束
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"屏幕区域变化结束");
}
#pragma mark 大头针
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    MyAnnotation *ann = [[MyAnnotation alloc]init];
    ann.coordinate = CLLocationCoordinate2DMake(40, 116);
    ann.title = @"哥在此!!!!!";
    ann.subtitle = @"开";

    ann.icon = [UIImage imageNamed:@"22.png"];
    [self.mapView addAnnotation:ann];
    // 一堆大头针
//    self.mapView addAnnotations:<#(NSArray *)#>
}

/*
#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"22.png"]];//定义详情左侧视图
        }
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((MyAnnotation *)annotation).icon;//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
}
*/

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MyAnnotation class]])  return nil;
    static NSString *identifier = @"identifire";
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pinAnnotationView) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: identifier];
    }
    // 设置大头针的属性
    pinAnnotationView.annotation = annotation;
    pinAnnotationView.image = ((MyAnnotation *)annotation).icon;
    // 设置可以显示冒泡上的左右图片
    pinAnnotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"22.png"]];
    pinAnnotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"22.png"]];
    // 从天而降(动画，只有用系统大头针样式才起作用)
//     pinAnnotationView.animatesDrop = YES;
    //气泡偏移量
    pinAnnotationView.calloutOffset = CGPointMake(0, 0);
    // 设置可以显示冒泡
    pinAnnotationView.canShowCallout = YES;
    return pinAnnotationView;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
