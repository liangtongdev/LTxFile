//
//  LTxFilePreviewVideoSlider.m
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import "LTxFilePreviewVideoSlider.h"

@implementation LTxFilePreviewVideoSlider

- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(LTxFilePreviewSliderPadding, CGRectGetHeight(bounds) / 2 - 2, CGRectGetWidth(self.frame) - ( LTxFilePreviewSliderTimeWidth + LTxFilePreviewSliderPadding + LTxFilePreviewTimePadding), 4);
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _timeL = [[UILabel alloc] init];
        [self addSubview:_timeL];
        _timeL.textColor = [UIColor whiteColor];
        _timeL.font = [UIFont systemFontOfSize:14.f];
        _timeL.textAlignment = NSTextAlignmentCenter;
        
//        self.thumbTintColor = [UIColor blueColor];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    _timeL.frame = CGRectMake(CGRectGetWidth(rect) - LTxFilePreviewSliderTimeWidth - LTxFilePreviewTimePadding, 0, LTxFilePreviewSliderTimeWidth, CGRectGetHeight(rect));
}
@end
