//
//  StoreMapViewController.m
//  BabyShow
//
//  Created by WMY on 15/10/26.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreMapViewController.h"
#import <QMapKit/QMapKit.h>
#import "CheckInstalledMapAPP.h"
#import <MapKit/MapKit.h>

@interface StoreMapViewController ()<QMapViewDelegate>
{
    //当前定位的状态
    CLAuthorizationStatus status;

}
@property(nonatomic,strong)QMapView *mapView;
@property(nonatomic,strong)NSMutableArray *annotations;//标注


@end

@implementation StoreMapViewController
@synthesize mapView = _mapView;
@synthesize  annotations = _annotations;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMapView];
    [self initAnnotation];
    [self setBackButton];
    [self setLocatioButton];
    [self setGPSView];

    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;

}
#pragma mark UI
-(void)setBackButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 30, 35, 35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_map"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [self.view bringSubviewToFront:backButton];
}
-(void)setLocatioButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, SCREENHEIGHT-140, 35, 35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_location_map"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(setGetLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}
-(void)setGPSView{
    UIView *GPSBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-100, SCREENWIDTH, 100)];
    GPSBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:GPSBackView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 18)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = self.storeName;
    [GPSBackView addSubview:titleLabel];
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, SCREENWIDTH-10, 15)];
    addressLabel.font = [UIFont systemFontOfSize:13];
    addressLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    addressLabel.text = self.storeAddress;
    [GPSBackView addSubview:addressLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 58, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"b9b9b9"];
    [GPSBackView addSubview:lineView];
    UIButton *GPSImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    GPSImgButton.frame = CGRectMake(SCREENWIDTH/2-30, addressLabel.frame.origin.y+addressLabel.frame.size.height+20, 16, 16);
    [GPSImgButton setBackgroundImage:[UIImage imageNamed:@"btn_gps_map"] forState:UIControlStateNormal];
    [GPSImgButton addTarget:self action:@selector(beginGPS) forControlEvents:UIControlEventTouchUpInside];
    
    [GPSBackView addSubview:GPSImgButton];
    
    UIButton *GPSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    GPSButton.frame = CGRectMake(GPSImgButton.frame.origin.x+16, addressLabel.frame.origin.y+addressLabel.frame.size.height+19, 60, 20);
    [GPSButton setTitle:@"到这去" forState:UIControlStateNormal];
    [GPSButton setTitleColor:[BBSColor hexStringToColor:@"4e84ff"] forState:UIControlStateNormal];
    [GPSButton addTarget:self action:@selector(beginGPS) forControlEvents:UIControlEventTouchUpInside];
    [GPSBackView addSubview:GPSButton];
    UIButton *GPStaget = [UIButton buttonWithType:UIButtonTypeCustom];
    GPStaget.frame = CGRectMake(0, 60, SCREENWIDTH, 30);
    [GPStaget addTarget:self action:@selector(beginGPS) forControlEvents:UIControlEventTouchUpInside];
    [GPSBackView addSubview:GPStaget];
    
}
-(void)setGetLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        //定位的button
        status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status||kCLAuthorizationStatusRestricted == status ) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请在系统设置中打开“定位服务”来允许“自由环球租赁”获取您的位置" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
        }else{

            self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;

        }
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请在系统设置中打开“定位服务”来允许“自由环球租赁”获取您的位置" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }


}
//开始导航
-(void)beginGPS{
    
    NSArray *appListArr = [CheckInstalledMapAPP checkHasOwnApp];
    NSString *sheetTitle = [NSString stringWithFormat:@"选择地图"];
    UIActionSheet *sheet;
    if ([appListArr count] == 2) {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],nil];
    }else if ([appListArr count] == 3){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1], nil];
    }else if ([appListArr count] == 4){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2], nil];
    }else if ([appListArr count] == 5){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3], nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}
- (void)initMapView
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setZoomLevel:14];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;


    [self.view addSubview:self.mapView];
}
-(void)initAnnotation{
    self.annotations = [NSMutableArray array];
    QPointAnnotation *red = [[QPointAnnotation alloc]init];
    float lat = [self.tencentLat floatValue];
    float log = [self.tencentLog floatValue];
    red.coordinate = CLLocationCoordinate2DMake(lat, log);
    self.mapView.centerCoordinate = red.coordinate;
    [self.annotations addObject:red];
    [self.mapView addAnnotations:self.annotations];

    
}
#pragma mark back
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ActionSheetDelegate 跳转到各个第三方地图
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"self.log = %@,self.lon = %@",self.lat,self.log);
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 0) {
        CLLocationCoordinate2D to;
        float lat = [self.tencentLat floatValue];
        float log = [self.tencentLog floatValue];
        to.latitude =lat;
        to.longitude =log;
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:to addressDictionary:nil]];
        toLocation.name = self.storeAddress;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation,toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving,[NSNumber numberWithBool:YES] ,nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey,MKLaunchOptionsShowsTrafficKey, nil]]];
    }else if ([btnTitle isEqualToString:@"高德地图"]){
        
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=自由环球租赁&backScheme=AlipayInBabyShow&lat=%@&lon=%@&dev=0&style=2",self.tencentLat,self.tencentLog]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }else if([btnTitle isEqualToString:@"百度地图"]){
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving",self.mapView.userLocation.coordinate.latitude,self.mapView.userLocation.coordinate.longitude,[self.lat floatValue],[self.log floatValue]];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
#pragma mark - Annotation Delegate
-(QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QPinAnnotationView *annotationView = (QPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = YES;
        annotationView.canShowCallout   = YES;
        
        annotationView.pinColor = [self.annotations indexOfObject:annotation];
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    
    return nil;

}
#pragma mark mapDelegate
-(void)mapViewWillStartLocatingUser:(QMapView *)mapView{
    NSLog(@"获取开始定位状态");
    
}
-(void)mapViewDidStopLocatingUser:(QMapView *)mapView{
    NSLog(@"获取停止定位的状态");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

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
