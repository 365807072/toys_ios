//
//  BBSNavigationControllerNotTurn.m
//  BabyShow
//
//  Created by Lau on 14-2-18.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BBSNavigationControllerNotTurn.h"

@interface BBSNavigationControllerNotTurn ()

@end

@implementation BBSNavigationControllerNotTurn

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
        
        UIColor * color = [UIColor whiteColor];
        UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,font,NSFontAttributeName,nil];
        self.navigationBar.titleTextAttributes = dict;

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
