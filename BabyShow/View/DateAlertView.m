//
//  DateAlertView.m
//  BabyShow
//
//  Created by Monica on 15-2-5.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DateAlertView.h"

@interface DateAlertView ()<UITextFieldDelegate>


@end

@implementation DateAlertView
static const NSUInteger kAlertViewTag = 1338;

#define CancelTag       100
#define DoneTag         101

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //create the final view with a special tag
        self.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.1];
        
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 280/2,
                                                                     frame.size.height/2 - 130,
                                                                     280, 130)];
        alertView.tag = kAlertViewTag; //set tag to retrieve later
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 5;
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 30)];
        hintLabel.text = @"请选择";
        hintLabel.font = [UIFont systemFontOfSize:17];
        hintLabel.textColor = [BBSColor hexStringToColor:NAVICOLOR];
        hintLabel.backgroundColor = [UIColor clearColor];
        [alertView addSubview:hintLabel];
        
        _segControl = [[UISegmentedControl alloc] initWithItems:@[@"出生后", @"出生前"]];
        _segControl.frame = CGRectMake(90, 7.5, 100, 25);
        [_segControl setSelectedSegmentIndex:0];
        [_segControl setTintColor:[BBSColor hexStringToColor:NAVICOLOR]];
        [alertView addSubview:_segControl];
        
        _yearTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 45, 65, 30)];
        _yearTF.borderStyle = UITextBorderStyleRoundedRect;
        _yearTF.keyboardType = UIKeyboardTypeNumberPad;
        [alertView addSubview:_yearTF];
        
        _monthTF = [[UITextField alloc] initWithFrame:CGRectMake(95, 45, 65, 30)];
        _monthTF.borderStyle = UITextBorderStyleRoundedRect;
        _monthTF.placeholder = @"0~11";
        _monthTF.delegate = self;
        _monthTF.keyboardType = UIKeyboardTypeNumberPad;
        [alertView addSubview:_monthTF];
        
        _dayTF = [[UITextField alloc] initWithFrame:CGRectMake(185, 45, 65, 30)];
        _dayTF.borderStyle = UITextBorderStyleRoundedRect;
        _dayTF.placeholder = @"0~30";
        _dayTF.delegate = self;
        _dayTF.keyboardType = UIKeyboardTypeNumberPad;
        [alertView addSubview:_dayTF];
        
        UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 50, 17, 20)];
        yearLabel.text = @"岁";
        yearLabel.font = [UIFont systemFontOfSize:16];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.textColor = [UIColor redColor];
        yearLabel.backgroundColor = [UIColor clearColor];
        [alertView addSubview:yearLabel];
        
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 50, 17, 20)];
        monthLabel.text = @"月";
        monthLabel.font = [UIFont systemFontOfSize:16];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.textColor = [UIColor redColor];
        monthLabel.backgroundColor = [UIColor clearColor];
        [alertView addSubview:monthLabel];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 50, 17, 20)];
        dayLabel.text = @"天";
        dayLabel.font = [UIFont systemFontOfSize:16];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = [UIColor redColor];
        dayLabel.backgroundColor = [UIColor clearColor];
        [alertView addSubview:dayLabel];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(50, 85, 60, 25);
        [closeButton setTintColor:[UIColor whiteColor]];
        [closeButton setBackgroundColor:[UIColor lightGrayColor]];
        [closeButton setTitle:@"取消" forState:UIControlStateNormal];
        closeButton.layer.masksToBounds = YES;
        closeButton.layer.cornerRadius = 5;
        [closeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        closeButton.tag = CancelTag;
        [closeButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:closeButton];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(170, 85, 60, 25);
        [doneButton setTintColor:[UIColor whiteColor]];
        [doneButton setBackgroundColor:[BBSColor hexStringToColor:NAVICOLOR]];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        doneButton.layer.masksToBounds = YES;
        doneButton.layer.cornerRadius = 5;
        [doneButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        doneButton.tag = DoneTag;
        [doneButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:doneButton];
        
        [self addSubview:alertView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlertByTap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGesture];
    
    }
    return self;
}

- (void)hideAlertByTap:(UITapGestureRecognizer *)sender {
    [self fadeOutView:sender.view
           completion:^(BOOL finished) {
               [sender.view  removeFromSuperview];
           }];
}
- (void)clickedButton:(UIButton *)button {
    
    if (button.tag == DoneTag) {
    
        if ((_yearTF.text == 0 || _yearTF.text.length <= 0) && (_monthTF.text == 0 || _monthTF.text.length <= 0) && (_dayTF.text == 0 || _dayTF.text.length <= 0)) {
            [BBSAlert showAlertWithContent:@"不能全为空哦" andDelegate:nil];
            return;
        }
        
        NSString *returnStr = [self formatStrWithYear:_yearTF.text month:_monthTF.text day:_dayTF.text];
        if ([self.delegate respondsToSelector:@selector(getTimeInfo:)]) {
            [self.delegate getTimeInfo:returnStr];
        }
    }
    [self fadeOutView:self completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [view setAlpha:0.0];
                     }
                     completion:completion];
}

- (NSString *)formatStrWithYear:(NSString *)yearS month:(NSString *)monthS day:(NSString *)dayS {
    NSString *returnString = nil;
    
    if (yearS.length <= 0 || [yearS isEqualToString:@"0"]) {
        //无年
        if (monthS.length <= 0 || [monthS isEqualToString:@"0"]) {
            //无月
            if (dayS.length <= 0 || [dayS isEqualToString:@"0"]) {
                //无日
                //这种情况不对
                returnString = @"";
            } else {
                //有日
                returnString = [NSString stringWithFormat:@"%@天",dayS];
            }
        } else {
            //有月
            if (dayS.length <= 0 || [dayS isEqualToString:@"0"]) {
                //无日
                returnString = [NSString stringWithFormat:@"%@个月",monthS];

            } else {
                //有日
                returnString = [NSString stringWithFormat:@"%@个月%@天",monthS,dayS];

            }
        }
    } else {
        //有年
        
        if (monthS.length <= 0 || [monthS isEqualToString:@"0"]) {
            //无月
            if (dayS.length <= 0 || [dayS isEqualToString:@"0"]) {
                //无日
                returnString = [NSString stringWithFormat:@"%@岁",yearS];

            } else {
                //有日
                returnString = [NSString stringWithFormat:@"%@岁零%@天",yearS,dayS];

            }
        } else {
            //有月
            if (dayS.length <= 0 || [dayS isEqualToString:@"0"]) {
                //无日
                returnString = [NSString stringWithFormat:@"%@岁%@个月",yearS,monthS];

            } else {
                //有日
                returnString = [NSString stringWithFormat:@"%@岁%@个月%@天",yearS,monthS,dayS];

            }
        }
    }
    if (_segControl.selectedSegmentIndex == 1) {
        //出生前
        returnString = [returnString stringByReplacingOccurrencesOfString:@"岁" withString:@"年"];
        returnString = [NSString stringWithFormat:@"出生前%@",returnString];
    }
    
    return returnString;
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _monthTF) {
        if ([[textField.text stringByAppendingString:string] integerValue] > 11) {
            return NO;
        }
        return YES;
    }
    if (textField == _dayTF) {
        if ([[textField.text stringByAppendingString:string] integerValue] > 30) {
            return NO;
            
        }
        return YES;
    }
    return YES;
}

@end
