//
//  PostBarDetailDescribeCell.m
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailDescribeCell.h"

@implementation PostBarDetailDescribeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect describeLabelFrame=CGRectMake(10*0.6, 7,SCREENWIDTH-10*0.6*2,20);
        self.describeLabel=[[NIAttributedLabel alloc]initWithFrame:describeLabelFrame];
        self.describeLabel.font=[UIFont systemFontOfSize:16];
        self.describeLabel.numberOfLines=0;
        self.describeLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.describeLabel.textColor = [BBSColor hexStringToColor:@"494949"];
        [self.contentView addSubview:self.describeLabel];
        
        self.emojiLabel=[[EmojiLabel alloc]initWithFrame:describeLabelFrame];
        self.emojiLabel.font=[UIFont systemFontOfSize:16];
        self.emojiLabel.numberOfLines=0;
        self.emojiLabel.lineBreakMode=NSLineBreakByWordWrapping;
        
        self.emojiLabel.textColor = [BBSColor hexStringToColor:@"494949"];
        self.emojiLabel.backgroundColor = [UIColor redColor];
       // [self.contentView addSubview:self.emojiLabel];

    
    }
    return self;
}

-(void)resetLabelFrameWithContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:5];
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREENWIDTH-10*0.6*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    if (height < 19.087999) {
        height = 20;
    }
    

}

@end
