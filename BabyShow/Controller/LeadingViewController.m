//
//  LeadingViewController.m
//  BabyShow
//
//  Created by 于 晓波 on 15/4/26.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LeadingViewController.h"

@interface LeadingViewController ()

@end

@implementation LeadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index=1;
    
    [self setPhotosData];
    [self setImageView];
    
    
}

#pragma mark UI

-(void)setImageView{
    
    self.imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView.userInteractionEnabled=YES;
    self.imageView.image=[self.photosArray objectAtIndex:0];
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playNext)];
    [self.imageView addGestureRecognizer:tap];
    
    
}

-(void)playNext{
    
    if (_index < self.photosArray.count) {
        
        UIImage *image=[self.photosArray objectAtIndex:_index];
        self.imageView.image=image;
        _index++;
        
    }else{
        
        AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [del setBBSTabBarController];
        [del.tabbarcontroller setBBStabbarSelectedIndex:0];
        
    }
    
}

#pragma mark Data

-(void)setPhotosData{
    
    self.photosArray=[NSMutableArray array];
    
    if (SCREENWIDTH==320 && SCREENHEIGHT==480 ) {
        
        //3.5
        for (int i=1; i<5; i++) {
            
            NSString *fileName=[NSString stringWithFormat:@"img_leading350%d",i];
            UIImage *image=[UIImage imageNamed:fileName];
            [self.photosArray addObject:image];
            
        }
        
    }else if (SCREENWIDTH==320 && SCREENHEIGHT==568){
        
        //4.0
        for (int i=1; i<5; i++) {

            NSString *fileName=[NSString stringWithFormat:@"img_leading400%d",i];
            UIImage *image=[UIImage imageNamed:fileName];
            [self.photosArray addObject:image];
        
        }
        
    }else if (SCREENWIDTH==375 && SCREENHEIGHT==667){
        
        //6
        for (int i=1; i<5; i++) {
            
            NSString *fileName=[NSString stringWithFormat:@"img_leading600%d",i];
            UIImage *image=[UIImage imageNamed:fileName];
            [self.photosArray addObject:image];
            
        }
        
    }else if (SCREENWIDTH==414 && SCREENHEIGHT==736){
        
        //6+
        for (int i=1; i<5; i++) {
            
            NSString *fileName=[NSString stringWithFormat:@"img_leading6p0%d",i];
            UIImage *image=[UIImage imageNamed:fileName];
            [self.photosArray addObject:image];
            
        }
        
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
