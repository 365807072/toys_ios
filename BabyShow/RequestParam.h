//
//  RequestParam.h
//  BabyShow
//
//  Created by Monica on 14-11-18.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#ifndef BabyShow_RequestParam_h
#define BabyShow_RequestParam_h

#define Interface_Offline 1
#define Interface_Online  2

//切换接口
#define Current_Interface Interface_Online

//baobaoshowshow.com的域名都过期了耶

#if Current_Interface == Interface_Offline
//切换接口的时候记得调整友盟,测试关闭,正式打开
//测试环境 ,老版与优化新版同时使用，

#define kBasicUrlStr            @"http://test.show.baobaoshowshow.com/index.php?r=BabyShowV12/"
#define kNewBasicUrl            @"http://test.show.baobaoshowshow.com/index.php?r=BabyShow/"
#define kBasicUrlV1             @"http://test.show.baobaoshowshow.com/index.php?r=BabyShowV1/"
#define kImageBaseUrl           @"http://test.show.baobaoshowshow.com/"
#define BABYSHOWSUPERGRANTUSER  @"972"

#define AppShareUrl             @"http://test.show.baobaoshowshow.com/share_test.php?" //秀秀分享页面链接
#define PostShareUrl            @"http://test.show.baobaoshowshow.com/share_post.php?" //话题分享页面链接
#define BuyShareUrl             @"http://test.show.baobaoshowshow.com/share_buy.php?post_url=" //值得买分享链(错误的,测试服务器没有)
#define DiaryDetailShareUrl     @"http://test.show.baobaoshowshow.com/share_diary.php?"
#define DiarySingleShareUrl     @"http://baobaoshowshow.com/singlediaryshare.php?" //成长日记详情单张的分享
#define DiaryShareUrl           @"http://test.show.baobaoshowshow.com/anim/share_diary.php?" //成长日记整体的分享

#elif Current_Interface == Interface_Online
//线上环境

#define kBasicUrlStr            @"http://api.meimei.yihaoss.top/index.php?r=BabyShowV12/"
#define kNewBasicUrl            @"http://api.meimei.yihaoss.top/index.php?r=BabyShow/"
#define kBasicUrlV1             @"https://api.meimei.yihaoss.top/index.php?r=BabyShowV1/"
#define kImageBaseUrl           @"http://api.meimei.yihaoss.top/"
#define BABYSHOWSUPERGRANTUSER  @"1,2,1738" //宝宝客服,AshlyBaba,moon,多个用户具有超级权限

#define AppShareUrl             @"http://www.meimei.yihaoss.top/share.php?" //秀秀分享页面链接,
#define PostShareUrl            @"http://www.meimei.yihaoss.top/fenxiang/postbardetial.html?" //话题分享页面链接 拼的参数:img_id要分享的话题ID,user_id当前登录ID
#define BuyShareUrl             @"http://baobaoshowshow.com/share_buy.php?post_url=" //值得买分享链接
#define DiaryDetailShareUrl     @"http://baobaoshowshow.com/share_diary.php?" //成长日记详情整体的分享,album_id该成长记录的ID,user_id所有者ID,baby_id所属孩子的ID
#define DiarySingleShareUrl     @"http://baobaoshowshow.com/singlediaryshare.php?" //成长日记详情单张的分享,user_id所有者ID,img_id该图片的ID
#define DiaryShareUrl           @"http://www.meimei.yihaoss.top/anim/share_diary.php?" //成长日记外层整体的分享,user_id所有者ID,baby_id所属孩子的ID

#endif

/****************适配x****************************/
// 除去状态栏 高度的   高度
#define Navbar_HEIGHT (44)

// 判断状态栏是否隐藏
#define StatusBar_HEIGHT (diffStatusBarHidden ? 0.0f : statusBarMinW)

//适配的x之后Navbar_HEIGHT的高度
#define StatusAndNavBar_HEIGHT (StatusBar_HEIGHT+Navbar_HEIGHT)

//状态栏
#define diffStatusBarHidden [UIApplication sharedApplication].isStatusBarHidden//YES隐藏  NO出现
#define statusBarMinW MIN(CGRectGetWidth([UIApplication sharedApplication].statusBarFrame),CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define statusBarMaxW MAX(CGRectGetWidth([UIApplication sharedApplication].statusBarFrame),CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define statusBarH (diffStatusBarHidden ? 0.0f : statusBarMinW)

#define ISIPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
//如果是横屏. 左右偏移量44.0f 竖屏0.0f
#define IPhoneXOffsetLR ((ISIPhoneX && InterfaceLandscape)?44.0f:0.0f)

//如果竖屏上下偏移34.  如果横屏上下偏移24
#define IPhoneXOffsetTB (InterfacePortrait?(ISIPhoneX?34.0f:0.0f):(ISIPhoneX?24.0f:0.0f))

#define IPhoneXSafeHeight (ISIPhoneX?34:0)

#define TabbarHeight (49+IPhoneXSafeHeight)

/****************适配x****************************/


//#define kPayNewUrl                      @"http://api.meimei.yihaoss.top/index.php?r=BabyShowV2/"

//这几个在测试环境下没有,应该是共用的
#define PostGroupShareUrl    @"http://www.meimei.yihaoss.top/groupShare/groupIndex.html?"//群分享出去，拼的参数是group_id要分享的话题ID,login_user_id当前登录用户id
#define VideoShareUrl        @"http://www.meimei.yihaoss.top/fenxiang/video.html?"//视频帖子分享页面的链接img_id要分享的话题ID,user_id当前登录ID

#define kPayUrl              @"http://218.244.151.190/demo/charge" //测试的支付接口
#define kUrlScheme           @"wxcf183faac658e9c5" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
#define kStoreShare          @"http://baobaoshowshow.com/share_business.php?" //商家分享页面
#define kRedPacketShare      @"http://www.meimei.yihaoss.top/packet.html?"        //用户红包分享接口
#define kRedImg              @"http://api.meimei.yihaoss.top/static/defaultimg/smallpacket.png" //红包分享的小图标
#define kToyShare            @"http://www.meimei.yihaoss.top/fenxiang/play.html?" //商家分享页面
#define kToyNewShare         @"https://api.meimei.yihaoss.top/H5/fenxiang/toy_cout.html?"//商家分享心页面
#define kToyCardShare        @"https://api.meimei.yihaoss.top/H5/fenxiang/member_cout.html?"//会员卡分享

#pragma mark - 接口名称

//登陆相关接口
#define kLogin                  @"Login"
#define kLoginV1                @"LoginV1"          //第三方登录
#define kRegist                 @"RegistNew"        //新版注册,不包含用户名
#define kRegistMobile           @"RegistMobile"     //手机号注册
#define kVisitorRegist          @"VisitorRegist"    //游客模式
#define kBindShowUserList       @"BindShowUserList" //绑定列表
#define kCancelBind             @"CancelBind"       //取消绑定

//首页相关接口
#define kHeadListV7             @"HeadBannerList"       //专题头部可以跳商家
#define kSpecialRevision        @"SpecialRevisionV1"  //首页广场
#define kGetGroupList           @"GetGroupList"   //首页群跳转群列表接口
#define kBabyHome               @"BabyHomeV3"   //首页V1中下面列表的接口
#define kListingNew             @"ListingNewV1"   //首页下面最新
#define kgetHotListData         @"getListingHomeNew" //首页下面的热门
#define ksearchInformation      @"searchInformation"//搜索商家用户群帖
#define kMyFocusList            @"MyFocusList"//首页下面的关注接口
#define kgetToysList            @"getToysList"//玩具租赁页面列表



//专题相关接口
#define kSpecialHot             @"ShowPlazaList"    //专题热门
#define kSpecialList            @"SpecialListV2"      //更多主题
#define kSpecialDetail          @"SpecialDetailList"    //专题详情界面
#define kSpecialDetailGridV2    @"SpecialDetailGridV2" //专题照片墙
#define kDelSpecial             @"DelSpecial"       //删除专题
#define kFindSpecialUser        @"FindSpecialUser"   //专题照片墙查找
#define kImgInfo                @"ImgInfo"          //添加完关注之后的图片详情（评论折叠）

//秀秀相关接口
#define kNewTheme               @"NewTheme"          //秀秀最新
#define kNewThemeV1             @"NewThemeV1"
#define kFindPartUser           @"FindPartUser"       //秀秀搜索用户
#define kMakeAShowWithType      @"ImgShowV2"          //发秀秀，带权限(必须选图)
//#define kMakeAShowWithType      @"ImgShowV3"        //秀一下，可以只发文字，限安卓
#define kGetVideoList           @"VideoListingList"        //相册里面的视频接口
#define kPublicListing          @"PublicListing"       //发布秀秀和话题合并版
#define kPublicGroupListing     @"PublicGroupListing" //群里面发布话题

#define kAdmire                 @"Admire"             //秀秀赞
#define kCancelAdmire           @"CancelAdmire"       //取消赞
#define kDelShow                @"DelListingShow"            //删除我的秀秀
#define kReview                 @"ReviewV1"           //秀秀评论
#define kReviewList             @"ReviewList"         //秀秀评论列表
#define kDelReview              @"DelReview"          //删除评论
#define kCheckWeibo             @"CheckWeibo"         //只针对微博用户授权处理
#define kGoToPost               @"GoToPost"           //秀秀点击//来自话题//跳到话题详情需要的参数
#define kHotImgList             @"HotImgList"         //headerView 精选头部
//热点相关接口
#define kPostCoverListV1        @"PostCoverListV1"  //热点最新的头部
#define kPostMyInterest         @"PostMyInterestV2"   //我的兴趣列表
#define KPostMyInterestList     @"PostMyInterestList" //我的兴趣更多的群帖
#define kPostMyInterestBusiness @"PostMyInterestBusiness"//热点附近商家
#define kPostReplyListV1        @"PostReplyListV1"  //热点详情
#define kPostMyInterestListV1   @"PostMyInterestListV1"//热点下面列表数据
#define kPostMyInterestListV3   @"PostMyInterestListV4"//热点下面列表数据新接口

#define kPostMasterV1           @"PostMasterV1"     //热点只看楼主
#define kSavePost               @"SaveListing"         //帖子收藏帖子
#define kCancelPost             @"CancelListing"       //帖子取消收藏帖子
#define kDelPostShow            @"DelListingShow"      //帖子，删除帖子
#define kPostReviewList         @"getReviewReviewList"   //帖子评论列表
#define kPostListV6             @"PostListV6"        //热点二级分类
#define kGroupDetailListV8      @"GroupDetailListing"  //圈子加商家详情
#define kGroupDetailListV7      @"GroupDetailListingV1"  //圈子圈主管理群的接口
#define kNoticeRecGroupList     @"NoticeRecGroupListing" //群主公告或精华列表


#define kGetGroupInfo           @"GetGroupHead"        //群主信息
#define kgroupHeadInfo          @"groupHeadInfoV1"       //群头部信息9.20
#define kPostIdol               @"PostIdol"            //圈子关注
#define kCancelPostIdol         @"CancelPostIdol"      //取消关注
#define kPostReview             @"PublicReviewReview"       //话题评论
#define kPostAdmire             @"PostAdmireNew"       //帖子赞
#define kCancelPostAdmire       @"CancelPostAdmireNew"    //帖子取消赞
#define kPublicPost             @"PublicPost"       //发布话题
#define kPublicGroupPost        @"PublicGroupPost"  //群里发布话题
#define kPostImageNew           @"PublicListingReview"     //热点跟贴
#define kPostImgDetail          @"PostImgDetail"   //话题详情新版 2016.4.21
#define kPostImgReviews         @"ListingImgReviews"   //话题详情内部的回复 2016.4.22
#define kListingReviews         @"ListingReviews" //话题详情回复的回复 2016.11.21
#define kPostImgVideo           @"ListingImgVideoV1"   //话题详情带视频版 2016.5.12
#define kgetGroupListingPage    @"getGroupListingPageV1"  //群详情下面的列表9.20
#define keditGroupHead          @"editGroupHead" //编辑群头部
#define kAlbumImgVideo          @"AlbumImgVideo"  //秀秀视频详情头部信息接口 2016.7.4
#define kAlbumImgReviews        @"AlbumImgReviews"//秀秀视频页面评论详情  2016.7.5
#define kgetListingList         @"getListingList" //最新的各种群列表
#define kListingDetail          @"ListingDetailV1"   //帖子图文版详情11.23
#define kListingImgReviews      @"ListingImgReviews"//帖子里面的评论
#define kCancelListingReviewAdmire  @"CancelListingReviewAdmire"//取消帖子里面的赞
#define kPublicListingReviewAdmire  @"PublicListingReviewAdmire"//帖子用户评论的赞
#define kPublicListingAdmire    @"PublicListingAdmire" //帖子里面对主贴赞
#define kCancelListingAdmire    @"CancelListingAdmire"//帖子主贴取消赞
#define kgetGroupCategory       @"getGroupCategory" //分类列表数据
#define kgetGroupCategoryV1     @"getGroupCategoryV1" //分类列表数据


//群主权限
#define kTopGroupPost           @"TopGroupListing"     //群里置顶某贴
#define kNoticeGroupPost        @"NoticeGroupListing"  //群里面设置公告
#define kEssenceGroupPost       @"EssenceGroupListing"  //群里设置精华
#define kDelGroupPost           @"DelGroupListing"     //删除某帖子
#define kDoGroup                @"UpGroup"          //群主修改群名的接口
#define kSearchGroup            @"SearchGroup"      //广场查找群名和帖子名
//商家接口
#define KBusinessDetailV6       @"BusinessDetailV1"   //商家详情接口12.8
#define kGetBusinessListV1      @"GetBusinessListV1" //商家列表分类
#define kGetBusinessListV2      @"GetBusinessListV2" //商家列表加经纬度
#define kGetBusinessListV3      @"GetBusinessListV3"  //商家加北京
#define kSearchBusinessListV1   @"SearchBusinessListV1"  //商家搜索结果

//关于支付
#define KOrderDetail            @"OrderDetail"     //我的订单详情
#define kOrderDetailV1          @"OrderDetailV1"    //我的订单详情新文件里
#define kUserOrderList          @"UserOrderListV1"   //我的订单列表
#define kPublicOrder            @"PublicOrderNewV1"     //支付订单
#define kBusinessOrderList      @"BusinessOrderListV1"//商家订单
#define kBusinessVerification   @"BusinessVerification"//商家验证码
#define kPublicOrderComment     @"PublicOrderComment"//用户评价订单
#define kBusinessCommentList    @"BusinessCommentList"//用户评价列表
#define kRefundOrder            @"RefundOrder"        //用户退款
#define kBusinessCityList       @"BusinessCityList"    //用户城市筛选
#define kSearchCompletedOrder   @"SearchCompletedOrder"//商家筛选订单类型接口

//玩具租赁
#define kGetToysCityList        @"getToysCityList"   //玩具租赁的区域选择
#define kAddToysAddress         @"addToysAddress"    //用户更改地址

//值得买相关接口
#define kBusinessListV6         @"BusinessListV6"   //值得买新的轮播图
#define kShowBuyNewList         @"ShowBuyNewList"   //值得买的今日推荐
#define kBuyNewList             @"BuyNewList"       //值得买更多列表
#define kBuyList                @"BuyDetailList"    //妈妈值得买-列表
#define kWorthBuyImageNew       @"BuyImageNew"      //妈妈值得买发布
#define kMarkBuyUrl             @"MarkBuyUrl"       //记录值得买点击链接次数

//成长记录相关接口
#define kDiaryAlbumList         @"DiaryAlbumList"   //成长日记相册列表
#define kDiaryImgsList          @"DiaryImgsList"    //成长日记详情列表
#define kDiaryTagList           @"DiaryTagListV1"     //成长日记标签列表
#define kDiaryAdmire            @"DiaryAdmire"      //成长日记赞
#define kDiaryCancelAdmire      @"CancelDiaryAdmire"//成长日记取消赞
#define kDiaryReview            @"DiaryReview"      //成长日记的评论
#define kDiaryReviewList        @"DiaryReviewList"  //成长日记评论列表
#define kDelDiaryReview         @"DelDiaryReview"   //成长日记评论删除
#define kDelDiary               @"DelDiary"         //成长日记单条删除
#define kUpdateDiaryList        @"UpdateDiaryList"  //成长日记修改列表
#define kUpDiary                @"UpDiary"          //编辑后提交
#define kDelDiaryAlbum          @"DelDiaryAlbum"    //编辑页面删除所有
#define kAddBabyAvatar          @"AddBabyAvatar"    //添加孩子头像
#define kShareToPost            @"ShareToListing"      //成长日记分享到话题/秀秀
#define kImportToDiary          @"ImportToDiaryNew"  //成长日记一键导入,记录图片地理经纬度,带合并功能
#define kImportToDiaryV1        @"ImportToDiaryV3"  //成长日记修改页面一键导入,带图片地理位置
#define kCombineSendMail        @"CombineSendMail"  //合并需要上传的接口
#define kCombineDiary           @"CombineDiaryV2"     //合并成长记录同意
#define kShareSingleToPost      @"ShareSingleToPost"//成长日记单张分享到话题/秀秀
#define kDiaryCate              @"DiaryCate"        //成长日记设置隐私
#define kCancelDiaryCate        @"CancelDiaryCate"  //成长日记取消隐私设置
#define kRecordLoginTime        @"RecordLoginTime"  //记录用户进入自由环球租赁的时间
#define kPublicGrowth           @"PublicGrowth"     //宝宝身高体重信息的添加
#define kGrowthList             @"GrowthList"       //宝宝身高体重数据

//我的主页
#define kUserInfo               @"UserInfo"         //登陆的用户信息
#define kPostImgInfo            @"PostImgInfo"      //图片详情（评论不折叠）
#define kMyImgs                 @"MyImgsV5"         //我、TA发布的，可以有没图的秀秀版
#define kMessCount              @"NoticeList"       //消息数量
#define kIdolListV2             @"IdolListV2"
#define kPostMyMessage          @"ListingMyMessage"    //我的消息列表
#define kPostFriendsMessage     @"ListingFriendsMessage" //好友消息动态
#define kPostSaveListV1         @"ListingSaveList"   //新版热点收藏列表
#define kFocusOn                @"FocusOn"           //关注
#define kCancelFocus            @"CancelFocus"       //取消关注
#define kShareListV2            @"ShareListV2"      //合并后的共享列表
#define kDoShare                @"DoShare"          //请求共享
#define kCancelShare            @"CancelShare"
#define kMyShareList            @"MyShareList"      //成长记录合并列表
#define kPacketList             @"PacketList"      //红包列表
#define kCheckPacket            @"CheckPacket"     //检测订单列表是否有红包可以发
#define kBabysIdolList          @"BabysIdolList" //个人中心的成长记录取消关注列表
#define kEditBabysIdol          @"EditBabysIdol"  //个人中心成长记录添加和取消关注
#define kEditMobile             @"EditMobile"     //添加或编辑手机号
#define kMobileInfo             @"MobileInfo"     //更换手机号信息
#define kCheckMobile            @"CheckMobile"    //检查完整手机号与隐藏手机号是否一致
#define kCheckMobileInfo        @"CheckMobileInfo"//忘记密码找回时验证手机号是否为注册用户
#define kEditPassword           @"EditPassword" //找回密码时更换密码接口
#define kAddMobile              @"AddMobile"    //已经注册的手机号绑定到账号上
#define kAddCooperation         @"AddCooperation"  //我要合作的接口
#define kSearchVerification     @"SearchVerification"//商家验证跳转商家订单

//添加宝贝
#define kAddBaby                @"AddBaby"          //添加宝贝
#define kEditBabys              @"DoBaby"           //编辑宝宝昵称
#define kGetBabys               @"GetBabys"         //获取宝贝信息
#define kUpBabyBirthday         @"UpBabyBirthday"   //编辑宝宝生日
#define kEditUser               @"EditUser"
#define kAlbumList              @"AlbumList"
#define kShareAlbum             @"ShareAlbum"       //分享相册
#define kImgLists               @"ImgListing"          //图片列表
#define kImgListV2              @"ImgListingV2"        //主题相册列表,GET
#define kDoImg                  @"DoImg"            //图片的操作
#define kMoveImgs               @"MoveImgs"         //移动图片
#define kDownloadImg            @"DownloadImg"      //下载到我的相册
#define kDoAlbum                @"DoAlbum"          //相册的操作
#define kNewAlbum               @"NewAlbum"         //新建相册
#define kUpImgs                 @"UpImgs"
#define kSearchKindergartenUser @"SearchKindergartenUser"  //用户搜索幼儿园老师接口

//v12上的接口
#define kSendMail               @"SendMail"         //邮箱发送验证码
#define kVerifyCode             @"VerifyCode"       //验证码验证
#define kDoPasswd               @"DoPasswd"         //修改密码,重置密码
#define kDelPostReview          @"DelPostReview"    //贴吧，删除评论


//////////////////////////////////////////////////////

#define kSearchSpecialListr     @"SearchSpecialList" //专题搜索结果
#define kSpecialHeadList        @"HeadListV7"  //专题头部轮播已有可废弃
#define kHeadListV6             @"HeadListV6"       //专题头部可以跳商家旧版秀秀
#define kAdmireList             @"AdmireList"//赞列表

#define kPostAdmireList         @"PostAdmireList"   //贴吧赞列表
#define kReport                 @"InformImg" //举报但貌似没用到
#define kMessage                @"PostMessage"      //包含跟帖信息的消息列表
#define kActiveList             @"ActiveList"       //参与活动报名参加的详情列表

#define kPostBar                @"PostListV2"       //贴吧标题列表
#define kPostImage              @"PostImage"        //贴吧发起话题、跟帖这个接口在看看
#define kDelBuyShow             @"DelBuyShow"       //妈妈值得买-删除帖子



#define kBuyAdmire              @"BuyAdmire"        //妈妈值得买详情-赞
#define kCancelBuyAdmire        @"CancelBuyAdmire"  //妈妈值得买详情-取消赞

#define kBuyReview              @"BuyReviewV1"        //妈妈值得买详情-评论
#define kBuyReviewList          @"BuyReviewList"    //妈妈值得买详情-评论列表
#define kDelBuyReview           @"DelBuyReview"     //妈妈值得买详情-删除评论

#define kPostInfo               @"PostInfo"         //贴吧刷新单条数据

#define kPostListV4             @"PostListV4"       //新版话题列表

#define kPostInfoV4             @"PostInfoV4"       //新版热点局部刷新
#define kJoinAlbumList          @"JoinAlbumList"    //参加展播的相册列表
#define kJoinHotAlbum           @"JoinHotAlbum"     //POST，报名展播

#define kBindUser               @"BindShowUser"     //登录第三方绑定站内用户

//支付宝
#define KPartner                @"2088721930969145"
#define KSeller                 @"laozou@baobaoshowshow.com"
#define KPrivateKey             @""
#define KPayOrder               @"PayOrder"//支付成功之后走的接口
#define kCheckOrderPay          @"CheckOrderPay"//第二次回到订单页面检测订单状态

#define kOrderShareState        @"OrderShareState"  //检查红包分享状态

#pragma mark - 接口参数名
//登录
#define kUserName               @"user_name"
#define kPassword               @"password"

//注册
#define kRegistUserName         @"user_name"
#define kRegistPassword         @"password"
#define kRegistNickName         @"nick_name"
#define kRegistAvatar           @"avatar"
#define kRegistEmail            @"email"

//秀一下
#define kMakeAShowUserId        @"user_id"
#define kMakeAShowPhoto         @"album_img"
#define kMakeAShowDescribe      @"img_desc"

//我的秀秀
#define kMyShowUserId           @"user_id"
#define kMyShowLoginUserId      @"login_user_id"
#define kMyShowImgId            @"img_id"
#define kMyShowUserName         @"user_name"
#define kMyShowAvatar           @"avatar"
#define kMyShowAvatarOrigin     @"avatar_origin"
#define kMyShowImg              @"img"
#define kMyShowImgDown          @"img_down"
#define kMyShowImgThumb         @"img_thumb"
#define kMyShowImgThumbWidth    @"img_thumb_width"
#define kMyShowImgThumbHeight   @"img_thumb_height"
#define kMyShowImgWidth         @"img_width"
#define kMyShowImgHeight        @"img_height"
#define kMyShowDescription      @"description"
#define kMyShowAdmireCount      @"admire_count"
#define kMyShowReviewCount      @"review_count"
#define kMyShowCreatTime        @"create_time"
#define kMyShowImgName          @"img_name"
#define kMyShowReviews          @"reviews"
#define kMyShowReviewId         @"id"
#define kMyShowReviewDemand     @"demand"
#define kMyShowReviewUserName   @"user_name"
#define kMyShowImgIsAdmired     @"is_admire"
#define kMyShowLastId           @"last_id"
#define kMyShowImgCate          @"img_cate"

//评论列表
#define kReviewListImgId        @"img_id"
#define kReviewListFirstId      @"first_id"
#define kReviewListLastId       @"last_id"
#define kReviewListPageSize     @"page_size"

#define kReviewListID           @"id"
#define kReviewListDemand       @"demand"
#define kReviewListReviewName   @"review_user"
#define kReviewListCreatTime    @"create_time"
#define kReviewListAvatar       @"avatar"
#define kReviewListUserName     @"user_name"
#define kReviewListUserId       @"user_id"

//赞列表
#define kAdmireListImgId        @"img_id"
#define kAdmireListFirstId      @"first_id"
#define kAdmireListLastId       @"last_id"
#define kAdmireListPageSize     @"page_size"

//评论
#define kReviewUserId           @"user_id"      //操作评论的人,当前登录用户
#define kReviewDemand           @"demand"       //拼好的 @somebody:xxxx
#define kReviewImgId            @"img_id"       //要评论的图片id
#define kReviewOwnerId          @"owner_id"     //拥有者
#define kReviewAtId             @"at_id"        //要回复的人

//赞
#define kAdmireUserId           @"user_id"
#define kAdmireAdmireId         @"admire_id"
#define kAdmireImgId            @"img_id"
#define kAdmireBtnTag           @"kAdmireBtnTag"

//取消赞
#define kCancelAdmireUserId     @"user_id"
#define kCancelAdmireAdmireId   @"admire_id"
#define kCancelAdmireImgId      @"img_id"

//图片信息
#define kImgInfoUser_id         @"user_id"
#define kImgInfoLogin_user_id   @"login_user_id"
#define kImgInfoImg_id          @"img_id"

//广场
#define kSquareSearchWord       @"search_word"
#define kSquarePage             @"page"
#define kSquarePageSize         @"page_size"
#define kSquareLogin_user_id    @"login_user_id"
#define kSquareIs_android       @"is_android"

//相册列表
#define kAlbumListUser_id       @"user_id"
#define kAlbumListLogin_user_id @"login_user_id"
#define kAlbumListAlbum_id      @"album_id"
#define kAlbumListFirst_id      @"first_id"
#define kAlbumListLast_id       @"last_id"
#define kAlbumListPage_size     @"page_size"

//图片列表
#define kImgListUser_id         @"user_id"
#define kImgListLogin_user_id   @"login_user_id"
#define kImgListAlbum_id        @"album_id"
#define kImgListFirst_id        @"first_id"
#define kImgListLast_id         @"last_id"
#define kImgListPage_size       @"page_size"

//相册的操作
#define kDoAlbumUser_id         @"user_id"
#define kDoAlbumAlbum_id        @"album_id"
#define kDoAlbumAlbum_name      @"album_name"   //修改相册名称
#define kDoAlbumDo_type         @"do_type"      //0修改,1删除

//图片的操作
#define kDoImgUser_id           @"user_id"
#define kDoImgImg_id            @"img_id"
#define kDoImgDo_type           @"do_type"
#define kDoImgImg_name          @"img_name"

//新建相册
#define kNewAlbumUser_id        @"user_id"
#define kNewAlbumAlbum_id       @"album_id" //相册所属的相册的id
#define kNewAlbumAlbum_name     @"album_name"

//图片移动
#define kMoveImgsUser_id        @"user_id"
#define kMoveImgsImg_ids        @"img_ids"
#define kMoveImgsAlbum_id       @"album_id"     //相片所属的孩子相册的id
#define kMoveImgsTo_album_id    @"to_album_id"

//请求共享
#define kDoShareUser_id         @"user_id"      //当前登录id
#define kDoShareShare_id        @"share_id"     //要请求的人的id
#define kDoShareShare_type      @"share_type"   //默认0请求,1处理
#define kDoShareIs_agree        @"is_agree"     //默认0 否(拒绝或忽略),1是(同意)

//分享相册
#define kShareAlbumUser_id      @"user_id"      //当前用户的id
#define kShareAlbumFirst_id     @"first_id"
#define kShareAlbumLast_id      @"last_id"
#define kShareAlbumPage_size    @"page_size"

//邮箱发送验证码
#define kSendMailEmail          @"email"        //必填,用户输入的邮箱

//验证码验证
#define kVerifyCodeEmail        @"email"        //必填,用户邮箱
#define kVerifyCodeSecret       @"secret"       //必填,验证码

//修改密码,重置密码
#define kDoPasswdDo_type        @"do_type"      //非必填,0修改密码,1忘记密码
#define kDoPasswdNew_passwd     @"new_passwd"   //必填 ,新密码ＭＤ５
#define kDoPasswdOld_passwd     @"old_passwd"   //必填,修改密码原始密码(MD5)
#define kDoPasswdUser_id        @"user_id"      //必填,修改密码用户ID
#define kDoPasswdEmail          @"email"        //必填,忘记密码用户的邮箱

#define kOperationThemeLogin_user_id    @"login_user_id"
#define kOperationThemeType             @"type"             //必填，1是精美(主题和图片），0是最新（主题和图片）
#define kOperationThemeFirst_id         @"first_id"
#define kOperationThemeLast_id          @"last_id"
#define kOperationThemePage_size        @"page_size"
#define kOperationThemePage             @"page"             //翻页的页数，最多10页（0-9）

/**
 *  活动列表
 */
#define kActiveListLogin_user_id        @"login_user_id"
#define kActiveListActive_type          @"active_type"      //活动的id,当前指定一个活动，传值1
#define kActiveListType                 @"type"             //1为最新，0为热门
#define kActiveListFirst_id             @"first_id"
#define kActiveListLast_id              @"last_id"
#define kActiveListPage_size            @"page_size"

/**
 *  广场搜索字段
 */
#define kFindPartUserLogin_user_id      @"login_user_id"
#define kFindPartUserSearch_word        @"search_word"

/**
 商家搜索字段
 */
#define kSearchBusiness                 @"SearchBusiness"
/**
 *  下载到我的相册 path:相册--其他--下载
 */
#define kDownloadImgUser_id             @"user_id"
#define kDownloadImgImg_url             @"img_url"

/*!
 *  要报名展播的相册列表
 */
#define kJoinAlbumListLogin_user_id     @"login_user_id"

/*!
 *  报名参数
 */
#define kJoinHotAlbumLogin_user_id      @"login_user_id"
#define kJoinHotAlbumAlbums             @"albums"

/**
 *  创建成长日记
 */
#define kCreateStoryLogin_user_id       @"login_user_id"
#define kCreateStoryStory_title         @"story_title"


/**
 *  添加成长记录(成长日记中的一页)
 */
#define kGrowthStoryLogin_user_id       @"login_user_id"
#define kGrowthStoryStory_id            @"story_id"
#define kGrowthStoryFile_count          @"file_count"
#define kGrowthStoryImg_desc            @"img_desc"
//......img1...img4File对象

/**
 *  成长日记列表
 */
#define kStoryCateListUser_id           @"user_id"
#define kStoryCateListLogin_user_id     @"login_user_id"
#define kStoryCateListFirst_id          @"first_id"
#define kStoryCateListLast_id           @"last_id"
#define kStoryCateListPage_size         @"page_size"

/**
 *  我的好友的成长日记总信息列表
 */
#define kOpenStoryListLogin_user_id     @"login_user_id"

/**
 *  成长记录列表
 */
#define kStoryListUser_id           @"user_id"
#define kStoryListLogin_user_id     @"login_user_id"
#define KStoryListStory_id          @"story_id"
#define kStoryListFirst_id          @"first_id"
#define kStoryListLast_id           @"last_id"
#define kStoryListPage_size         @"page_size"

#define kPublicBabysIdol            @"PublicBabysIdol"
#define kBabysIdolCombine           @"BabysIdolCombine"//成长记录同步接口

/**
 *  编辑成长日记
 */
#define kDoStoryCateLogin_user_id   @"login_user_id"
#define kDoStoryCateId              @"id"
#define kDoStoryCateDo_type         @"do_type"      //默认0修改权限,1删除

/*!
 *  第三方绑定站内用户
 */
#define kBindUID                    @"uid"          //当前登录的第三方userid
#define kBindUser_type              @"user_type"    //1微博2微信
#define kBindUser_name              @"user_name"    //站内秀秀账户用户名/邮箱
#define kBindPassword               @"password"     //密码.MD5加密

#define kBindListUser_id            @"user_id"

//取消绑定
#define kCancelBindUser_id          @"user_id"
#define kCancelBindUser_type        @"user_type"

//只针对微博用户授权处理
#define kCheckWeiboUser_id          @"user_id"
#define kCheckWeiboUser_type        @"user_type"
#define kCheckWeiboUid              @"uid"

//新版值得买发布
#define kWorthBuyImageNewUser_id    @"user_id"     //当前登录用户ID
#define kWorthBuyImageNewGood_url   @"good_url"    //推荐的值得买的商品链接
#define kWorthBuyImageNewReason     @"reason"      //推荐理由
/*************************************************************************************************************/
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define NAVICOLOR           @"fd6363"
#define BACKCOLOR           @"ff6767"// @"e84c3d"
/***************************************************************************************************************/

#define APPNAME @"自由环球租赁"

/******************************************************************************************************************/
//游客模式，提醒内容
#define VISITORWARNING @"游客不能够使用这里哦，请登录"

/****************************************************************************************************/
//新浪appkey
#define SINAAPPKEY      @"1973070790"
//微信appkey
#define WEIXINAPPKEY    @"wxcf183faac658e9c5"
#define WEIXINAPPSECRET @"2b0c7c96a3e723c71771831c6fb133b7"

//ShareSDK-AppKey
#define APPKEY          @"30a3d9a2f950"
#define APPSECURITY     @"ca683e66b237b52973c16eef4a0902e8"
//短信的SDK-AppKey
#define AppKeySMS       @"e3ecfe5c5330"
#define AppSecretSMS     @"cf30557e43e0c95d607761c89bd0424c"

/********************************************************************************************************/

#pragma mark - 用户信息
//费雪蹦跳
#define USERID                  @"USERIDVERSION2"
#define USERNICKNAME            @"USERNICKNAME"
#define USERAVATARSTR           @"USERAVATARSTR"
#define USERAVATARORIGINSTR     @"USERAVATARORIGINSTR"
#define USERBABYSARRAY          @"USERBABYSARRAY"
#define USERNAME                @"USERNAME"
#define USEREMAIL               @"USEREMAIL"
#define USERPASSWORD            @"USERPASSWORD"
#define USERISAVISIVOR          @"USERISAVISIVOR"
#define USERLOGINTYPE           @"USERLOGINTYPE"
#define USERBABYUPDATE          @"USERBABYUPDATE"
//0绑定过,1没绑定过,只是普通微博用户,2 没绑定过,只是普通微信用户,这个字段主要用于设置页点击绑定账号的时候决定是进绑定页面,还是进列表页面
#define USERBINDINDTYPE         @"USERBINDINDTYPE"
#define LOGIN_USER_ID           [[[UserInfoManager alloc]init] currentUserInfo].userId
#define ISVISITORORUSER         [[[[UserInfoManager alloc]init] currentUserInfo].isVisitor boolValue]
/***************************************************************************************************************/


#pragma mark - 友盟

#define UMENG_APPKEY      @"52dfb16156240b4968007ad9"
#define UMENG_CHANEL_ID   @"App Store"
//#define UMENG_CHANEL_ID   @"91"
/*******************************************************************************************************************/

#define UMEVENTREGISTER         @"register"
#define UMEVENTLOGIN            @"login"
#define UMEVENTSHARE            @"share"
#define UMEVENTSHOW             @"show"
#define UMEVENTEDITBABY         @"edit_baby"
#define UMEVENTADDBABY          @"add_baby"
#define UMEVENTDELBABY          @"del_baby"
#define UMEVENTUPLOAD           @"upload"
#define UMEVENTADDALUM          @"add_album"
#define UMEVENTSEEIMGDETAIL     @"squareClickImage"
#define UMEVENTJINGXUAN         @"jingxuan"
#define UMEVENTZUIXIN           @"zuixin"
#define UMEVENTSQUARECOVER      @"squarecover"
#define UMEVENTSENDPOST         @"sendpost"
#define UMEVENTZHANBO           @"zhanbo"
#define UMEVENTCOMBINE          @"CombineDiary"
/***********************************************************************************************************************/

#pragma mark - 版本判断

#define APP_URL         @"http://itunes.apple.com/lookup?id=789847552"

/**********************************************************************************************************************/

#pragma mark 设备以及适配

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

/************************************************************************************************************************/

#pragma mark 网络请求类型

enum NetSyle{
    
    NetStyleRegister=0,
    NetStyleLogin,
    NetStyleAddAChild,
    NetStyleMakeAShowNew,
    NetStyleMakeASpecialShowNew,
    NetStyleReviewList,
    NetStyleAdmire,
    NetStyleCancelAdmire,
    NetStyleReview,
    NetStylePraiseList,
    NetStyleEditUser,
    NetStyleMyHomePage,
    NetStyleImageDetail,
    NetStylegetIdolList,
    NetStyleFocusOn,
    NetStyleCancelFocus,
    NetStyleRePort,
    NetStyleDeleteBaby,
    NetStyleGetMessList,
    NetStyleGetMessRequestList,
    NetStylemyImgs,
    NetStyleUploadPhoto,
    NetStyleAgreeShare,
    NetStyleCancelShare,
    NetStyleShareList,
    NetStyleDelShow,
    NetStyleDelReview,
    NetStyleRefreshReview,
    NetStyleVisitorRegist,
    NetStylePostBar,
    NetStylePostBarRefresh,
    NetStylePostBarDetail,
    NetStylePostBarAddTopic,
    NetStylePostBarAddTopicWorthBuy,
    NetStylePostBarAddToBeMyFocus,
    NetStylePostBarCancelFocus,
    NetStylePostBarWorthBuy,
    NetStyleBuyNewList,//值得买首页g更多
    NetStylePostBarWorthBuyAdmire,
    NetStylePostBarWorthBuyCancelAdmire,
    NetStylePostBarWorthBuyReview,
    NetStylePostBarWorthBuyReviewList,
    NetStylePostBarRefreshReviews,
    NetStyleWorthBuyDelReview,
    NetStyleWorthBuyDeletShow,
    NetStyleUnionLogin,
    NetStylePostBarNew,
    NetStylePostBarNewDetail,
    NetStylePostBarNewDetailOnlyHost,
    NetStylePostBarNewMakeAPost,
    NetStylePostBarNewRefreshReviews,
    NetStylePostBarNewHeaderView,
    NetStylePostBarNewSaveList,
    NetStylePostAlbumList,      //话题顶部Banner滚动的数据(今日推荐)
    NetStyleImportToDiary,      //成长日记一键导入
    NetStyleDiaryAlbumList,     //成长日记列表
    NetStyleDiaryImgsList,      //成长日记详情列表
    NetStyleUpdateDiaryList,    //成长日记修改列表
    NetStyleUpDiary,            //成长日记修改
    NetStyleBabysIdolCombine,            //同步别人的成长日记上传接口
    NetStyleAddBabyAvatar,      //添加孩子头像
    NetStyleSpecialHeadList,    //专题头部轮播图
    NetStyleSpecialDetail,      //专题详情界面
    NetStyleSpecialList,         //更多主题65
    NetStyleDelSpecial,          //删除专题
    NetsTyleSpecialDetailGridV,  //专题照片墙
    NetStylePostMyInterest,      //新版话题我的兴趣
    NetStylePostListV5,          //新版话题分类
    NetStyleGroupDetailList,     //新版圈子详情
    NetStyleGroupDetailListEdit, //群主管理群信息
    
    NetStylePublicPost,          //新版发话题
    NetStylePublicGroupPost,     //新版群里发布话题
    NetStylePostIdol,            //圈子关注
    NetStyleCancelPostIdol,      //取消关注
    NetStyleSearchSpecialListr,  //专题照片墙的搜索结果
    NetStyleCombineSendMail,     //成长合并记录的请求
    NetStyleCombineDiary,       //成长记录同意合并
    NetStyleTopGroupPost,       //群里置顶某个帖子
    NetStyleDelGroupPost,       //删除群里某帖子
    NetStyleNewTheme,           //我的圈子和最新合并
    NetStyleDoGroup,            //修改群里的群名
    NetStylePostMyInterestList, //更多的群和帖子
    NetStyleGetBusinessList,    //点击更多商家优惠
    NetStyleUserOrderList,     //我的订单列表
    NetStyleBusinessOrderList,  //商家订单列表
    NetStyleBusinessVerification, //商家验证码
    NetStyleBusinessCommentList, //商家评论列表
    NetStylePostFriendsMessage,//好友消息动态
    NetStyleSpecialRevision, //专题首页改版11。16
    NetStylePacketList,      //红包列表
    NetStyleCancelFouceDiaryList,//成长记录取消关注列表
    NetStyleNoticeRecGroupList, //公告或精华列表
    NetStylePostGetGroupList,   //首页跳转群列表
    NetStylePostMyInterestListV1, //热点列表
    NetStyleEditGroupHead, //群主编辑头部
    
    
    
};

/*********************************************************************************************************************/

#pragma mark - 网络请求方式

enum Method{
    NetMethodGet=0,
    NetMethodPost
};

/********************************************************************************************************************/

#pragma mark 评论列表类型

enum MyShowListType {
    MyShowReviewList = 0,
    MyShowPraiseList,
    MyShowAddReview
};

/******************************************************************************************************************/

#pragma mark 我的秀秀类型

enum MyShowType {
    
    MyShowMyDefault =0,
    MyShowMine,
    MyShowHis,
    MyShowSquare,
    MyShowActivity
    
};

/********************************************************************************************************************/

#pragma mark - 屏幕的宽

#define VIEWWIDTH self.view.bounds.size.width
#define VIEWHEIGHT self.view.bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH_FIT [UIScreen mainScreen].bounds.size.width/320
#define SCREENHEIGHT_FIT [UIScreen mainScreen].bounds.size.height/480



#pragma mark 3.5寸还是4寸的屏幕

#define is4Inch ([UIScreen mainScreen].bounds.size.height >= 568)?YES : NO
/********************************************************************************************************************/

#pragma mark - 通知中心
//检测订单是否支付
#define USER_ISPAY [NSString stringWithFormat:@"USER_ISPAY_ORDER"]

#define USER_LOGIN_SUCCEED [NSString stringWithFormat:@"USER_LOGIN_SUCCEED"]
#define USER_LOGIN_FAIL [NSString stringWithFormat:@"USER_LOGIN_FAIL"]


#define USER_REGIST_SUCCEED [NSString stringWithFormat:@"USER_REGIST_SUCCEED"]
#define USER_REGIST_FAIL [NSString stringWithFormat:@"USER_REGIST_FAIL"]

#define USER_ADDBABY_SUCCEED [NSString stringWithFormat:@"USER_ADDBABY_SUCCEED"]
#define USER_ADDBABY_FAIL [NSString stringWithFormat:@"USER_ADDBABY_FAIL"]

//发布秀秀成功
#define USER_MAKEASHOW_SUCCEED [NSString stringWithFormat:@"USER_MAKEASHOW_SUCCEED"]
#define USER_MAKEASHOW_FAIL [NSString stringWithFormat:@"USER_MAKEASHOW_FAIL"]

//发布秀秀专题成功
#define USER_MAKEASHOWSPECIAL_SUCCEED [NSString stringWithFormat:@"USER_MAKEASHOWSPECIAL_SUCCEED"]
#define USER_MAKEASHOWSPECIAL_FAIL [NSString stringWithFormat:@"USER_MAKEASHOWSPECIAL_FAIL"]

//发布值得买成功
#define USER_PUBLISH_WORTHBUY_SUCCEED [NSString stringWithFormat:@"USER_PUBLISH_WORTHBUY_SUCCEED"]
#define USER_PUBLISH_WORTHBUY_FAIL [NSString stringWithFormat:@"USER_PUBLISH_WORTHBUY_FAIL"]

#define USER_MYSHOWGET_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWGET_SUCCEED"]
#define USER_MYSHOWGET_FAIL [NSString stringWithFormat:@"USER_MYSHOWGET_FAIL"]


#define USER_MYSHOWPRAISE_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWPRAISE_SUCCEED"]
#define USER_MYSHOWPRAISE_FAIL [NSString stringWithFormat:@"USER_MYSHOWPRAISE_FAIL"]

#define USER_MYSHOWCANCELPRAISE_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWCANCELPRAISE_SUCCEED"]
#define USER_MYSHOWCANCELPRAISE_FAIL [NSString stringWithFormat:@"USER_MYSHOWCANCELPRAISE_FAIL"]

#define USER_CHANGE_PRAISE_COUNT [NSString stringWithFormat:@"USER_CHANGE_PRAISE_COUNT"]

#define USER_REVIEW_SUCCEED [NSString stringWithFormat:@"USER_REVIEW_SUCCEED"]
#define USER_REVIEW_FAIL [NSString stringWithFormat:@"USER_REVIEW_FAIL"]

#define USER_GET_REVIEW_LIST_SUCCEED [NSString stringWithFormat:@"USER_GET_REVIEW_LIST_SUCCEED"]
#define USER_GET_REVIEW_LIST_FAIL [NSString stringWithFormat:@"USER_GET_REVIEW_LIST_FAIL"]

#define USER_GET_PRAISE_LIST_SUCCEED [NSString stringWithFormat:@"USER_GET_PRAISE_LIST_SUCCEED"]
#define USER_GET_PRAISE_LIST_FAIL [NSString stringWithFormat:@"USER_GET_PRAISE_LIST_FAIL"]

#define USER_NET_ERROR  [NSString stringWithFormat:@"USER_NET_ERROR"]
#define USER_NET_SPECIAL_ERROR [NSString stringWithFormat:@"USER_NET_SPECIAL_ERROR"]
//游客身份进来的时候网络错误
#define USER_NETVISTOR_ERROR [NSString stringWithFormat:@"USER_NETVISTOR_ERROR"]

#define USER_EDIT_SUCCEED [NSString stringWithFormat:@"USER_EDIT_SUCCEED"]
#define USER_EDIT_FAIL [NSString stringWithFormat:@"USER_EDIT_FAIL"]

//群主编辑头部信息
#define EDITGROUPHEAD_FAIL [NSString stringWithFormat:@"EDITGROUPHEAD_FAIL"]
#define EDITGROUPHEAD_SUCCEED [NSString stringWithFormat:@"EDITGROUPHEAD_SUCCEED"]


#define USER_GET_IMG_INFO_SUCCEED [NSString stringWithFormat:@"USER_GET_IMG_INFO_SUCCEED"]
#define USER_GET_IMG_INFO_FAIL [NSString stringWithFormat:@"USER_GET_IMG_INFO_FAIL"]

#define USER_GET_USERINFO_SUCCEED [NSString stringWithFormat:@"USER_GET_USERINFO_SUCCEED"]
#define USER_GET_USERINFO_FAIL [NSString stringWithFormat:@"USER_GET_USERINFO_FAIL"]

#define USER_GET_IDOLLIST_SUCCEED [NSString stringWithFormat:@"USER_GET_IDOLLIST_SUCCEED"]
#define USER_GET_IDOLLIST_FAIL [NSString stringWithFormat:@"USER_GET_IDOLLIST_FAIL"]

#define USER_FOCUS_ON_SUCCEED [NSString stringWithFormat:@"USER_FOCUS_ON_SUCCEED"]
#define USER_FOCUS_ON_FAIL [NSString stringWithFormat:@"USER_FOCUS_ON_FAIL"]

#define USER_CANCEL_FOCUS_SUCCEED [NSString stringWithFormat:@"USER_CANCEL_FOCUS_SUCCEED"]
#define USER_CANCEL_FOCUS_FAIL [NSString stringWithFormat:@"USER_CANCEL_FOCUS_FAIL"]

#define USER_REPORT_SUCCEED [NSString stringWithFormat:@"USER_REPORT_SUCCEED"]
#define USER_REPORT_FAIL [NSString stringWithFormat:@"USER_REPORT_FAIL"]

#define USER_EDIT_BABYS_SUCCEED [NSString stringWithFormat:@"USER_EDIT_BABYS_SUCCEED"]
#define USER_EDIT_BABYS_FAIL [NSString stringWithFormat:@"USER_EDIT_BABYS_FAIL"]

#define USER_DELETE_BABY_SUCCEED [NSString stringWithFormat:@"USER_DELETE_BABY_SUCCEED"]
#define USER_DELETE_BABY_FAIL [NSString stringWithFormat:@"USER_DELETE_BABY_FAIL"]

#define USER_GET_MESSLIST_SUCCEED [NSString stringWithFormat:@"USER_GET_MESSLIST_SUCCEED"]
#define USER_GET_MESSLIST_FAIL [NSString stringWithFormat:@"USER_GET_MESSLIST_FAIL"]

#define USER_GET_MESSCOUNT_SUCCEED [NSString stringWithFormat:@"USER_GET_MESSCOUNT_SUCCEED"]
#define USER_GET_MESSCOUNT_FAIL [NSString stringWithFormat:@"USER_GET_MESSCOUNT_FAIL"]

#define USER_MESS_COUNT_CHANGE [NSString stringWithFormat:@"USER_MESS_COUNT_CHANGE"]

#define USER_UPLOAD_PHOTOS_SUCCEED [NSString stringWithFormat:@"USER_UPLOAD_PHOTOS_SUCCEED"]
#define USER_UPLOAD_PHOTOS_FAIL [NSString stringWithFormat:@"USER_UPLOAD_PHOTOS_FAIL"]

#define USER_AGREE_SHARE_SUCCEED [NSString stringWithFormat:@"USER_AGREE_SHARE_SUCCEED"]
#define USER_AGREE_SHARE_FAIL [NSString stringWithFormat:@"USER_AGREE_SHARE_FAIL"]

//删除图片成功通知
#define DELETE_IMAGE_SUCCEED  [NSString stringWithFormat:@"DELETE_IMAGE_SUCCEED"]

//删除后刷新MWPhotoBrowser
#define REFRESH_MWPHOTO_BROWSER    [NSString stringWithFormat:@"REFRESH_MWPHOTO_BROWSER"]

//修改备注成功通知
#define RENAME_REMARK_SUCCEED  [NSString stringWithFormat:@"RENAME_REMARK_SUCCEED"]

//MWPhotoBrowser更新title
#define REFRESH_NAVI_TITLE    [NSString stringWithFormat:@"REFRESH_NAVI_TITLE"]

//在MWPhotoBrowser中通知加载更多
#define NOTI_TO_LOAD_MORE  [NSString stringWithFormat:@"NOTI_TO_LOAD_MORE"]
#define NOTI_AFTER_LOAD_MORE    [NSString stringWithFormat:@"NOTI_AFTER_LOAD_MORE"]

#define USER_GET_SHARE_LIST_SUCCEED [NSString stringWithFormat:@"USER_GET_SHARE_LIST_SUCCEED"]
#define USER_GET_SHARE_LIST_FAIL [NSString stringWithFormat:@"USER_GET_SHARE_LIST_FAIL"]

#define USER_CANCEL_SHARE_SUCCEED [NSString stringWithFormat:@"USER_CANCEL_SHARE_SUCCEED"]
#define USER_CANCEL_SHARE_FAIL [NSString stringWithFormat:@"USER_CANCEL_SHARE_FAIL"]

//修改评论或者回复:pppp的状态
#define CHANGE_STATE_NOTI [NSString stringWithFormat:@"CHANGE_STATE_NOTI"]

#define USER_DELETE_SHOW_SUCCEED [NSString stringWithFormat:@"USER_DELETE_SHOW_SUCCEED"]
#define USER_DELETE_SHOW_FAIL [NSString stringWithFormat:@"USER_DELETE_SHOW_FAIL"]

#define USER_DELETE_REVIEW_SUCCEED [NSString stringWithFormat:@"USER_DELETE_REVIEW_SUCCEED"]
#define USER_DELETE_REVIEW_FAIL [NSString stringWithFormat:@"USER_DELETE_REVIEW_FAIL"]

//我的秀秀，刷新评论
#define USER_MYSHOWGET_REFRESH_REVIEW_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWGET_REFRESH_REVIEW_SUCCEED"]
#define USER_MYSHOWGET_REFRESH_REVIEW_FAIL [NSString stringWithFormat:@"USER_MYSHOWGET_REFRESH_REVIEW_FAIL"]

//游客模式，获取数据
#define USER_GET_VISITOR_MESSAGE_SUCCEED [NSString stringWithFormat:@"USER_GET_VISITOR_MESSAGE_SUCCEED"]
#define USER_GET_VISITOR_MESSAGE_FAIL [NSString stringWithFormat:@"USER_GET_VISITOR_MESSAGE_FAIL"]

//贴吧，获取数据
#define USER_GET_POSTBAR_DATA_SUCCEED [NSString stringWithFormat:@"USER_GET_POSTBAR_DATA_SUCCEED"]
#define USER_GET_POSTBAR_DATA_FAIL [NSString stringWithFormat:@"USER_GET_POSTBAR_DATA_FAIL"]

//贴吧，刷新某组数据
#define USER_REFRESH_POSTBAR_DATA_SUCCEED [NSString stringWithFormat:@"USER_REFRESH_POSTBAR_DATA_SUCCEED"]
#define USER_REFRESH_POSTBAR_DATA_FAIL [NSString stringWithFormat:@"USER_REFRESH_POSTBAR_DATA_FAIL"]

//贴吧，我收藏的帖子列表数据
#define USER_GET_POSTBAR_MYFOCUS_SUCCEED [NSString stringWithFormat:@"USER_GET_POSTBAR_MYFOCUS_SUCCEED"]
#define USER_GET_POSTBAR_MYFOCUS_FAIL [NSString stringWithFormat:@"USER_GET_POSTBAR_MYFOCUS_FAIL"]

//贴吧，贴吧收藏帖子
#define USER_POSTBAR_ADDTOBEMYFOCUS_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_ADDTOBEMYFOCUS_SUCCEED"]
#define USER_POSTBAR_ADDTOBEMYFOCUS_FAIL [NSString stringWithFormat:@"USER_POSTBAR_ADDTOBEMYFOCUS_FAIL"]

//贴吧，贴吧取消收藏帖子
#define USER_POSTBAR_CANCELFOCUS_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_CANCELFOCUS_SUCCEED"]
#define USER_POSTBAR_CANCELFOCUS_FAIL [NSString stringWithFormat:@"USER_POSTBAR_CANCELFOCUS_FAIL"]

//贴吧，贴吧顶部header
#define USER_POSTBAR_GET_HEADER_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_GET_HEADER_SUCCEED"]
#define USER_POSTBAR_GET_HEADER_FAIL [NSString stringWithFormat:@"USER_POSTBAR_GET_HEADER_FAIL"]

//妈妈值得买
#define USER_WORTHBUY_DATA_SUCCEED [NSString stringWithFormat:@"USER_WORTHBUY_DATA_SUCCEED"]
#define USER_WORTHBUY_DATA_FAIL [NSString stringWithFormat:@"USER_WORTHBUY_DATA_FAIL"]
//妈妈值得买的新版首页
#define USER_WORTHBUYNEWLIST_DATA_SUCCEED [NSString stringWithFormat:@"USER_WORTHBUYNEWLIST_DATA_SUCCEED"]
#define USER_WORTHBUYNEWLIST_DATA_FAIL [NSString stringWithFormat:@"USER_WORTHBUYNEWLIST_DATA_FAIL"]



//妈妈值得买-赞
#define USER_WORTHBUY_PRAISE_SUCCEED [NSString stringWithFormat:@"USER_WORTHBUY_PRAISE_SUCCEED"]
#define USER_WORTHBUY_PRAISE_FAIL [NSString stringWithFormat:@"USER_WORTHBUY_PRAISE_FAIL"]

//贴吧发帖
#define USER_POSTBAR_ADD_TOPPIC_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_ADD_TOPPIC_SUCCEED"]
#define USER_POSTBAR_ADD_TOPPIC_FAIL [NSString stringWithFormat:@"USER_POSTBAR_ADD_TOPPIC_FAIL"]
//值得买：发帖成功刷新通知
#define WORTHBUY_ADDTOPIC_SUCCEED_WITH_CLASS [NSString stringWithFormat:@"WORTHBUY_ADDTOPIC_SUCCEED_WITH_CLASS"]

//我的秀秀3.2版
#define USER_MYSHOWNEW_GET_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWNEW_GET_SUCCEED"]
#define USER_MYSHOWNEW_GET_FAIL [NSString stringWithFormat:@"USER_MYSHOWNEW_GET_FAIL"]



//热点新版
#define USER_POSTBAR_NEW_GET_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_NEW_GET_SUCCEED"]
#define USER_POSTBAR_NEW_GET_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_GET_FAIL"]

//热点新版详情
#define USER_POSTBARDETAIL_NEW_GET_SUCCEED [NSString stringWithFormat:@"USER_POSTBARDETAIL_NEW_GET_SUCCEED"]
#define USER_POSTBARDETAIL_NEW_GET_FAIL [NSString stringWithFormat:@"USER_POSTBARDETAIL_NEW_GET_FAIL"]

//热点新版只看楼主
#define USER_POSTBARDETAIL_NEW_ONLYHOST_GET_SUCCEED [NSString stringWithFormat:@"USER_POSTBARDETAIL_NEW_ONLYHOST_GET_SUCCEED"]
#define USER_POSTBARDETAIL_NEW_ONLYHOST_GET_FAIL [NSString stringWithFormat:@"USER_POSTBARDETAIL_NEW_ONLYHOST_GET_FAIL"]

//热点新版发帖
#define USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED"]
#define USER_POSTBAR_NEW_MAKE_A_POST_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_MAKE_A_POST_FAIL"]
//群里发帖通知

#define USER_POSTBAR_NEW_MAKE_A_GROUPPOST_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_NEW_MAKE_A_GROUPPOST_SUCCEED"]
#define USER_POSTBAR_NEW_MAKE_A_GROUPPOST_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_MAKE_A_GROUPPOST_FAIL"]


//正在发布
#define USER_POSTBAR_NEW_MAKE_A_POSTING_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_NEW_MAKE_A_POSTING_SUCCEED"]

//话题里面评论详情
#define USER_POST_REVIEW_MAKE_A_SUCCEED [NSString stringWithFormat:@"USER_POST_REVIEW_MAKE_A_SUCCEED"]
#define USER_POST_REVIEW_MAKE_A_FAIL [NSString stringWithFormat:@"USER_POST_REVIEW_MAKE_A_FAIL"]

//热点新版刷新评论
#define USER_POSTBAR_NEW_REFRESH_REVIEWS_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_NEW_REFRESH_REVIEWS_SUCCEED"]
#define USER_POSTBAR_NEW_REFRESH_REVIEWS_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_REFRESH_REVIEWS_FAIL"]

//热点新版headerView
#define USER_POSTBAR_NEW_HEADERVIEW_GET_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_NEW_HEADERVIEW_GET_SUCCEED"]
#define USER_POSTBAR_NEW_HEADERVIEW_GET_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_HEADERVIEW_GET_FAIL"]

//成长日记一键导入
#define IMPORT_TO_DIARY_SUCCEED [NSString stringWithFormat:@"IMPORT_TO_DIARY_SUCCEED"]
#define IMPORT_TO_DIARY_FAIL    [NSString stringWithFormat:@"IMPORT_TO_DIARY_FAIL"]

//成长日记列表
#define USER_DIARY_ALBUM_LIST_SUCCEED [NSString stringWithFormat:@"USER_DIARY_ALBUM_LIST_SUCCEED"]
#define USER_DIARY_ALBUM_LIST_FAIL    [NSString stringWithFormat:@"USER_DIARY_ALBUM_LIST_FAIL"]

//成长日记详情列表
#define USER_DIARY_IMGS_LIST_SUCCEED [NSString stringWithFormat:@"USER_DIARY_IMGS_LIST_SUCCEED"]
#define USER_DIARY_IMGS_LIST_FAIL    [NSString stringWithFormat:@"USER_DIARY_IMGS_LIST_FAIL"]

//成长日记修改列表
#define USER_UPDATE_DIARY_LIST_SUCCEED [NSString stringWithFormat:@"USER_UPDATE_DIARY_LIST_SUCCEED"]
#define USER_UPDATE_DIARY_LIST_FAIL    [NSString stringWithFormat:@"USER_UPDATE_DIARY_LIST_FAIL"]

//成长日记修改操作
#define USER_UP_DIARY_SUCCEED          [NSString stringWithFormat:@"USER_UP_DIARY_SUCCEED"]
#define USER_UP_DIARY_FAIL             [NSString stringWithFormat:@"USER_UP_DIARY_FAIL"]
//成长日记修改操作
#define USER_UP_BABYSIDOLCOMBINE_SUCCEED          [NSString stringWithFormat:@"USER_UP_BABYSIDOLCOMBINE_SUCCEED"]
#define USER_UP_BABYSIDOLCOMBINE_FAIL             [NSString stringWithFormat:@"USER_UP_BABYSIDOLCOMBINE_FAIL"]

//添加孩子头像
#define ADD_BABY_AVATAR_SUCCEED          [NSString stringWithFormat:@"ADD_BABY_AVATAR_SUCCEED"]
#define ADD_BABY_AVATAR_FAIL             [NSString stringWithFormat:@"ADD_BABY_AVATAR_FAIL"]

//专题轮播图
#define USER_MYSHOWSPECIALHEADLIST_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWSPECIALHEADLIST_SUCCEED"]
#define USER_MYSHOWSPECIALHEADLIST_FAIL [NSString stringWithFormat:@"USER_MYSHOWSPECIALHEADLIST_FAIL"]

//更多主题
#define USER_MYSHOWSPECIALLIST_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWSPECIALLIST_SUCCEED"]
#define USER_MYSHOWSPECIALLIST_FAIL [NSString stringWithFormat:@"USER_MYSHOWSPECIALLIST_FAIL"]
//专题详情
#define USER_MYSHOWSPECIALDETAIL_GET_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWSPECIALDETAIL_GET_SUCCEED"]
#define USER_MYSHOWSPECIALDETAIL_GET_FAIL [NSString stringWithFormat:@"USER_MYSHOWSPECIALDETAIL_GET_FAIL"]
//删除专题
#define USER_DEL_SPECIAL_SUCCEED [NSString stringWithFormat:@"USER_DELSPECIAL_POST_SUCCEED"]
#define USER_DEL_SPECIAL_FAIL [NSString stringWithFormat:@"USER_DELSPECIAL_POST_FAIL"]
//专题详情照片墙
#define USER_MYSHOWSPECIALDETAILGRID_GET_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWSPECIALDETAILGRID_GET_SUCCEED"]
#define USER_MYSHOWSPECIALDETAILGRID_GET_FAIL [NSString stringWithFormat:@"USER_MYSHOWSPECIALDETAILGRID_GET_FAIL"]
//我的兴趣广场
#define USER_POSTMYINTEREST_GET_SUCCEED [NSString stringWithFormat:@"USER_POSTMYINTEREST_GET_SUCCEED"]
#define USER_POSTMYINTEREST_GET_FAIL [NSString stringWithFormat:@"USER_POSTMYINTEREST_GET_FAIL"]

//热点更多的群和帖

#define USER_POSTMYINTERESTLIST_GET_SUCCEED [NSString stringWithFormat:@"USER_POSTMYINTERESTLIST_GET_SUCCEED"]
#define USER_POSTMYINTERESTLIST_GET_FAIL [NSString stringWithFormat:@"USER_POSTMYINTERESTLIST_GET_FAIL"]


//广场新版分类
#define USER_POSTLISTV5_GET_SUCCEED [NSString stringWithFormat:@"USER_POSTLISTV5_GET_SUCCEED"]
#define USER_POSTLISTV5_GET_FAIL [NSString stringWithFormat:@"USER_POSTLISTV5_GET_FAIL"]
//圈子详情
#define USER_GROUPDETAILLIST_GET_SUCCEED [NSString stringWithFormat:@"USER_GROUPDETAILLIST_GET_SUCCEED"]
#define USER_GROUPDETAILLIST_GET_FAIL [NSString stringWithFormat:@"USER_GROUPDETAILLIST_GET_FAIL"]

//圈子添加关注（改前的通知名）
#define USER_POSTBAR_NEW_POSTIDOL_SUCCEED [NSString stringWithFormat:@"USER_POSTBAR_NEW_POSTIDOL_SUCCEED"]
#define USER_POSTBAR_NEW_POSTIDOL_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_POSTIDOL_FAIL"]
//圈子添加关注（改后的通知名）
#define USER_POSTBAR_NEW_POSTIDOLS_SUCCEED [NSString stringWithFormat:@" USER_POSTBAR_NEW_POSTIDOLS_SUCCEED"]
#define USER_POSTBAR_NEW_POSTIDOLS_FAIL [NSString stringWithFormat:@"SER_POSTBAR_NEW_POSTIDOLS_FAIL"]


//圈子取消关注
#define USER_POSTBAR_NEW_CANCELPOSTIDOL_SUCCEED [NSString stringWithFormat:@" USER_POSTBAR_NEW_CANCELPOSTIDOL_SUCCEED"]
#define USER_POSTBAR_NEW_CANCELPOSTIDOL_FAIL [NSString stringWithFormat:@"SER_POSTBAR_NEW_CANCELPOSTIDOL_FAIL"]
//合并成功
#define USER_DIARY_COMBINESENDMAIL_SUCCEED [NSString stringWithFormat:@"USER_DIARY_COMBINESENDMAIL_SUCCEED"]
//合并失败
#define USER_DIARY_COMBINESENDMAIL_FAIL    [NSString stringWithFormat:@"USER_DIARY_COMBINESENDMAIL_FAIL"]
//同意合并成功
#define USER_DIARY_COMBINEDIARY_SUCCEED [NSString stringWithFormat:@"USER_DIARY_COMBINEDIARY_SUCCEED"]
//同意合并失败
#define USER_DIARY_COMBINEDIARY_FAIL    [NSString stringWithFormat:@"USER_DIARY_COMBINEDIARY_FAIL"]
//群里置顶某个帖子失败
#define USER_POSTBAR_NEW_TOPGROUPPOST_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_TOPGROUPPOST_FAIL"]
//群里删除和置顶成功某个帖子
#define USER_POSTBAR_NEW_DELGROUPPOST_SUCCEED [NSString stringWithFormat:@" USER_POSTBAR_NEW_DELGROUPPOST_SUCCEED"]
//群里删除某个帖子失败的方法
#define USER_POSTBAR_NEW_DELGROUPPOST_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_DELGROUPPOST_FAIL"]
//群里改群名的成功和失败
#define USER_POSTBAR_NEW_DOGROUP_SUCCEED [NSString stringWithFormat:@" USER_POSTBAR_NEW_DOGROUP_SUCCEED"]
#define USER_POSTBAR_NEW_DOGROUP_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_DOGROUP_FAIL"]
//点击更多优惠商家列表成功和失败的方法
#define USER_POSTBAR_NEW_GETBUSINESSLIST_SUCCEED [NSString stringWithFormat:@" USER_POSTBAR_NEW_GETBUSINESSLIST_SUCCEED"]
#define USER_POSTBAR_NEW_GETBUSINESSLIST_FAIL [NSString stringWithFormat:@"USER_POSTBAR_NEW_GETBUSINESSLIST_FAIL"]

//我的订单列表

#define USER_ORDER_MYORDER_GETMYORDERLIST_SUCCEED [NSString stringWithFormat:@" USER_ORDER_MYORDER_GETMYORDERLIST_SUCCEED"]
#define USER_ORDER_MYORDER_GETMYORDERLIST_FAIL [NSString stringWithFormat:@"USER_ORDER_MYORDER_GETMYORDERLIST_FAIL"]

//商家订单

#define USER_ORDER_BUSINESS_GETMYORDERLIST_SUCCEED [NSString stringWithFormat:@" USER_ORDER_BUSINESS_GETMYORDERLIST_SUCCEED"]
#define USER_ORDER_BUSINESS_GETMYORDERLIST_FAIL [NSString stringWithFormat:@"USER_ORDER_BUSINESS_GETMYORDERLIST_FAIL"]
//商家评价订单
#define USER_ORDER_BUSINESS_GETCOMMENTLIST_SUCCEED [NSString stringWithFormat:@" USER_ORDER_BUSINESS_GETCOMMENTLIST_SUCCEED"]
#define USER_ORDER_BUSINESS_GETCOMMENTLIST_FAIL [NSString stringWithFormat:@" USER_ORDER_BUSINESS_GETCOMMENTLIST_FAIL"]


//商家验证
#define USER_ORDER_BUSINESS_GETBUSINESSVERIFICATION_SUCCEED [NSString stringWithFormat:@" USER_ORDER_BUSINESS_GETMYORDERLISTGETBUSINESSVERIFICATION_SUCCEED"]
#define USER_ORDER_BUSINESS_GETBUSINESSVERIFICATION_FAIL [NSString stringWithFormat:@"USER_ORDER_BUSINESS_GETBUSINESSVERIFICATION_FAIL"]
//微信支付得回调通知
#define USER_WEIXINPAY_SUCCEED [NSString stringWithFormat:@"USER_WEIXINPAY_SUCCEED"]
#define USER_WEIXINPAY_FAIL [NSString stringWithFormat:@"USER_WEIXINPAY_FAIL"]

//好友动态
#define  USER_MYHOMEPAGE_MYFRIEND_SUCCEED [NSString stringWithFormat:@" USER_MYHOMEPAGE_MYFRIEND_SUCCEED"]
#define  USER_MYHOMEPAGE_MYFRIEND_FAIL [NSString stringWithFormat:@" USER_MYHOMEPAGE_MYFRIEND_FAIL"]

//首页专题改版11。16
#define USER_MYSHOWSPECIANEW_SPECIALREVISION_SUCCEED [NSString stringWithFormat:@"USER_MYSHOWSPECIANEW_SPECIALREVISION_SUCCEED"]
#define USER_MYSHOWSPECIANEW_SPECIALREVISION_FAIL [NSString stringWithFormat:@"USER_MYSHOWSPECIANEW_SPECIALREVISION_FAIL"]
//红包列表
#define USER_MYHOME_PACKLIST_SUCCEED [NSString stringWithFormat:@"USER_MYHOME_PACKLIST_SUCCEED"]
#define USER_MYHOME_PACKLIST_FAIL [NSString stringWithFormat:@"USER_MYHOME_PACKLIST_FAIL"]

//个人中心取消成长记录关注
#define USER_MYHOME_CANCELFOUCE_SUCCEED [NSString stringWithFormat:@"USER_MYHOME_CANCELFOUCE_SUCCEED"]
#define USER_MYHOME_CANCELFOUCE_FAIL [NSString stringWithFormat:@"USER_MYHOME_CANCELFOUCE_FAIL"]

//群主管理的精华或公告
#define USER_POST_NOTICERECGROUPLIST_SUCCEED [NSString stringWithFormat:@"USER_POST_NOTICERECGROUPLIST_SUCCEED"]
#define USER_POST_NOTICERECGROUPLIST_FAIL [NSString stringWithFormat:@"USER_POST_NOTICERECGROUPLIST_FAIL"]

//登陆状态的成功
#define USER_LOGIN_HTML_SUCCEED [NSString stringWithFormat:@"USER_LOGIN_HTML_SUCCEED"]

//用户支付玩具订单成功
#define USER_TOY_PAY_SUCCEED [NSString stringWithFormat:@"USER_TOY_PAY_SUCCEED"]
//用户支付玩具批次订单成功
#define USER_TOY_PAYCOMBINE_SUCCEED [NSString stringWithFormat:@"USER_TOY_PAYCOMBINE_SUCCEED"]











/***********************************************************************************************************************/

#pragma mark - 网络解析字段
/**
 *  接口返回字段
 */
#define kBBSSuccess     @"success"
#define kBBSReCode      @"reCode"
#define kBBSReMsg       @"reMsg"
#define kBBSData        @"data"
//相册中字体的颜色
#define kAlbum_Color    @"8f826d"
#define kCOLORRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000)>>16))/255.0 green:((float)((rgbValue & 0xFF00)>>8))/255.0  blue:((float)((rgbValue & 0xFF)))/255.0  alpha:1.0]
#define KColorRGB(r,g,b,a)  [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
/***********************************************************************************************************************/
/*
 * Top-level identifiers 唯一标示符
 */
#define	CTL_UNSPEC	0		/* unused */
#define	CTL_KERN	1		/* "high kernel": proc, limits */
#define	CTL_VM		2		/* virtual memory */
#define	CTL_VFS		3		/* file system, mount type is next */
#define	CTL_NET		4		/* network, see socket.h */
#define	CTL_DEBUG	5		/* debugging parameters */
#define	CTL_HW		6		/* generic cpu/io */
#define	CTL_MACHDEP	7		/* machine dependent */
#define	CTL_USER	8		/* user-level */
#define	CTL_MAXID	9		/* number of valid top-level ids */
#define	AF_LINK		18		/* Link layer interface */
#define	PF_ROUTE	AF_ROUTE
#define NET_RT_IFLIST		3	/* survey interface list */
#define	AF_ROUTE	17		/* Internal Routing Protocol */
#endif


//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))
//屏幕 rect
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))
#define SCREEN_RECT ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)
