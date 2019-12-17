//
//  AnimationType.m
//  BabyShow
//
//  Created by Lau on 4/18/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "AnimationType.h"

@implementation AnimationType

+(NSString *)randomAnimationTypeString{
    
    NSArray *typeArray=[NSArray arrayWithObjects:
                        kCATransitionPush,
                        @"cube",
                        @"moveIn",
                        @"reveal",
                        @"fade",
                        @"pageCurl",
                        @"pageUnCurl",
                        @"suckEffect",
                        @"rippleEffect",
                        @"oglFlip", nil];
    int count=(int)typeArray.count;
    int random=arc4random()%count;
    
    NSString *typeString=[NSString stringWithFormat:@"%@",[typeArray objectAtIndex:random]];
    
    if (!typeString) {
        
        return kCATransitionFade;
        
    }
    
    return typeString;
    
}


@end
