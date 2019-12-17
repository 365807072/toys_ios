//
//  EditEssenceVC.m
//  BabyShow
//
//  Created by WMY on 16/9/23.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditEssenceVC.h"
#import "EditEssenceCell.h"
#import "SureOrCancleCell.h"
#import "UIImageView+WebCache.h"

@interface EditEssenceVC ()
@property(nonatomic,strong)UIView *lineWhiteView4;
@property(nonatomic,assign)NSInteger lastTag;
@property(nonatomic,strong)NSMutableArray *indexSelectArray;
@end

@implementation EditEssenceVC
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.indexSelectArray) {
        self.indexSelectArray = [NSMutableArray array];
    }
    _lastTag = 0;
    arrayCount = _leftArray.count;
    [self setTableView];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"a4a4a4" alpha:0.5];
    // Do any additional setup after loading the view.
}
-(void)removeTheViewFromWidow{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finish){
        [self.view setHidden:YES];
    }];

}
-(void)setTableView{
    _firstTableView = [[UITableView alloc]init];

    if (arrayCount>7) {
        float height = 6*50;
        _firstTableView.frame = CGRectMake(30, (SCREENHEIGHT-height)/2, SCREENWIDTH-60, height);
    }else{
        float height = arrayCount*50;
        _firstTableView.frame = CGRectMake(30, (SCREENHEIGHT-height)/2, SCREENWIDTH-60, height);
    }
    _firstTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _firstTableView.backgroundColor = [UIColor whiteColor];
    _firstTableView.delegate = self;
    _firstTableView.dataSource = self;
    [self.view addSubview:_firstTableView];
    
    _lineWhiteView4 = [[UIView alloc]initWithFrame:CGRectMake(30, _firstTableView.frame.origin.y+_firstTableView.frame.size.height, SCREENWIDTH-60, 50)];
    _lineWhiteView4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_lineWhiteView4];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, 0, 129, 50);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sureBtn setTitleColor:[BBSColor hexStringToColor:@"fd6363"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAddId) forControlEvents:UIControlEventTouchUpInside];
    [_lineWhiteView4 addSubview:sureBtn];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(130, 12, 0.5, 26)];
    lineView4.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [_lineWhiteView4 addSubview:lineView4];
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(131, 0, 129, 50);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(hideTableView) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [cancleBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    [_lineWhiteView4 addSubview:cancleBtn];
}
-(void)sureAddId{
    if (self.fromModel == 1) {
        if (_lastTag == 0) {
            [BBSAlert showAlertWithContent:@"未编辑分类" andDelegate:self];
            [self hideTableView];
        }else{
        NSDictionary *dic = [_leftArray objectAtIndex:_lastTag-998];
        NSString *isCancle = [NSString stringWithFormat:@"%@",dic[@"essence_id"]];
        NSDictionary *Param=[NSDictionary dictionaryWithObjectsAndKeys:
                             LOGIN_USER_ID,@"login_user_id",
                             self.imgId,@"img_id",[NSString stringWithFormat:@"%ld",self.groupId],@"group_id",isCancle,@"is_cancle",nil];
        UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"editEssenceListing"  Method:NetMethodPost andParam:Param];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
        
        for (NSString *key in [Param allKeys]) {
            id obj = [Param objectForKey:key];
            [request setPostValue:obj forKey:key];
        }
        
        [request setDownloadCache:theAppDelegate.myCache];
        [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setShouldAttemptPersistentConnection:NO];
        [request setTimeOutSeconds:10];
        [request startAsynchronous];
        
        __weak ASIFormDataRequest *blockRequest = request;
        [request setCompletionBlock:^{
            
            NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
            if ([[dic objectForKey:kBBSSuccess] integerValue] == YES) {
                [self hideTableView];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"managermentPostSuccess" object:nil];
                
            }else{
                NSString *errorString=[dic objectForKey:kBBSReMsg];
                [BBSAlert showAlertWithContent:errorString andDelegate:self];
            }
        }];
        
        [request setFailedBlock:^{
           // [BBSAlert showAlertWithContent:@"网络不给力哦！" andDelegate:self];
        }];
        }
    }else if (self.fromModel == 2){
        if (self.indexSelectArray.count == 0) {
            [BBSAlert showAlertWithContent:@"没有添加任何分类" andDelegate:self];
            [self performSelector:@selector(hideTableView) withObject:nil afterDelay:1];
        }else{
            NSString *selectString = @"";
            for (int i = 0; i < self.indexSelectArray.count; i++) {
                NSString *index = [NSString stringWithFormat:@"%@",self.indexSelectArray[i]];
                int selectIndex = [index intValue];
                NSDictionary *dic = _leftArray[selectIndex];
                NSString *classId = [NSString stringWithFormat:@"%@",dic[@"group_class_id"]];
                selectString = [NSString stringWithFormat:@"%@,%@",selectString,classId];
            }
            NSString *string = [selectString substringWithRange:NSMakeRange(1,selectString.length-1)];
            NSDictionary *Param=[NSDictionary dictionaryWithObjectsAndKeys:
                                 LOGIN_USER_ID,@"login_user_id",
                                 self.imgId,@"img_id",string,@"group_class_ids",nil];
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"editCategoryListing"  Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            for (NSString *key in [Param allKeys]) {
                id obj = [Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:theAppDelegate.myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIFormDataRequest *blockRequest = request;
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess] integerValue] == YES) {
                    [self hideTableView];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"managermentPostSuccess" object:nil];
                    [BBSAlert showAlertWithContent:@"管理成功" andDelegate:self];
                    
                }else{
                    NSString *errorString=[dic objectForKey:kBBSReMsg];
                    [BBSAlert showAlertWithContent:errorString andDelegate:self];
                }
            }];
            
            [request setFailedBlock:^{
            }];

            
        }
        
    }

}
- (void)hideTableView{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finish){
        [self.view setHidden:YES];
    }];

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _leftArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;

        static NSString *identifier = @"EDITESSENCECELL";
        EditEssenceCell *editCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (editCell == nil) {
            editCell = [[EditEssenceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    editCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = [_leftArray objectAtIndex:indexPath.row];
    if (self.fromModel == 1) {
        editCell.classLabel.text = [NSString stringWithFormat:@"%@",dic[@"essence_name"]];
        NSString *essence_state = dic[@"essence_state"];
        editCell.classImg.tag = indexPath.row+998;
        if ([essence_state isEqualToString:@"1"]) {
            editCell.classImg.image = [UIImage imageNamed:@"btn_select_pay"];
            _lastTag = indexPath.row+998;
        }else{
            editCell.classImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
        }
        return editCell;
    }else if (self.fromModel == 2){
        editCell.classLabel.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
        NSString *essence_state = dic[@"group_class_state"];
        editCell.classImg.tag = indexPath.row+998;
        if ([essence_state isEqualToString:@"1"]) {
            editCell.classImg.image = [UIImage imageNamed:@"btn_select_pay"];
            NSNumber *tagNumber = [NSNumber numberWithInteger:indexPath.row];
            [self.indexSelectArray addObject:tagNumber];
            
        }else{
            editCell.classImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
        }
        return editCell;

        
    }
    return returnCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.fromModel == 1) {
        if (_lastTag != 0) {
            UIImageView  *lastImgView = (UIImageView*)[_firstTableView viewWithTag:_lastTag];
            UIImageView *imgView = (UIImageView*)[_firstTableView viewWithTag:indexPath.row+998];
            lastImgView.image = [UIImage imageNamed:@"btn_unselect_pay"];
            imgView.image = [UIImage imageNamed:@"btn_select_pay"];
            _lastTag = indexPath.row+998;
        }else{
            UIImageView *imgView = (UIImageView*)[_firstTableView viewWithTag:indexPath.row+998];
            imgView.image = [UIImage imageNamed:@"btn_select_pay"];
            _lastTag = indexPath.row+998;
        }
    }else if (self.fromModel == 2){
        UIImageView *imgView = (UIImageView*)[_firstTableView viewWithTag:indexPath.row+998];
        if ([imgView.image isEqual:[UIImage imageNamed:@"btn_select_pay"]]) {
            imgView.image = [UIImage imageNamed:@"btn_unselect_pay"];
            NSNumber *tagNumber = [NSNumber numberWithInteger:indexPath.row];
            [self.indexSelectArray removeObject:tagNumber];

        }else{
            imgView.image = [UIImage imageNamed:@"btn_select_pay"];
            NSNumber *tagNumber = [NSNumber numberWithInteger:indexPath.row];
            [self.indexSelectArray addObject:tagNumber];

        }
        
    }
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
