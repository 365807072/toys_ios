//
//  PBMakeAPostViewController.h
//  BabyShow
//
//  Created by Lau on 7/29/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostBarToolBarView.h"
#import "ELCImagePickerController.h"

enum ADDATOPICTYPE{
    ADDATOPICDEFAULT=0,
    ADDATOPICREPLY,
};

@interface PBMakeAPostViewController : UIViewController<UITextViewDelegate,
PostBarToolBarViewDelegate,
ELCImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSString *rootImgId;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *post_class;

-(void)makeImageViewsWithPhotosArray:(NSArray *) PhotoArray;

@end
