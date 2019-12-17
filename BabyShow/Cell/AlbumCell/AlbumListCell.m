//
//  AlbumListCell.m
//  BabyShow
//
//  Created by Lau on 14-1-6.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AlbumListCell.h"

@implementation AlbumListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[BBSColor hexStringToColor:@"f9f3f3"];
        self.albumCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        self.albumCoverImageView.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:self.albumCoverImageView];
        
        self.albumCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(5, 45+5, 60, 15)];
        self.albumCountLabel.backgroundColor =[UIColor clearColor];
        self.albumCountLabel.textColor =[UIColor whiteColor];
        self.albumCountLabel.font =[UIFont systemFontOfSize:12.0];
        self.albumCountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.albumCountLabel];
        
        self.albumNameLabel  =[[UILabel alloc] initWithFrame:CGRectMake(70, 5, 180, 30)];
        self.albumNameLabel.textColor =[UIColor blackColor];
        self.albumNameLabel.font =[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:self.albumNameLabel];
        
        self.albumCreatetimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(70, 50, 150, 15)];
        self.albumCreatetimeLabel.textColor =[UIColor grayColor];
        self.albumCreatetimeLabel.font =[UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.albumCreatetimeLabel];

        //没有描述这个东西了,其所在的位置代替为时间
        self.albumDescriptionLabel =[[UILabel alloc] initWithFrame:CGRectMake(70, 25, 150, 15)];
        self.albumDescriptionLabel.textColor =[UIColor blackColor];
        self.albumDescriptionLabel.font =[UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.albumDescriptionLabel];
        
        self.seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        self.seperatorView.backgroundColor =[BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:self.seperatorView];
        
    }
    return self;
}
- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		self.m_checkImageView.center = pt;
		self.m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		self.m_checkImageView.center = pt;
		self.m_checkImageView.alpha = alpha;
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
	if (self.editing == editting) {
		return;
	}
	
	[super setEditing:editting animated:animated];
	
	if (editting) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = [[UIView alloc] init];
//		self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.backgroundColor = [BBSColor hexStringToColor:@"f9f3f3"];
		
		if (self.m_checkImageView == nil) {
			self.m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_unchecked"]];
			[self addSubview:self.m_checkImageView];
		}
		
		[self setChecked:m_checked];
		self.m_checkImageView.center = CGPointMake(-CGRectGetWidth(self.m_checkImageView.frame) * 0.5,CGRectGetHeight(self.bounds) * 0.5);
		self.m_checkImageView.alpha = 0.0;
		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)alpha:1.0 animated:animated];
	} else {
		m_checked = NO;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = nil;
		
		if (self.m_checkImageView) {
			[self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(self.m_checkImageView.frame) * 0.5,CGRectGetHeight(self.bounds) * 0.5) alpha:0.0 animated:animated];
		}
	}
}

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		self.m_checkImageView.image = [UIImage imageNamed:@"img_checked"];
		self.backgroundView.backgroundColor = [UIColor clearColor];
	}
	else
	{
		self.m_checkImageView.image = [UIImage imageNamed:@"img_unchecked"];
//		self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.backgroundColor = [BBSColor hexStringToColor:@"f9f3f3"];
	}
	m_checked = checked;
}


@end
