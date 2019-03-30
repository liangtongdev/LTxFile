//
//  LTxFilePreviewVideoSlider.h
//  LTxFile
//
//  Created by liangtong on 2019/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define LTxFilePreviewSliderTimeWidth 90
#define LTxFilePreviewSliderPadding 20
#define LTxFilePreviewTimePadding 10
@interface LTxFilePreviewVideoSlider : UISlider
@property (nonatomic, strong) UILabel* timeL;
@end

NS_ASSUME_NONNULL_END
