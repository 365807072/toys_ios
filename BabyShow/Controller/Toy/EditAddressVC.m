//
//  EditAddressVC.m
//  BabyShow
//
//  Created by WMY on 17/5/16.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditAddressVC.h"

@interface EditAddressVC ()<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIScrollView *bottomScrollView;//租期信息
@property(nonatomic,strong)UIView *backView;//整体的底色

@property(nonatomic,strong)BaseLabel *labelAddress;
@property(nonatomic,strong)UIButton *btnAddress;
@property(nonatomic,strong)UIButton *btnIcon;

@property(nonatomic,strong)BaseLabel *labelDetailAddress;
@property(nonatomic,strong)UITextView *tfAddress;

@property(nonatomic,strong)UIView *grayView;//地址后面的弹窗
@property(nonatomic,strong)UIPickerView *pickView;//地址选择器
@property(nonatomic,strong)UIView *sureBtnView;//确定地址btn后的view
@property(nonatomic,strong)UIButton *sureBtn;//确定地址
@property(nonatomic,strong)UILabel *choseDayLabel;
@property(nonatomic,strong)NSMutableArray *areaArray;//区数组
@property(nonatomic,strong)NSMutableArray *roadArray;//街道数组
@property(nonatomic,strong)NSMutableArray *roadIdArray;//街道id数组
@property(nonatomic,strong)NSString *areaString;
@property(nonatomic,strong)NSString *roadString;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)UIButton *btnSurePay;
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";
    [self setSubViews];
    [self setLeftButton];
    [self getAreaData];
    // Do any additional setup after loading the view.
}
-(void)setSubViews{
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f5f6f5"];
    
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH,self.view.bounds.size.height)];
    _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREEN_HEIGHT*2);
    _bottomScrollView.alwaysBounceVertical = YES;
    _bottomScrollView.backgroundColor = [BBSColor hexStringToColor:@"f5f6f5"];
    [self.view addSubview:_bottomScrollView];
    

    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView];
    
    self.labelAddress = [BaseLabel makeFrame:CGRectMake(10, 10, 80, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"所在地区："];
    [self.backView addSubview:self.labelAddress];
    self.btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnIcon.frame = CGRectMake(SCREENWIDTH-17, 13, 7, 12);
    [self.btnIcon setImage:[UIImage imageNamed:@"post_group_more_arrow"] forState:UIControlStateNormal];
    [self.backView addSubview:self.btnIcon];
    
    self.btnAddress =[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAddress.frame = CGRectMake(SCREENWIDTH-205,9,200,30);
   // self.btnAddress.backgroundColor = [UIColor redColor];
    self.btnAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnAddress setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    self.btnAddress.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btnAddress setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 20)];
    [self.btnAddress setTitle:@"请选择" forState:UIControlStateNormal];
    [self.backView addSubview:self.btnAddress];
    [self.btnAddress addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 0.5)];
    lineView2.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView addSubview:lineView2];
    
    self.labelDetailAddress = [BaseLabel makeFrame:CGRectMake(10, 10+40, 80, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"详细地址："];
    [self.backView addSubview:self.labelDetailAddress];
    
    self.tfAddress=[[UITextView alloc]initWithFrame:CGRectMake(80,45,SCREENWIDTH-80-10, 50)];
    self.tfAddress.text=@"请填写详细地址，不少于5个字";
    self.tfAddress.font=[UIFont systemFontOfSize:13];
    self.tfAddress.textColor=[BBSColor hexStringToColor:@"#cfcfd4"];
    self.tfAddress.delegate=self;
    [self.backView addSubview:self.tfAddress];
    
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-150,SCREENWIDTH , 150)];
    self.pickView.showsSelectionIndicator = YES;
    self.pickView.userInteractionEnabled = YES;
    self.pickView.backgroundColor = [UIColor whiteColor];
    
    self.sureBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-180, SCREENWIDTH, 50)];
    self.sureBtnView.backgroundColor = [UIColor whiteColor];
    
    _choseDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 20)];
    _choseDayLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    _choseDayLabel.font = [UIFont systemFontOfSize:15];
    [self.sureBtnView addSubview:_choseDayLabel];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(SCREENWIDTH-50, 10, 40, 40);
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [self.sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.sureBtnView addSubview:self.sureBtn];
    
    _btnSurePay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSurePay.layer.masksToBounds = YES;
    _btnSurePay.layer.cornerRadius = 19;
    _btnSurePay.frame = CGRectMake(24,self.backView.frame.origin.y+self.backView.frame.size.height+12, SCREENWIDTH-48, 38);
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
    _btnSurePay.titleLabel.text = @"确认地址";
    [_btnSurePay setTitle:@"确认地址" forState:UIControlStateNormal];
    [_btnSurePay setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [_btnSurePay addTarget:self action:@selector(postAdddressData) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomScrollView addSubview:_btnSurePay];
}
#pragma mark 返回按钮
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 收货区域的请求
-(void)getAreaData{
    self.areaArray = [NSMutableArray array];
    self.roadArray = [NSMutableArray array];
    self.roadIdArray = [NSMutableArray array];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:kGetToysCityList params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSArray *data = result[@"data"];
            for (NSDictionary *dataDic in data) {
                NSString *cityName = dataDic[@"city_name"];
                [self.areaArray addObject:cityName];
                NSArray *cityArray = dataDic[@"children"];
                NSMutableArray *cityAreaArray = [NSMutableArray array];
                NSMutableArray *cityAreaIdArray = [NSMutableArray array];
                for (NSDictionary *cityDic in cityArray) {
                    NSString *cityAreaName = cityDic[@"city_name"];
                    NSString *cityAreaId = cityDic[@"city_id"];
                    [cityAreaArray addObject:[NSString stringWithFormat:@"%@",cityAreaName]];
                    [cityAreaIdArray addObject:[NSString stringWithFormat:@"%@",cityAreaId]];
                }
                [_roadArray addObject:cityAreaArray];
                [_roadIdArray addObject:cityAreaIdArray];
            }
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
          }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，请检查一下网络设置" andDelegate:self];
    }];

}
#pragma mark 上传收货地址
-(void)postAdddressData{
    if (self.tfAddress.text.length < 5 || [self.tfAddress.text isEqualToString:@"请填写详细地址，不少于5个字"]) {
        [BBSAlert showAlertWithContent:@"请填写详细地址，不少于5个字" andDelegate:self];
        
    }else{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
        [params setObject:_tfAddress.text forKey:@"address"];
        if (_cityId.length > 0) {
            [params setObject:_cityId forKey:@"city_id"];
        }
        NSLog(@"param pappp = %@",params);
       [[HTTPClient sharedClient]postNewV1:kAddToysAddress params:params success:^(NSDictionary *result) {
           if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
               NSDictionary *data = result[@"data"];
               self.getDataBlock(data);
               [self.navigationController popViewControllerAnimated:YES];
               
           }else{
               [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
           }
       } failed:^(NSError *error) {
           [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
       }];
    }
}
#pragma mark -UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.tfAddress){
        if (!_cityId) {
            [self showList];
            if ([textView.text isEqualToString:@"请填写详细地址，不少于5个字"]) {
                textView.text=@"";
                self.tfAddress.textColor=[BBSColor hexStringToColor:@"333333"];
            }
        }else{
        if ([textView.text isEqualToString:@"请填写详细地址，不少于5个字"]) {
            textView.text=@"";
            self.tfAddress.textColor=[BBSColor hexStringToColor:@"333333"];
          }
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView==_tfAddress){
        if (textView.text.length==0) {
            textView.text=@"请填写详细地址，不少于5个字";
            self.tfAddress.textColor=[BBSColor hexStringToColor:@"cfcfd4"];
            
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
}
-(void)showList{
    if (!_grayView) {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _grayView.backgroundColor =  [BBSColor hexStringToColor:@"000000" alpha:0.3];
        [self.view addSubview:_grayView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeList)];
        [_grayView addGestureRecognizer:singleTap];
        _choseDayLabel.text = @"选择收货地址";
        [self.view addSubview:self.pickView];
        [self.view addSubview:self.sureBtnView];
        if (_areaArray.count > 0) {
            _areaString = [NSString stringWithFormat:@"%@",_areaArray[0]];
            NSArray *roadArray = _roadArray[0];
            _roadString = [NSString stringWithFormat:@"%@",roadArray[0]];
            //城市的id
            NSArray *cityIdArray = _roadIdArray[0];
            _cityId = cityIdArray[0];
            NSString *totleAddress = [NSString stringWithFormat:@"%@%@",_areaString,_roadString];
            [self.btnAddress setTitle:totleAddress forState:UIControlStateNormal];
        }
       
    }
    _grayView.hidden = NO;
    self.pickView.hidden = NO;
    self.sureBtnView.hidden = NO;
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    [self.pickView selectRow:0 inComponent:1 animated:NO];
    [self.sureBtn addTarget:self action:@selector(removeList) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 移除控件
-(void)removeList{
    _grayView.hidden = YES;
    self.pickView.hidden = YES;
    self.sureBtnView.hidden = YES;
}

#pragma mark UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;//列数
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _areaArray.count;
        
    }else if(component == 1){
        NSInteger selRow = [pickerView selectedRowInComponent:0];
        NSArray *roadArray = _roadArray[selRow];
        return [roadArray count];
        
    }else{
        return 0;
    }

}
//返回选中的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (0 == component) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }
    NSInteger selectOne = [pickerView selectedRowInComponent:0];
    NSInteger selectTow = [pickerView selectedRowInComponent:1];
    _areaString = [NSString stringWithFormat:@"%@",_areaArray[selectOne]];
    NSArray *roadArray = _roadArray[selectOne];
    _roadString = [NSString stringWithFormat:@"%@",roadArray[selectTow]];
    //城市的id
    NSArray *cityIdArray = _roadIdArray[selectOne];
    _cityId = cityIdArray[selectTow];
    NSLog(@"_areacityid = %@",_cityId);

    NSString *totleAddress = [NSString stringWithFormat:@"%@%@",_areaString,_roadString];
    [self.btnAddress setTitle:totleAddress forState:UIControlStateNormal];

}
#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 150;
    }
    return 200;
}
// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return _areaArray[row];
 
    }else if(component == 1){
        NSInteger selRow = [pickerView selectedRowInComponent:0];
        return _roadArray[selRow][row];

    }else{
        return 0;
    }
}
//设置pickerview上的label样式
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myLabel = nil;
    if (component == 0) {
        myLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 0, 80, 20)];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.font = [UIFont systemFontOfSize:14];
        myLabel.text =  [self pickerView:pickerView titleForRow:row forComponent:0];
    }else{
        myLabel = [[UILabel  alloc]initWithFrame:CGRectMake(100, 0, 120, 20)];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.font = [UIFont systemFontOfSize:14];
        myLabel.text =  [self pickerView:pickerView titleForRow:row forComponent:component];
   
    }
    return myLabel;
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
