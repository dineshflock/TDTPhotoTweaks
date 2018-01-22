//
//  TDTPhotoTweaksViewController.h
//  TDTPhotoTweaks
//  Heavily inspired from https://github.com/itouch2/PhotoTweaks

#import <UIKit/UIKit.h>

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
 Image to process.
 */
@property (nonatomic, strong, readonly) UIImage *image;

/**
 Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
 */
@property (nonatomic, assign) BOOL autoSaveToLibray;

/**
 Max rotation angle
 */
@property (nonatomic, assign) CGFloat maxRotationAngle;

/**
 The optional photo tweaks controller delegate.
 */
@property (nonatomic, weak) id<TDTPhotoTweaksViewControllerDelegate> delegate;

/**
 Save action button's default title color
 */
@property (nonatomic, strong) UIColor *saveButtonTitleColor;

/**
 Save action button's highlight title color
 */
@property (nonatomic, strong) UIColor *saveButtonHighlightTitleColor;

/**
 Cancel action button's default title color
 */
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;

/**
 Cancel action button's highlight title color
 */
@property (nonatomic, strong) UIColor *cancelButtonHighlightTitleColor;

/**
 Reset action button's default title color
 */
@property (nonatomic, strong) UIColor *resetButtonTitleColor;

/**
 Reset action button's highlight title color
 */
@property (nonatomic, strong) UIColor *resetButtonHighlightTitleColor;

/**
 Slider tint color
 */
@property (nonatomic, strong) UIColor *sliderTintColor;

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
- (void)tdt_PhotoTweaksController:(TDTPhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage;

/**
 Called on cropping image canceled
 */
- (void)tdt_PhotoTweaksControllerDidCancel:(TDTPhotoTweaksViewController *)controller;

@end
