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
- (void)tdt_PhotoTweaksController:(TDTPhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage;

/**
 Called on cropping image canceled
 */
- (void)tdt_PhotoTweaksControllerDidCancel:(TDTPhotoTweaksViewController *)controller;

@end
