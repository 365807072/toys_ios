//
//  PostBarDetailTitleCell.m
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailTitleCell.h"

@implementation PostBarDetailTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect titleLabelFrame=CGRectMake(6, 8, SCREENWIDTH-12, 0);
        self.titleLabel=[[UILabel alloc]initWithFrame:titleLabelFrame];
        self.titleLabel.numberOfLines=0;
        self.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
        self.titleLabel.textColor = [BBSColor hexStringToColor:@"212121"];
        [self.contentView addSubview:self.titleLabel];
    
    }
    return self;
}

-(void)resetFrameWithContent:(NSString *) content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    
    self.titleLabel.frame=CGRectMake(6, 8, SCREENWIDTH-12, height);
    
}

@end
