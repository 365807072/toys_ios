//
//  EditHeadMessVC.m
//  BabyShow
//
//  Created by WMY on 16/9/21.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditHeadMessVC.h"
#import "UIImageView+WebCache.h"

@interface EditHeadMessVC ()

@property(nonatomic,strong)UILabel *picLabel;
@property(nonatomic,strong)UIImageView *picImg;
@property(nonatomic,strong)UILabel *headLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *subTextLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;
@property(nonatomic,strong)UIImage *pictureImg;
@property(nonatomic,strong)UILabel *editColor;//编辑文字颜色
@property(nonatomic,strong)UILabel *alertLabel;//编辑提示文字
@property(nonatomic,strong)UILabel *alerMessLabel;//编辑文字
@property(nonatomic,assign)BOOL isColorSet;



@end

@implementation EditHeadMessVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    //修改成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGroupSucceed) name:EDITGROUPHEAD_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGroupFail:) name:EDITGROUPHEAD_FAIL object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self setBackgroudView];
    
    // Do any additional setup after loading the view.
}
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setBackgroudView{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 144+41+41)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 62)];
    [whiteView addSubview:backView1];
    self.picLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 21, 100, 20)];
    self.picLabel.text = @"编辑头部大图";
    self.picLabel.font = [UIFont systemFontOfSize:15];
    self.picLabel.textAlignment = NSTextAlignmentLeft;
    [backView1 addSubview:self.picLabel];
    self.picImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-77, 10, 64, 42)];
    [self.picImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cover]]];
    [backView1 addSubview:self.picImg];
    self.pictureImg = self.picImg.image;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 61, SCREENWIDTH, 0.5)];
    lineView1.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [backView1 addSubview:lineView1];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseNewPic)];
    [backView1 addGestureRecognizer:singleTap];
    
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 62, SCREENWIDTH, 41)];
    [whiteView addSubview:backView2];
    self.headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    self.headLabel.text = @"编辑头部文字";
    self.headLabel.font = [UIFont systemFontOfSize:15];
    self.headLabel.textAlignment = NSTextAlignmentLeft;
    [backView2 addSubview:self.headLabel];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-200, 10, 190, 20)];
    self.nameLabel.text = self.groupName;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    [backView2 addSubview:self.nameLabel];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40.5, SCREENWIDTH, 0.5)];
    lineView2.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [backView2 addSubview:lineView2];
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNewGroupName)];
    [backView2 addGestureRecognizer:singleTap2];
    
    UIView *backView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 103, SCREENWIDTH, 41)];
    [whiteView addSubview:backView3];
    self.subTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 20)];
    self.subTextLabel.text = @"编辑简介文字";
    self.subTextLabel.font = [UIFont systemFontOfSize:15];
    self.subTextLabel.textAlignment = NSTextAlignmentLeft;
    [backView3 addSubview:self.subTextLabel];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-200, 10, 190, 20)];
    self.subTitleLabel.text = self.desSub;
    self.subTitleLabel.font = [UIFont systemFontOfSize:15];
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    self.subTitleLabel
    .textColor = [BBSColor hexStringToColor:@"666666"];

    [backView3 addSubview:self.subTitleLabel];
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 40.5, SCREENWIDTH, 0.5)];
    lineView3.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [backView3 addSubview:lineView3];
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNewGroupSubDesc)];
    [backView3 addGestureRecognizer:singleTap3];
    
    UIView *backView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 144, SCREENWIDTH, 41)];
    [whiteView addSubview:backView5];
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 20)];
    self.alertLabel.text = @"编辑提示文字";
    self.alertLabel.font = [UIFont systemFontOfSize:15];
    self.alertLabel.textAlignment = NSTextAlignmentLeft;
    [backView5 addSubview:self.alertLabel];
    
    self.alerMessLabel= [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-200, 10, 190, 20)];
    self.alerMessLabel.text = self.recommend_title;
    self.alerMessLabel.font = [UIFont systemFontOfSize:15];
    self.alerMessLabel.textAlignment = NSTextAlignmentRight;
    self.alerMessLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    [backView5 addSubview:self.alerMessLabel];
    

    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 40.5, SCREENWIDTH, 0.5)];
    lineView5.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [backView5 addSubview:lineView5];
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAlert)];
    [backView5 addGestureRecognizer:singleTap4];



    
    UIView *backView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 144+41, SCREENWIDTH, 41)];
    [whiteView addSubview:backView4];
    self.editColor = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 20)];
    self.editColor.text = @"编辑文字颜色";
    self.editColor.font = [UIFont systemFontOfSize:15];
    self.editColor.textAlignment = NSTextAlignmentLeft;
    [backView4 addSubview:self.editColor];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 40.5, SCREENWIDTH, 0.5)];
    lineView4.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [backView4 addSubview:lineView4];
    for (int i = 0; i < 5; i++) {
        UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"edit_%d_unselect",i]];
        colorBtn.frame = CGRectMake(SCREENWIDTH-150+i*30, 10, 20, 20);
        [colorBtn setBackgroundImage:img forState:UIControlStateNormal];
        [backView4 addSubview:colorBtn];
        colorBtn.tag = i+888;
        [colorBtn addTarget:self action:@selector(changeColorText:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)changeColorText:(id)sender{
    UIButton *btn = (id)sender;
    NSInteger tag = btn.tag-888;
    UIButton *btn0 = [self.view viewWithTag:888];
    UIButton *btn1 = [self.view viewWithTag:889];
    UIButton *btn2 = [self.view viewWithTag:890];
    UIButton *btn3 = [self.view viewWithTag:891];
    UIButton *btn4 = [self.view viewWithTag:892];
    [self setAvartarImage:nil groupName:nil desSub:nil alertTitle:nil color_index:[NSString stringWithFormat:@"%ld",tag+1] type:5];
    
    if (tag == 0) {
        [btn0 setBackgroundImage:[UIImage imageNamed:@"edit_0_select"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"edit_1_unselect"] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"edit_2_select"] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"edit_3_unselect"] forState:UIControlStateNormal];
        [btn4 setBackgroundImage:[UIImage imageNamed:@"edit_4_unselect"] forState:UIControlStateNormal];
    }else if (tag == 1){
        [btn0 setBackgroundImage:[UIImage imageNamed:@"edit_0_unselect"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"edit_1_select"] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"edit_2_select"] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"edit_3_unselect"] forState:UIControlStateNormal];
        [btn4 setBackgroundImage:[UIImage imageNamed:@"edit_4_unselect"] forState:UIControlStateNormal];

    }else if (tag == 2){
        [btn0 setBackgroundImage:[UIImage imageNamed:@"edit_0_unselect"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"edit_1_unselect"] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"edit_2_unselect"] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"edit_3_unselect"] forState:UIControlStateNormal];
        [btn4 setBackgroundImage:[UIImage imageNamed:@"edit_4_unselect"] forState:UIControlStateNormal];
        
    }else if (tag == 3){
        [btn0 setBackgroundImage:[UIImage imageNamed:@"edit_0_unselect"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"edit_1_unselect"] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"edit_2_select"] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"edit_3_select"] forState:UIControlStateNormal];
        [btn4 setBackgroundImage:[UIImage imageNamed:@"edit_4_unselect"] forState:UIControlStateNormal];
        
    }if (tag == 4) {
        [btn0 setBackgroundImage:[UIImage imageNamed:@"edit_0_unselect"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"edit_1_unselect"] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"edit_2_select"] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"edit_3_unselect"] forState:UIControlStateNormal];
        [btn4 setBackgroundImage:[UIImage imageNamed:@"edit_4_select"] forState:UIControlStateNormal];

    }


    

    
}
-(void)changeNewGroupName{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"修改群名" message:self.groupName delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
    
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.tag = 600;
    [alert show];
    
}
-(void)changeNewGroupSubDesc{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"修改副标题" message:self.desSub delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
    alert.tag = 601;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}
-(void)changeAlert{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"修改提示文字" message:self.recommend_title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
    alert.tag = 602;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}
//选择图片更换大图
-(void)chooseNewPic{
    _chooseAcs=[[UIActionSheet alloc]initWithTitle:@"自由环球租赁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选",@"拍摄一张", nil];
    [_chooseAcs showFromTabBar:self.tabBarController.tabBar];
    
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 600) {
        if (buttonIndex == 1) {
            UITextField *nameField=[alertView textFieldAtIndex:0];
            [self setAvartarImage:nil groupName:nameField.text desSub:nil alertTitle:nil color_index:nil type:2];
        }
    }else if(alertView.tag == 601){
        if (buttonIndex == 1) {
            UITextField *nameField=[alertView textFieldAtIndex:0];
            [self setAvartarImage:nil groupName:nil desSub:nameField.text alertTitle:nil color_index:nil type:3];
        }

    }else if (alertView.tag == 602){
        if (buttonIndex == 1) {
            UITextField *nameField=[alertView textFieldAtIndex:0];
            [self setAvartarImage:nil groupName:nil desSub:nil alertTitle:nameField.text color_index:nil type:4];
        }

        
    }
}
#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _imagePicker=[[UIImagePickerController alloc]init];
    if (buttonIndex==0) {
        //从相册选取
        //        _isCamera=0;
        _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing=YES;
        _imagePicker.delegate=self;
        [self.navigationController presentViewController:_imagePicker animated:YES completion:^{}];
    }else if(buttonIndex==1){
        //拍摄一张
        //        _isCamera=1;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            _imagePicker.delegate=self;
            _imagePicker.allowsEditing=YES;
            [self.navigationController presentViewController:_imagePicker animated:YES completion:^{}];
        }else{
            [BBSAlert showAlertWithContent:@"相机设备不可用" andDelegate:self];
        }
    }
    [_chooseAcs dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark UIImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //isEditingAvatar = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self setAvartarImage:image groupName:nil desSub:nil alertTitle:nil color_index:nil type:1];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}
/**
 *  更改头部信息
 *
 *  @param image       大图
 *  @param groupName   群名字
 *  @param desSub      群描述
 *  @param alertTitle  提示的title
 *  @param color_index 字体颜色
 *  @param type        改了什么1、大图 2、名字 3、简介 4、提示 5、文字颜色
 */
-(void)setAvartarImage:(UIImage *) image groupName:(NSString*)groupName desSub:(NSString*)desSub alertTitle:(NSString*)alertTitle color_index:(NSString*)color_index type:(NSInteger)type{
    if (type == 1) {
        self.pictureImg = image;
    }else if (type == 2){
        self.groupName = groupName;
    }else if(type == 3){
        self.desSub = desSub;
    }else if(type == 4){
        self.recommend_title = alertTitle;
    }else{
        self.color_index = color_index;
        _isColorSet = YES;
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:self.pictureImg forKey:@"cover"];
    [param setObject:[NSString stringWithFormat:@"%ld",self.groupId] forKey:@"group_id"];
    [param setObject:self.groupName forKey:@"group_name"];
    [param setObject:self.desSub forKey:@"description"];
    [param setObject:self.recommend_title forKey:@"recommend_title"];
    [param setObject:self.color_index forKey:@"color_index"];

    
    NetAccess *netAccess=[NetAccess sharedNetAccess];
    [netAccess getDataWithStyle:NetStyleEditGroupHead andParam:param];


}
-(void)editGroupSucceed{
    if (self.isColorSet == YES) {
        [BBSAlert showAlertWithContent:@"颜色设置成功" andDelegate:self];
        self.isColorSet = NO;
    }
    self.picImg.image = self.pictureImg;
    self.nameLabel.text = self.groupName;
    self.subTitleLabel.text = self.desSub;
    self.alerMessLabel.text = self.recommend_title;
}
-(void)editGroupFail:(NSNotification*)note{
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:note.object andDelegate:self];

}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}



-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
