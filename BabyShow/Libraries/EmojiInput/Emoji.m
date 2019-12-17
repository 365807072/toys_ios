//
//  Emoji.m
//  Emoji
//
//  Created by Aliksandr Andrashuk on 26.10.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#import "Emoji.h"

@implementation Emoji
+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}
+ (NSArray *)allEmoji {

    NSString *path =[[NSBundle mainBundle]pathForResource:@"EmojiList" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
//    NSLog(@"%@",array);
    return array;
}
+(NSDictionary *)allEmojiDictionary{
    NSDictionary * emojis = [NSDictionary dictionaryWithContentsOfFile:
              [[NSBundle mainBundle] pathForResource:@"EmojiNameMap" ofType:@"plist"]];
    return emojis;

}
@end
