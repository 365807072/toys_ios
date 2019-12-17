//
//  FacialView.h
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji.h"

@protocol FacialViewDelegate

-(void)selectedFacialView:(NSString*)str emojiArray:(NSArray *)array;

@end

//这是一页的表情
@interface FacialView : UIView {

//	id<facialViewDelegate>delegate;
	NSArray *faces;
    NSDictionary *emojiDictionary;
}
@property(nonatomic,assign)id<FacialViewDelegate>delegate;

-(void)loadFacialView:(int)page size:(CGSize)size;

@end
