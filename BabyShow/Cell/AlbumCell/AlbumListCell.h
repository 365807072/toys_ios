//
//  AlbumListCell.h
//  BabyShow
//
//  Created by Lau on 14-1-6.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

//相册列表

#import <UIKit/UIKit.h>

@interface AlbumListCell : UITableViewCell
{
	BOOL			m_checked;                  // 是否选中
}
@property (nonatomic ,strong) UIImageView*	m_checkImageView;           // 选中的图片


@property (nonatomic ,strong) UIImageView *albumCoverImageView;     //相册封面ImageView
@property (nonatomic ,strong) UILabel *albumNameLabel ;             //相册名称Label
@property (nonatomic ,strong) UILabel *albumCreatetimeLabel;        //相册创建时间Label
@property (nonatomic ,strong) UILabel *albumDescriptionLabel;       //相册描述Label
@property (nonatomic ,strong) UILabel *albumCountLabel ;            //该相册包含的照片数目Label
@property (nonatomic ,strong) UIView *seperatorView;                //cell与cell的分割线
//@property (nonatomic ,strong) UIImageView *arrowView;


- (void) setChecked:(BOOL)checked;

@end
