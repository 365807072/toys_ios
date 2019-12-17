//
//  BBSNavigationController.m
//  BabyShow
//
//  Created by Lau on 14-2-17.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BBSNavigationController.h"

@interface BBSNavigationController ()

@end

@implementation BBSNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBar.barTintColor = [BBSColor hexStringToColor:@"fd6363"];
        
        UIColor * color = [UIColor whiteColor];
        UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,font,NSFontAttributeName,nil];
        self.navigationBar.titleTextAttributes = dict;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

@end
