//
//  LTxFilePreviewViewController.m
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import "LTxFilePreviewViewController.h"
#import <QuickLook/QuickLook.h>//文件预览
#import <AVFoundation/AVFoundation.h>//视频播放
#import <WebKit/WebKit.h>//网页预览
#import "LTxFilePreviewVideoSlider.h"//视频进度条
#import "LTxFileTypeCheck.h"
#import "LTxFilePreviewViewModel.h"

@interface LTxFilePreviewViewController ()<QLPreviewControllerDataSource,WKNavigationDelegate>
@property (nonatomic, strong) LTxFilePreviewViewModel* viewModel;

@property (nonatomic, strong) UILabel* tipsL;

/**QuickLook**/
@property (nonatomic, strong) QLPreviewController* qlPreviewVC;

/**音频/视频播放**/
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id avPlayerObserver;
@property (nonatomic, strong) LTxFilePreviewVideoSlider* playerSlider;//播放进度条

/**网页**/
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation LTxFilePreviewViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupFilePreviewDefaults];
    
    [self startPreviewFile];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self dellocQLPreview];
    [self dellocAVPlayer];
    [self dellocWebView];
    _viewModel = nil;
}
#pragma mark - 初始化
-(void)setupFilePreviewDefaults{
    self.view.backgroundColor = [UIColor whiteColor];
    _viewModel = [[LTxFilePreviewViewModel alloc] init];
    [self setupTipsView];
    
}

-(void)startPreviewFile{
    if (_filePath == nil) {
        _tipsL.text = @"文件不存在！";
        return;
    }
    LTxFileType fileType = [LTxFileTypeCheck fileTypeWithPath:[_filePath absoluteString]];
    
    switch (fileType) {
        case LTxFileTypeImage:
        case LTxFileTypeDocument:
        {
            [self setupDocumentPreviewView];
        }
            break;
            
        case LTxFileTypeVideo:
        {
            [self setupVideoPreviewView];
        }
            break;
            
        default:
        {
            [self setupWebPreviewView];
        }
            break;
    }
}

#pragma mark - 文档
-(void)setupDocumentPreviewView{
    if (_qlPreviewVC) {
        [_qlPreviewVC.view removeFromSuperview];
        [_qlPreviewVC removeFromParentViewController];
    }
    _qlPreviewVC = [[QLPreviewController alloc] init];
    _qlPreviewVC.dataSource = self;
    _qlPreviewVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:_qlPreviewVC];
    [self.view addSubview:_qlPreviewVC.view];
    [self ltxFilePreview_pinSubview:_qlPreviewVC.view parentView:self.view edgeInsets:UIEdgeInsetsZero];
}
- (void)dellocQLPreview{
    if (_qlPreviewVC) {
        _qlPreviewVC.delegate = nil;
        _qlPreviewVC = nil;
    }
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return _filePath;
}
#pragma mark - 视频
-(void)setupVideoPreviewView{
    self.view.backgroundColor = [UIColor blackColor];
    self.player = [AVPlayer playerWithURL:_filePath];
    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.playerLayer];
    self.playerLayer.player = _player;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self observeAVPlayerProgress];
    
    _playerSlider = [[LTxFilePreviewVideoSlider alloc] init];
    _playerSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_playerSlider];
    [self addAVPlayerSliderConstraint];
    [self.playerSlider addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAVPlayerGesture:)]];
    [self.playerSlider addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAVPlayerGesture:)]];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPauseVideo)]];
}

/*视频播放进度*/
-(void)observeAVPlayerProgress{
    __weak __typeof(self) weakSelf = self;
    _avPlayerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        NSInteger currentTimeSec = time.value / time.timescale;
        weakSelf.playerSlider.value = currentTimeSec;
        CMTime totalTime = weakSelf.player.currentItem.duration;
        NSInteger totalTimeSec = CMTimeGetSeconds(totalTime);
        weakSelf.playerSlider.maximumValue = totalTimeSec;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.playerSlider.timeL.text =[NSString stringWithFormat:@"%@/%@",[weakSelf descriptionWithSeconds:currentTimeSec],[weakSelf descriptionWithSeconds:totalTimeSec]];
        });
    }];
}
/*手势控制进度*/
- (void)handleAVPlayerGesture:(UIGestureRecognizer *)ges{
    if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIGestureRecognizerState state = ges.state;
        if (state == UIGestureRecognizerStateBegan) {
            [self pause];
        }else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
            [self play];
        }
    }
    if ([ges.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)ges.view;
        CGPoint point = [ges locationInView:slider];
        CGFloat length = slider.frame.size.width - LTxFilePreviewSliderTimeWidth - LTxFilePreviewSliderPadding;
        // 视频跳转的value
        CGFloat tapValue = point.x / length * slider.maximumValue;
        [self.player seekToTime:CMTimeMake(tapValue, 1)];
    }
}

/*续播*/
- (void)playFinished{
    [_player seekToTime:kCMTimeZero];
    [_player play];
}

- (void)play{
    [_player play];
}

- (void)pause{
    [_player pause];
}
-(void)playOrPauseVideo{
    if (_player.rate == 0.0f) {
        [self play];
    }else{
        [self pause];
    }
}

/**
 * 时间描述
 **/
-(NSString*)descriptionWithSeconds:(NSInteger)seconds{
    NSString* retString = [NSString stringWithFormat:@"%02ld:%02ld",seconds / 60,seconds % 60];
    return retString;
}

/*释放视频播放相关资源*/
- (void)dellocAVPlayer{
    if (_avPlayerObserver) {
        [self.player removeTimeObserver:_avPlayerObserver];
        _avPlayerObserver = nil;
    }
    [_player removeObserver:self forKeyPath:@"status"];
    [_player pause];
    _player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
}

#pragma mark - 网页
-(void)setupWebPreviewView{
    if (_webView) {
        [_webView removeFromSuperview];
    }
    _webView = [[WKWebView alloc] init];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:_filePath]];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [self ltxFilePreview_pinSubview:_webView parentView:self.view edgeInsets:UIEdgeInsetsZero];

    if (_progressView) {
        [_progressView removeFromSuperview];
    }
    CGFloat progressBarHeight = 5.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect progressFrame = CGRectMake(0, navigaitonBarBounds.size.height , navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[UIProgressView alloc] initWithFrame:progressFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.trackTintColor = [UIColor whiteColor];
    _progressView.progressTintColor = _progressTintColor ? _progressTintColor : [UIColor blueColor];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    self.tipsL.text = error.description;
}

- (void)dellocWebView{
    if (_progressView) {
        [_progressView removeFromSuperview];
    }
    if (_webView) {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView removeObserver:self forKeyPath:@"title"];
        _webView.navigationDelegate = nil;
        _webView = nil;
    }
}

#pragma mark - 提示
-(void)setupTipsView{
    if (!_tipsL) {
        _tipsL = [[UILabel alloc] init];
        _tipsL.translatesAutoresizingMaskIntoConstraints = NO;
        _tipsL.numberOfLines = 0;
        _tipsL.textAlignment = NSTextAlignmentCenter;
        _tipsL.textColor = [UIColor darkGrayColor];
        _tipsL.font = [UIFont systemFontOfSize:20];
        [self ltxFilePreview_pinSubview:_tipsL parentView:self.view edgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
}

#pragma mark - 监听
/*监听*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.player) {//视频播放器
        if ([keyPath isEqualToString:@"status"]) {
            if (_player.status == AVPlayerStatusReadyToPlay) {
                [self play];
            }else{
                
            }
        }
    }else if (object == self.webView){//网页
        if ([keyPath isEqualToString:@"title"]){
            if (!self.title) {
                self.title = self.webView.title;
            }
        }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            }else {
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 约束
- (void)ltxFilePreview_pinSubview:(UIView *)subview parentView:(UIView*)parentView edgeInsets:(UIEdgeInsets)edgeInsets{
    if (![subview.superview isEqual:parentView]) {
        [parentView addSubview:subview];
    }
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* leading = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.f constant:edgeInsets.left];
    NSLayoutConstraint* trailing = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-edgeInsets.right];
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:edgeInsets.top];
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottomMargin multiplier:1.f constant:edgeInsets.bottom];
    //激活
    [NSLayoutConstraint activateConstraints: @[leading,trailing,top,bottom]];
}
/**
 * 视频进度条约束
 ***/
-(void)addAVPlayerSliderConstraint{
    NSLayoutConstraint* cLeading = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* cTrailing = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* cBottom = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:40];
    //激活
    [NSLayoutConstraint activateConstraints: @[cLeading,cTrailing,cBottom,height]];
}

@end
