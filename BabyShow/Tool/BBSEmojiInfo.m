//
//  BBSEmojiInfo.m
//  BabyShow
//
//  Created by Mayeon on 14-2-28.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BBSEmojiInfo.h"

@implementation BBSEmojiInfo

+(NSDictionary *)detailContentWithStringAndEmoji:(NSString *)cont fromArray:(NSArray *)facesArray{
    NSMutableString *content = [NSMutableString stringWithString:cont];
    NSInteger length = content.length;
    NSMutableArray *numArray = [[NSMutableArray alloc]init];
    for (int i =0; i< length-3;i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *single = [content substringWithRange:range];
        if ([single isEqualToString:@"["]) {
            NSRange emojiRange = NSMakeRange(range.location, 4);
            NSString *emojiText = [content substringWithRange:emojiRange];
            if ([facesArray containsObject:emojiText]) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:emojiRange.location],@"location",emojiText,@"emojiText", nil];
                [numArray addObject:dict];
            }else{
                
            }
        }else{
            
        }
    }
    for (int i =0; i <numArray.count; i++) {
        NSDictionary *dict = [numArray objectAtIndex:i];
        int numid = [[dict objectForKey:@"location"] intValue];
        [content deleteCharactersInRange:NSMakeRange(numid-i*4, 4)];
    }
    //空字符串的话插入不了表情
    if (content.length <=0) {
        content = [NSMutableString stringWithString:@" "];
    }

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content",numArray,@"emoji", nil];
    return dict;
}

@end
