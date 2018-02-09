//
//  TDTPhotoView.h
//  TDTPhotoTweaks
//  Heavily inspired from https://github.com/itouch2/PhotoTweaks

#import <UIKit/UIKit.h>
#import "TDTCompassSlider.h"

extern const CGFloat MaxRotationAngle;

@class TDTCropView;
@class TDTPhotoTweakView;

@interface TDTPhotoContentView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@protocol TDTPhotoTweakViewChangeListner <NSObject>

- (void)photoTweakViewDidUndergoChange:(TDTPhotoTweakView *)photoTweakView;
- (void)photoTweakViewDidUndergoReset:(TDTPhotoTweakView *)photoTweakView;

@end

@protocol TDTCropViewDelegate <NSObject>

- (void)cropEnded:(TDTCropView *)cropView;
- (void)cropMoved:(TDTCropView *)cropView;
- (void)cropBegan:(TDTCropView *)cropView;

@end

@interface TDTCropView : UIView

- (void)lockToRatio:(CGFloat)ratio;

@end

@interface TDTPhotoTweakView : UIView

@property (nonatomic, assign, readonly) CGFloat angle;
@property (nonatomic, assign, readonly) CGPoint photoContentOffset;

@property (nonatomic, strong, readonly) TDTCropView *cropView;
@property (nonatomic, strong, readonly) TDTPhotoContentView *photoContentView;
@property (nonatomic, strong, readonly) TDTCompassSlider *slider;

@property (nonatomic, weak) id<TDTPhotoTweakViewChangeListner> changeListner;


- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
             maxRotationAngle:(CGFloat)maxRotationAngle;

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image;

- (CGPoint)photoTranslation;

- (void)rotateImage;
- (void)lockCropViewToRatio:(CGFloat)ratio;
- (void)reset;

@end
