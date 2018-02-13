//
//  TDTPhotoTweaksViewController.h
//  TDTPhotoTweaks
//  Heavily inspired from https://github.com/itouch2/PhotoTweaks

#import <UIKit/UIKit.h>
#import "TDTCropRatioOption.h"

@protocol TDTPhotoTweaksViewControllerDelegate;

/**
 The photo tweaks controller.
 */
@interface TDTPhotoTweaksViewController : UIViewController

/**
 Identifier for the controller.
 */
@property (nonatomic, copy) NSString *identifier;

/**
 Crop ratios for the controller.
 */
@property (nonatomic, copy) NSArray<TDTCropRatioOption *> *cropOptions;

/**
 Image to process.
 */
@property (nonatomic, strong, readonly) UIImage *image;

/**
 Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to NO.
 */
@property (nonatomic, assign) BOOL autoSaveToLibray;

/**
 Max rotation angle, Defauts to 45 Degrees
 */
@property (nonatomic, assign) CGFloat maxRotationAngle;

/**
 The optional photo tweaks controller delegate.
 */
@property (nonatomic, weak) id<TDTPhotoTweaksViewControllerDelegate> delegate;

/**
 Tint color of toolbar that displays options to rotate reset and ratios options.
 */
@property (nonatomic, strong) UIColor *tweakOptionToolbarTintColor;

/**
 Tint color of the toobar that dispalys options to cancel and finish up the tweaking
 */
@property (nonatomic, strong) UIColor *actionToolbarTintColor;

/**
 Creates a photo tweaks view controller with the image to process.
 */
- (instancetype)initWithImage:(UIImage *)image;

@end

/**
 The photo tweaks controller delegate
 */
@protocol TDTPhotoTweaksViewControllerDelegate <NSObject>

/**
 Called on image cropped.
 */
- (void)photoTweaksController:(TDTPhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage;

/**
 Called on cropping image canceled
 */
- (void)photoTweaksControllerDidCancel:(TDTPhotoTweaksViewController *)controller;

@optional

/**
 Called on RESET button tapped
 */
- (void)photoTweaksControllerDidReset:(TDTPhotoTweaksViewController *)controller;

/**
 Called on 90 degree rotation button tap
 */
- (void)photoTweaksControllerDidRotate:(TDTPhotoTweaksViewController *)controller;

/**
 Called on rotating the image using the compass
 */
- (void)photoTweaksControllerDidRotateSlider:(TDTPhotoTweaksViewController *)controller toAngle:(CGFloat)angle;

/**
 Called on locking the crop frame to an option
 */
- (void)photoTweaksController:(TDTPhotoTweaksViewController *)controller didLockCroppingToOption:(TDTCropRatioOption *)option;

@end
