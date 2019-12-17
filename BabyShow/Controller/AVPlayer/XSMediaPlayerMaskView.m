
#import "XSMediaPlayerMaskView.h"
#import <AVFoundation/AVFoundation.h>

@interface XSMediaPlayerMaskView ()

/** bottom渐变层*/
@property (nonatomic, strong) CAGradientLayer *bottomGradientLayer;
/** top渐变层 */
@property (nonatomic, strong) CAGradientLayer *topGradientLayer;
/** bottomView*/
@property (strong, nonatomic  )  UIImageView     *bottomImageView;
/** topView */
@property (strong, nonatomic  )  UIImageView     *topImageView;
@property(nonatomic,assign)CGRect frameView;

@end

@implementation XSMediaPlayerMaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topImageView = [[UIImageView alloc]init];
        self.bottomImageView = [[UIImageView alloc]init];
        self.bottomImageView.userInteractionEnabled = YES;
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
        self.backBtn.frame = CGRectMake(20, 20, 30, 20);
        self.backBtn.hidden = YES;
        [self addSubview:self.backBtn];
        self.backTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backTextBtn.frame = CGRectMake(42, 20, 300, 20);
        self.backTextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        self.backTextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.backTextBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.backTextBtn.hidden = YES;
        [self addSubview:self.backTextBtn];
        
        
        self.backBtnSmall = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtnSmall setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
        self.backBtnSmall.frame = CGRectMake(20, 20, 35, 20);
        self.backBtnSmall.hidden = YES;
        [self addSubview:self.backBtnSmall];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.shareBtn.frame = CGRectMake(SCREENWIDTH-28, 15, 18, 18);
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_new_toy_share"] forState:UIControlStateNormal];
        self.shareBtn.hidden = YES;
        [self  addSubview:self.shareBtn];
        
        
        self.startBtn = [[UIButton alloc]initWithFrame:CGRectMake(7,9,10,10)];
        [self.startBtn setImage:[UIImage imageNamed:@"babyshow_player"] forState:UIControlStateNormal];
        [self.startBtn setImage:[UIImage imageNamed:@"babyshow_pause"] forState:UIControlStateSelected];
        
        self.playbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playbtn.frame = CGRectMake(7,9,55,20);
        
        self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.startBtn.frame.origin.x+self.startBtn.frame.size.width+2, 5,45, 20)];
        self.currentTimeLabel.textColor = [UIColor whiteColor];
        self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.currentTimeLabel.font = [UIFont systemFontOfSize:10];
        
        self.totalTimeLabel = [[UILabel alloc]init];
        self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.totalTimeLabel.font = [UIFont systemFontOfSize:10];
        self.totalTimeLabel.textColor = [UIColor whiteColor];
    
        self.progressView = [[UIProgressView alloc]init];
        self.progressView.trackTintColor       = [UIColor clearColor];
        
        self.volumeProgress = [[UIProgressView alloc]init];
        self.volumeProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.volumeProgress.progressTintColor    = [UIColor whiteColor];
        self.volumeProgress.trackTintColor       = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        // 设置slider
        self.videoSlider = [[UISlider alloc]init];
        [self.videoSlider setThumbImage:[UIImage imageNamed:@"babyshow_slider"] forState:UIControlStateNormal];
        self.videoSlider.minimumTrackTintColor = [BBSColor hexStringToColor:@"fc6972"];;
        self.videoSlider.maximumTrackTintColor = [BBSColor hexStringToColor:@"828282"];
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        // 初始化渐变层
        [self initCAGradientLayer];
        //全屏按钮
        self.fullScreenBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"player_big_btn"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"player_small_btn"] forState:UIControlStateSelected];

        
        self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.playbtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self addSubview:self.volumeProgress];
        [self addSubview:self.activity];
        self.frame = frame;
        
        NSError *error;
        
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        // add event handler, for this example, it is `volumeChange:` method
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        
        
    }
    return self;
}


- (void)volumeChanged:(NSNotification *)notification
{
    // service logic here.
    NSLog(@"%@",notification.userInfo);
    NSString *valueStr = notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"];
    self.volumeProgress.progress = [valueStr floatValue];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    //头部
    self.topImageView.frame = CGRectMake(0, 0,width, 20);
    
    //底部
    self.bottomImageView.frame = CGRectMake(0,self.frame.size.height-30, width, 30);
    self.bottomGradientLayer.frame = self.bottomImageView.bounds;
    self.topGradientLayer.frame    = self.topImageView.bounds;
    
    
    self.progressView.frame = CGRectMake(self.currentTimeLabel.frame.origin.x+self.currentTimeLabel.frame.size.width+5, self.currentTimeLabel.frame.origin.y+7, self.bounds.size.width-self.currentTimeLabel.frame.origin.x-self.currentTimeLabel.frame.size.width-5-75, 20);
    self.totalTimeLabel.frame =  CGRectMake(self.progressView.frame.origin.x+self.progressView.frame.size.width+7, self.currentTimeLabel.frame.origin.y, 45, 20);

    self.videoSlider.frame = CGRectMake(self.currentTimeLabel.frame.origin.x+self.currentTimeLabel.frame.size.width+5, self.currentTimeLabel.frame.origin.y, self.bounds.size.width-self.currentTimeLabel.frame.origin.x-self.currentTimeLabel.frame.size.width-5-75, 20);
    
    self.fullScreenBtn.frame = CGRectMake(self.totalTimeLabel.frame.origin.x+self.totalTimeLabel.frame.size.width+2, self.totalTimeLabel.frame.origin.y, 18, 18);
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"player_big_btn"] forState:UIControlStateNormal];
    
    self.activity.center = CGPointMake(width/2, height/2);
    
}

- (void)initCAGradientLayer
{
    //初始化Bottom渐变层
    self.bottomGradientLayer            = [CAGradientLayer layer];
    [self.bottomImageView.layer addSublayer:self.bottomGradientLayer];
    //设置渐变颜色方向
    self.bottomGradientLayer.startPoint = CGPointMake(0, 0);
    self.bottomGradientLayer.endPoint   = CGPointMake(0, 1);
    //设定颜色组
    self.bottomGradientLayer.colors     = @[(__bridge id)[UIColor clearColor].CGColor,
                                            (__bridge id)[UIColor blackColor].CGColor];
    //设定颜色分割点
    self.bottomGradientLayer.locations  = @[@(0.0f) ,@(1.0f)];
    
    
    //初始Top化渐变层
    self.topGradientLayer               = [CAGradientLayer layer];
    [self.topImageView.layer addSublayer:self.topGradientLayer];
    //设置渐变颜色方向
    self.topGradientLayer.startPoint    = CGPointMake(1, 0);
    self.topGradientLayer.endPoint      = CGPointMake(1, 1);
    //设定颜色组
    self.topGradientLayer.colors        = @[ (__bridge id)[UIColor blackColor].CGColor,
                                             (__bridge id)[UIColor clearColor].CGColor];
    //设定颜色分割点
    self.topGradientLayer.locations     = @[@(0.0f) ,@(1.0f)];
    
}


-(void)dealloc
{
    NSLog(@"%s",__func__);
    
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    

}

@end
