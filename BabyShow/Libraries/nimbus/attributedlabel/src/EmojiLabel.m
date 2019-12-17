//
//  EmojiLabel.m
//  BabyShow
//
//  Created by WMY on 16/4/28.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EmojiLabel.h"
typedef enum {
    NIVerticalTextAlignmentTopE = 0,
    NIVerticalTextAlignmentMiddleE,
    NIVerticalTextAlignmentBottomE,
} NIVerticalTextAlignmentEmoji;
@interface NIAttributedLabelImages : NSObject

- (CGSize)boxSize; // imageSize + margins

@property (nonatomic)           NSInteger     index;
@property (nonatomic, strong)   UIImage*      image;
@property (nonatomic)           UIEdgeInsets  margins;

@property (nonatomic) NIVerticalTextAlignmentEmoji verticalTextAlignment;

@property (nonatomic) CGFloat fontAscent;
@property (nonatomic) CGFloat fontDescent;

@end

@implementation NIAttributedLabelImages

- (CGSize)boxSize {
    return CGSizeMake(self.image.size.width + self.margins.left + self.margins.right,
                      self.image.size.height + self.margins.top + self.margins.bottom);
}

@end


@implementation EmojiLabel
- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins {
    [self insertImage:image atIndex:index margins:margins verticalTextAlignment:NIVerticalTextAlignmentBottomE];
}
- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins verticalTextAlignment:(NIVerticalTextAlignmentEmoji)verticalTextAlignment {
    NIAttributedLabelImages* labelImage = [[NIAttributedLabelImages alloc] init];
    labelImage.index = index;
    labelImage.image = image;
    labelImage.margins = margins;
    labelImage.verticalTextAlignment = verticalTextAlignment;
    if (nil == self.images) {
        self.images = [NSMutableArray array];
    }
    NSLog(@"labelImg = %@",labelImage.image);
    [self.images addObject:labelImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
