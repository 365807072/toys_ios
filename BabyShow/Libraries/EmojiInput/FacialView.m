//
//  FacialView.m
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacialView.h"


@implementation FacialView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        faces=[Emoji allEmoji];
        emojiDictionary = [Emoji allEmojiDictionary];
    }
    return self;
}
//键盘一页表情,4行9列
-(void)loadFacialView:(int)page size:(CGSize)size
{
	//row number
	for (int i=0; i<4; i++) {
		//column numer
		for (int y=0; y<9; y++) {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
            if (i==3&&y==8) {//一页的最后一个
                [button setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
                button.tag=10000;
                
            }else{
                if (i*9+y+(page*35)>102) {
                    continue;
                }
                UIImage *image = [UIImage imageNamed:[emojiDictionary valueForKey:[faces objectAtIndex:i*9+y+(page*35)]]];
                [button setImage:image forState:UIControlStateNormal] ;
                button.tag=i*9+y+(page*35);
                
            }
			[button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		}
	}
}

//删除的button是删除,其他是各自的表情[微笑]
-(void)selected:(UIButton*)bt
{
    if (bt.tag==10000) {
        [delegate selectedFacialView:@"删除" emojiArray:faces];
    }else{
        NSString *str=[faces objectAtIndex:bt.tag];
//        NSLog(@"点击其他%@",str);
        [delegate selectedFacialView:str emojiArray:faces];
    }	
}

@end
