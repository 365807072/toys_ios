//
//  DescriptionCell.m
//  BabyShow
//
//  Created by Lau on 6/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBDescriptionCell.h"

@implementation PBDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect descriptionFrame=CGRectMake(5, 0, 300, 20);
        self.descriptionLabel=[[UILabel alloc]initWithFrame:descriptionFrame];
        self.descriptionLabel.textColor=[BBSColor hexStringToColor:@"#5b5b5b"];
        self.descriptionLabel.font=[UIFont systemFontOfSize:15];
        self.descriptionLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        self.descriptionLabel.numberOfLines=2;
        [self.groundview addSubview:self.descriptionLabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
