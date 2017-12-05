//
//  TDTPhotoView.h
//  TDTPhotoTweaks
//  Heavily inspired from https://github.com/itouch2/PhotoTweaks

#import <UIKit/UIKit.h>

extern const CGFloat MaxRotationAngle;

@class TDTCropView;

@interface TDTPhotoContentView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@protocol TDTCropViewDelegate <NSObject>

- (void)tdt_CropEnded:(TDTCropView *)cropView;
- (void)tdt_CropMoved:(TDTCropView *)cropView;

@end

@interface TDTCropView : UIView
@end

@interface TDTPhotoTweakView : UIView

@property (nonatomic, assign, readonly) CGFloat angle;
@property (nonatomic, assign, readonly) CGPoint photoContentOffset;

@property (nonatomic, strong, readonly) TDTCropView *cropView;
@property (nonatomic, strong, readonly) TDTPhotoContentView *photoContentView;
@property (nonatomic, strong, readonly) UISlider *slider;
@property (nonatomic, strong, readonly) UIButton *resetBtn;


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
