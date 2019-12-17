//

#import <UIKit/UIKit.h>

@interface XSMediaPlayerMaskView : UIView


/** 开始播放按钮 */
@property (strong, nonatomic)  UIButton       *startBtn;
/** 当前播放时长label */
@property (strong, nonatomic)  UILabel        *currentTimeLabel;
/** 视频总时长label */
@property (strong, nonatomic)  UILabel        *totalTimeLabel;
/** 缓冲进度条 */
@property (strong, nonatomic)  UIProgressView *progressView;
/** 滑杆 */
@property (strong, nonatomic)  UISlider       *videoSlider;
/** 全屏按钮 */
@property (strong, nonatomic)  UIButton       *fullScreenBtn;
@property (strong, nonatomic)  UIButton       *lockBtn;
/** 音量进度 */
@property (nonatomic,strong) UIProgressView   *volumeProgress;

/** 系统菊花 */
@property (nonatomic,strong)UIActivityIndicatorView *activity;
@property(nonatomic,strong)UIButton *playbtn;
@property(nonatomic,strong)UIButton *backBtn;//全屏模式下的点击返回小屏模式
@property(nonatomic,strong)UIButton *backTextBtn;//全屏模式下的视频文字
@property(nonatomic,strong)UIButton *backBtnSmall;//小屏的时候的返回
@property(nonatomic,strong)UIButton *shareBtn;//分享按钮;





@end
