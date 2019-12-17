//
//  MoreSpecialTableViewCell.m
//  BabyShow
//
//  Created by Monica on 15-5-14.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MoreSpecialTableViewCell.h"

@implementation MoreSpecialTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8+1, 200, 18)];
        self.nameLabel.font = [UIFont systemFontOfSize:17];
        self.nameLabel.textColor = KColorRGB(0, 0, 0, 1);
        //self.nameLabel.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.imageViewMore = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10, 10+1, 8, 13)];
        self.imageViewMore.image = [UIImage imageNamed:@"img_special_more@2x.png"];
        [self.contentView addSubview:self.imageViewMore];
        
        self.countOfPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-17-100, 8+1, 100, 18)];
        self.countOfPeopleLabel.font = [UIFont systemFontOfSize:15];
        self.countOfPeopleLabel.textColor = KColorRGB(173, 173, 173, 1);
        
        self.countOfPeopleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.countOfPeopleLabel];
        
        self.firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30+1, (SCREENWIDTH-10-15)/4, (SCREENWIDTH-10-15)/4)];
       // self.firstImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.firstImageView];
        
        self.secondImageView= [[UIImageView alloc]initWithFrame:CGRectMake(5+5+(SCREENWIDTH-10-15)/4, 30+1, (SCREENWIDTH-10-15)/4, (SCREENWIDTH-10-15)/4)];
        //self.secondImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.secondImageView];
        
        self.thirdImageView= [[UIImageView alloc]initWithFrame:CGRectMake(5+5+5+(SCREENWIDTH-10-15)*2/4, 30+1, (SCREENWIDTH-10-15)/4, (SCREENWIDTH-10-15)/4)];
        //self.thirdImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.thirdImageView];
        
        self.fourImageView= [[UIImageView alloc]initWithFrame:CGRectMake(5+5+5+5+(SCREENWIDTH-10-15)*3/4, 30+1, (SCREENWIDTH-10-15)/4, (SCREENWIDTH-10-15)/4)];
        //self.fourImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.fourImageView];
        
         UILabel *gryBarView = [[UILabel alloc]initWithFrame:CGRectMake(0, 35+(SCREENWIDTH-10-15)/4, SCREENWIDTH, 5)];
            gryBarView.backgroundColor = KColorRGB(242, 242, 242, 1);
        
       [self.contentView addSubview:gryBarView];
    }
    
    
    return self;
    
}
-(void)setMoreSpecialModel:(MoreSpecialModel *)moreSpecialModel
{
    if (_moreSpecialModel == moreSpecialModel) {
        return;
    }
    _moreSpecialModel = moreSpecialModel;
    self.nameLabel.text = moreSpecialModel.cate_name;
    self.countOfPeopleLabel.text = [NSString stringWithFormat:@"共%ld人参与",(long)moreSpecialModel.renshu];
    
}



@end
