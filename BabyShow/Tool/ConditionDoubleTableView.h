//
//  ConditionDoubleTableView.h
//  MacauFood
//
//  Created by Ryan Wong on 15/8/21.
//  Copyright (c) 2015年 tenfoldtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConditionDoubleTableViewDelegate <NSObject>

@required
- (void)selectedFirstValue:(NSString *)first SecondValue:(NSString *)second;
- (void)hideMenu;
-(void)setSeachResult:(NSString*)businessTitle;
@end

@interface ConditionDoubleTableView : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate> {
    UIView *_rootView;
    
    UITableView *_firstTableView;
    UITableView *_secondTableView;
    
    NSArray *_leftItems;
    NSArray *_rightItems;
    NSArray *_leftArray;
    NSArray *_rightArray;
    
    NSInteger firstSelectedIndex;
    NSInteger secondSelectedIndex;
    
    NSInteger _buttonIndex;
    
    BOOL isHidden;
    UISearchBar *theSearchBar;//搜索的bar

}

@property (nonatomic, strong) id <ConditionDoubleTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL isHiddenInStoreList;
@property(nonatomic,strong)UIView *seachView;


//初始化下拉菜单
- (id)initWithFrame:(CGRect)frame andLeftItems:(NSArray *)leftItems andRightItems:(NSArray *)RightItems;
//显示下拉菜单
- (void)showTableView:(NSInteger)index WithSelectedLeft:(NSString *)left Right:(NSString *)right;
- (void)hideTableView;

@end
