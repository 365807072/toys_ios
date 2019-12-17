//
//  PostBarNewReviewsUserCell.m
//  BabyShow
//
//  Created by WMY on 16/4/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewReviewsUserCell.h"

@implementation PostBarNewReviewsUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 0.5)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"dddddd"];
        [self.contentView addSubview:lineView];
        self.avatarBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.avatarBtn.frame = CGRectMake(15*0.6, 15, 32, 32);
        self.avatarBtn.layer.masksToBounds = YES;
        self.avatarBtn.layer.cornerRadius = 16.5;
        [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"img_myshow_section_avatar.png"] forState:UIControlStateNormal];
        [self.avatarBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarBtn];
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarBtn.frame.origin.x+self.avatarBtn.frame.size.width+15*0.6, self.avatarBtn.frame.origin.y, 250, 16)];
        self.userNameLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        self.userNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.userNameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, self.userNameLabel.frame.origin.y+self.userNameLabel.frame.size.height+2, 150, 12)];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.timeLabel];
        
        self.reviewBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.reviewBtn.frame = CGRectMake(SCREENWIDTH-15*0.6-30, 20, 16, 12);
        [self.reviewBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_detail_review"] forState:UIControlStateNormal];
        //self.reviewBtn.backgroundColor = [UIColor redColor];
        [self.reviewBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.reviewBtn];
        
        
        self.reviewCountBtn =  [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.reviewCountBtn.frame = CGRectMake(self.reviewBtn.frame.origin.x, self.reviewBtn.frame.origin.y,36, 12);
        [self.reviewCountBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.reviewCountBtn];

        self.reviewCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.reviewBtn.frame.origin.x+self.reviewBtn.frame.size.width, self.reviewBtn.frame.origin.y, 20, 10)];
        self.reviewCountLabel.textAlignment = NSTextAlignmentLeft;
        self.reviewCountLabel.textColor =[BBSColor hexStringToColor:@"999999"];
        self.reviewCountLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.reviewCountLabel];

        
        
        self.admireBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.admireBtn.frame = CGRectMake(self.reviewBtn.frame.origin.x-40, self.reviewBtn.frame.origin.y-1, 17, 12);

        [self.contentView addSubview:self.admireBtn];
        
        self.admireCountBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.admireCountBtn.frame = CGRectMake(self.admireBtn.frame.origin.x, self.reviewBtn.frame.origin.y-10, 30, 30);
        [self.admireCountBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
         [self.contentView addSubview:self.admireCountBtn];

        self.admireCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.admireBtn.frame.origin.x+self.admireBtn.frame.size.width, self.reviewBtn.frame.origin.y, 20, 10)];
        self.admireCountLabel.textColor =[BBSColor hexStringToColor:@"999999"];
        self.admireCountLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.admireCountLabel];
        
    
    }
    return self;
}
-(void)OnClick:(btnWithIndexPath *) sender{
    if (sender==self.admireBtn || sender == self.admireCountBtn) {
        
        if ([self.delegate respondsToSelector:@selector(praise:)]) {
            [self.delegate praise:sender];
        }
        
    }else if (sender==self.reviewBtn||sender == self.reviewCountBtn){
        
        if ([self.delegate respondsToSelector:@selector(review:)]) {
            [self.delegate review:sender];
        }
        
    }else if (sender==self.avatarBtn){
        
        if ([self.delegate respondsToSelector:@selector(ClickOnTheAvatar:)]) {
            [self.delegate ClickOnTheAvatar:sender];
        }
        
    }

    
}

@end
