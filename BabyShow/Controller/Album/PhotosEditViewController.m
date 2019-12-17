//
//  PhotosEditViewController.m
//  BabyShow
//
//  Created by Lau on 5/7/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PhotosEditViewController.h"

@interface PhotosEditViewController ()

@end

@implementation PhotosEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.dataArray=[[NSMutableArray alloc]init];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"编辑";
    
    _cache=[[ASIDownloadCache alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [_cache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    [[ASIDownloadCache sharedCache]setShouldRespectCacheControlHeaders:NO];

    _tableView =[[UITableView alloc]initWithFrame:self.view.frame];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_tableview_background.png"]];
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOntheView)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier=@"EDIT";
    
    PhotosEditCell *cell=[[PhotosEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    
    NSDictionary *imgDic=[self.dataArray objectAtIndex:indexPath.row];
    NSString *imgStr=[imgDic objectForKey:@"img_thumb"];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:imgStr]];
    __block ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        UIImage *image=[UIImage imageWithData:blockRequest.responseData];
        image=[image scaleToSize:image size:CGSizeMake(100, 100)];
        cell.photoView.image=image;
    }];
    [request startAsynchronous];
    [request setDownloadCache:_cache];
    cell.delegate=self;
    cell.timeBtn.tag=indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark 选择时间

-(void)timeBtnOnClick:(UIButton *)btn{
        
    [self touchOntheView];
        
    acs = [[UIActionSheet alloc] initWithTitle:@"\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    UISegmentedControl *btnCancle = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
    UISegmentedControl *btnConfirm =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
    [acs setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    pickerView = [[UIDatePicker alloc] init];
    pickerView.datePickerMode = UIDatePickerModeDate;
    [acs addSubview:pickerView];
    
    CGRect pickerRect = pickerView.bounds;
    pickerRect.origin.y = -50;
    pickerView.bounds = pickerRect;
    btnCancle.momentary = YES;
    btnCancle.frame = CGRectMake(10.0f, 7.0f, 65.0f, 32.0f);
    [btnCancle addTarget:self action:@selector(DatePickerCancelClick:) forControlEvents:UIControlEventValueChanged];
    [acs addSubview:btnCancle];
    btnCancle.tag=btn.tag;
    btnConfirm.tag = btn.tag;
    btnConfirm.momentary = YES;
    btnConfirm.frame = CGRectMake(245, 7.0f, 65.0f, 32.0f);
    [btnConfirm addTarget:self action:@selector(DatePickerDoneClick:) forControlEvents:UIControlEventValueChanged];
    [acs addSubview:btnConfirm];
    acs.tag=btn.tag;
    [acs showInView:self.view];
    [acs setBounds:CGRectMake(0,0,320, 500)];
    
}

-(void)DatePickerDoneClick:(UISegmentedControl *)btn{
    
    NSDate *select = [pickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
        
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:btn.tag inSection:0];
    PhotosEditCell *cell=(PhotosEditCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [cell.timeBtn setTitle:dateAndTime forState:UIControlStateNormal];
    [acs dismissWithClickedButtonIndex:btn.tag animated:YES];
    
}

-(void)DatePickerCancelClick:(UISegmentedControl *)btn{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:btn.tag inSection:0];
    PhotosEditCell *cell=(PhotosEditCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [cell.timeBtn setTitle:@"时间" forState:UIControlStateNormal];
    [acs dismissWithClickedButtonIndex:btn.tag animated:YES];

}

#pragma mark 键盘出来、收回

-(void)keyboardWillAppear:(NSNotification *) not{
    
    NSDictionary *info = [not userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _tableView.frame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT-kbSize.height);

}

-(void)keyboardWillDisappear:(NSNotification *) not{
    
    _tableView.frame=self.view.frame;
    
}

-(void)touchOntheView{
    
    for (int i=0; i<self.dataArray.count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        PhotosEditCell *cell=(PhotosEditCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [cell.titleField resignFirstResponder];
        [cell.areaField resignFirstResponder];
    }
    
}

@end
