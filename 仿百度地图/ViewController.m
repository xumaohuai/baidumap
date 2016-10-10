//
//  ViewController.m
//  仿百度地图
//
//  Created by 徐茂怀 on 2016/10/10.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (assign, nonatomic)CGFloat lastY;
@property (assign, nonatomic)NSInteger type;
@property (assign, nonatomic)BOOL decelate;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _type = 2;
    _mapView.zoomLevel =  17;
    _decelate = NO;
    _tableView.contentInset = UIEdgeInsetsMake(self.view.frame.size.height - 50 - 20, 0, 0, 0);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [btn setTitle:@"好多搜索结果啊" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    _tableView.tableHeaderView = btn;
    [btn addTarget:self action:@selector(changeContentOffset) forControlEvents:UIControlEventTouchUpInside];
    _tableView.decelerationRate = 0.1;
}

-(void)changeContentOffset
{
    if (_type == 2) {
        [self typeoneAction];
    }else
    {
        [self typeTwoAction];
    }
}

-(void)typezeroAction
{
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView setContentOffset:CGPointMake(0, 50)];
        _mapView.zoomLevel = 16;
    }completion:^(BOOL finished) {
//        [self.view bringSubviewToFront:_tableView];
        _decelate = YES;
    }];
    _type = 0;
}


-(void)typeoneAction
{
    [UIView animateWithDuration:0.2 animations:^{
         [self.view bringSubviewToFront:_tableView];
    }completion:^(BOOL finished) {
        [_tableView setContentOffset:CGPointMake(0, -300)];
        _mapView.zoomLevel = 16;
       
    }];
    _type = 1;
}

-(void)typeTwoAction
{
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView setContentOffset:CGPointMake(0, -self.view.frame.size.height + 50 + 20)];
        _mapView.zoomLevel = 19;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:_mapView];
    }];
    _type = 2;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (_type == 0) {
        if (scrollView.contentOffset.y < 50) {
            [self typeoneAction];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _lastY = scrollView.contentOffset.y;
    [self.view bringSubviewToFront:_tableView];
}
-(void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView{
    if (!_decelate) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_lastY < scrollView.contentOffset.y) {
        if (_type == 2) {
            [self typeoneAction];
            _decelate = NO;
        }else if (_type == 1)
        {
            [self typezeroAction];
        }
    }
    else{
        if (_type == 0 && scrollView.contentOffset.y < 50) {
            _decelate = NO;
            [self typeoneAction];
        }else if (_type == 1)
        {
            [self typeTwoAction];
             _decelate = NO;
        }
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%.2f",_tableView.contentOffset.y);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
