//
//  TDTPhotoTweaksViewController.m
//  TDTPhotoTweaks
//  Heavily inspired from https://github.com/itouch2/PhotoTweaks

#import "TDTPhotoTweaksViewController.h"
#import "TDTPhotoTweakView.h"
#import "UIColor+TDTTweak.h"
#import <AssetsLibrary/AssetsLibrary.h>

static const CGFloat DefaultToolbarHeight = 44.0;

static NSString * const BarButtonTitleCancel = @"Cancel";
static NSString * const BarButtonTitleDone = @"Done Cropping";
static NSString * const BarButtonTitleReset = @"RESET";

@interface TDTPhotoTweaksViewController () <TDTPhotoTweakViewChangeListner>

@property (strong, nonatomic) TDTPhotoTweakView *photoView;
@property (strong, nonatomic) UIToolbar *actionToolbar;
@property (strong, nonatomic) UIToolbar *tweakOptionToolbar;

@property (strong, nonatomic) UIBarButtonItem *resetTweakOptionBarButton;

@end

@implementation TDTPhotoTweaksViewController

- (instancetype)initWithImage:(UIImage *)image {
  if (self = [super init]) {
    _image = image;
    _autoSaveToLibray = NO;
    _maxRotationAngle = MaxRotationAngle;
    _cropOptions = [self defaultCropOptions];
  }
  return self;
}

- (NSArray *)defaultCropOptions {
  NSMutableArray *array = [NSMutableArray new];
  [array addObject:[[TDTCropRatioOption alloc] initWithName:@"Original" widthHeightRatio:self.image.size.width/self.image.size.height]];
  [array addObject:[[TDTCropRatioOption alloc] initWithName:@"Square" widthHeightRatio:1.0]];
  [array addObject:[[TDTCropRatioOption alloc] initWithName:@"3:2" widthHeightRatio:3.0/2.0]];
  [array addObject:[[TDTCropRatioOption alloc] initWithName:@"4:3" widthHeightRatio:4.0/3.0]];
  [array addObject:[TDTCropRatioOption cropOptionNone]];
  return array;
}


-(void)setTweakOptionToolbarTintColor:(UIColor *)tweakOptionToolbarTintColor {
  _tweakOptionToolbarTintColor = tweakOptionToolbarTintColor;
  [self.tweakOptionToolbar setTintColor:tweakOptionToolbarTintColor];
}

-(void)setActionToolbarTintColor:(UIColor *)actionToolbarTintColor {
  _actionToolbarTintColor = actionToolbarTintColor;
  [self.actionToolbar setTintColor:actionToolbarTintColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBarHidden = YES;
  
  if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  self.view.clipsToBounds = YES;
  self.view.backgroundColor = [UIColor photoTweakCanvasBackgroundColor];
  
  [self setupSubviews];
}

- (void)setupToolbar {
  CGRect rect = CGRectMake(0,
                           CGRectGetHeight(self.view.bounds) - DefaultToolbarHeight,
                           CGRectGetWidth(self.view.bounds),
                           DefaultToolbarHeight);
  self.actionToolbar = [[UIToolbar alloc] initWithFrame:rect];
  [self.actionToolbar setTintColor:self.actionToolbarTintColor];
  [self.actionToolbar setTranslucent:NO];
  self.actionToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:self.actionToolbar];
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:BarButtonTitleCancel
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelButtonTapped)];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:BarButtonTitleDone
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(saveButtonTapped)];
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  [self.actionToolbar setItems:@[cancelButton, flexibleSpace, doneButton]];
}

- (void)setupOptionsToolbar {
  CGRect rect = CGRectMake(0,
                           CGRectGetHeight(self.view.bounds) - 2*DefaultToolbarHeight,
                           CGRectGetWidth(self.view.bounds),
                           DefaultToolbarHeight);
  self.tweakOptionToolbar = [[UIToolbar alloc] initWithFrame:rect];
  [self.tweakOptionToolbar setTintColor:self.tweakOptionToolbarTintColor];
  [self.tweakOptionToolbar setTranslucent:YES];
  [self.tweakOptionToolbar setClipsToBounds:YES];
  [self.tweakOptionToolbar setBackgroundImage:[UIImage new]
                           forToolbarPosition:UIToolbarPositionAny
                                   barMetrics:UIBarMetricsDefault];
  [self.tweakOptionToolbar setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
  
  [self.view addSubview:self.tweakOptionToolbar];
  
  UIImage *rotateImage = [UIImage imageNamed:@"rotate"
                                    inBundle:[NSBundle bundleForClass:[self class]]
               compatibleWithTraitCollection:nil];
  
  UIImage *ratioImage = [UIImage imageNamed:@"ratio"
                                   inBundle:[NSBundle bundleForClass:[self class]]
              compatibleWithTraitCollection:nil];
  
  UIBarButtonItem *rotateOptionButton = [[UIBarButtonItem alloc] initWithImage:rotateImage
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(rotateButtonTapped)];
  
  UIBarButtonItem *ratioOptionButton = [[UIBarButtonItem alloc] initWithImage:ratioImage
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(ratioButtonTapped)];
  
  UIBarButtonItem *flexibleSpaceOne = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *flexibleSpaceTwo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  [self.tweakOptionToolbar setItems:@[rotateOptionButton, flexibleSpaceOne, flexibleSpaceTwo, ratioOptionButton]];
}

- (void)hideResetBarButton:(BOOL)hidden {
  if (hidden && [self.tweakOptionToolbar.items containsObject:self.resetTweakOptionBarButton]) {
    NSMutableArray *items = self.tweakOptionToolbar.items.mutableCopy;
    [items removeObject:self.resetTweakOptionBarButton];
    [self.tweakOptionToolbar setItems:items animated:NO];
  } else if (!hidden && ![self.tweakOptionToolbar.items containsObject:self.resetTweakOptionBarButton]) {
    NSMutableArray *items = self.tweakOptionToolbar.items.mutableCopy;
    [items insertObject:self.resetTweakOptionBarButton atIndex:2];
    [self.tweakOptionToolbar setItems:items animated:NO];
  }
}

- (UIBarButtonItem *)resetTweakOptionBarButton {
  if (_resetTweakOptionBarButton != nil) {
    return _resetTweakOptionBarButton;
  }
  _resetTweakOptionBarButton = [[UIBarButtonItem alloc] initWithTitle:BarButtonTitleReset
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(resetButtonTapped)];
  NSUInteger fontSize = 14.0;
  UIFont *font = [UIFont systemFontOfSize:fontSize];
  NSDictionary *attributes = @{NSFontAttributeName: font};
  [_resetTweakOptionBarButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
  return _resetTweakOptionBarButton;
}

- (void)rotateButtonTapped {
  [self.photoView rotateImage];
}

- (void)ratioButtonTapped {
  if (self.cropOptions.count <= 0) {
    return;
  }
  UIAlertController *optionsVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
  for (TDTCropRatioOption *option in self.cropOptions) {
    __weak typeof(self) weakSelf = self;
    [optionsVC addAction:[UIAlertAction actionWithTitle:option.name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                  [weakSelf.photoView lockCropViewToRatio:option.widthToHeightRatio];
                                                }]];
  }
  [optionsVC addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                style:UIAlertActionStyleCancel
                                              handler:NULL]];
  [self presentViewController:optionsVC animated:YES completion:NULL];
}

- (void)resetButtonTapped {
  [self.photoView reset];
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  BOOL isOrientationChange = (self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass) || (self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass);
  if (isOrientationChange && self.photoView != nil) {
    [self.photoView removeFromSuperview];
    [self setupPhotoView];
  }
}

- (void)setupSubviews {
  [self setupPhotoView];
  [self setupOptionsToolbar];
  [self setupToolbar];
}

-(void)setupPhotoView {
  self.photoView = [[TDTPhotoTweakView alloc] initWithFrame:self.view.bounds image:self.image maxRotationAngle:self.maxRotationAngle];
  self.photoView.changeListner = self;
  self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.view insertSubview:self.photoView atIndex:0];
}

- (TDTCropRatioOption *)ratioOptionWithWidthToHeightRatio:(CGFloat)ratio inArray:(NSArray *)array {
  for (TDTCropRatioOption *option in array) {
    if (option.widthToHeightRatio == ratio) {
      return option;
    }
  }
  return nil;
}

- (void)cancelButtonTapped {
  [self.delegate photoTweaksControllerDidCancel:self];
}

- (void)saveButtonTapped {
  CGAffineTransform transform = CGAffineTransformIdentity;
  
  // translate
  CGPoint translation = [self.photoView photoTranslation];
  transform = CGAffineTransformTranslate(transform, translation.x, translation.y);
  
  // rotate
  transform = CGAffineTransformRotate(transform, self.photoView.angle);
  
  // scale
  CGAffineTransform t = self.photoView.photoContentView.transform;
  CGFloat xScale =  sqrt(t.a * t.a + t.c * t.c);
  CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
  transform = CGAffineTransformScale(transform, xScale, yScale);
  
  CGImageRef imageRef = [self newTransformedImage:transform
                                      sourceImage:self.image.CGImage
                                       sourceSize:self.image.size
                                sourceOrientation:self.image.imageOrientation
                                      outputWidth:self.image.size.width
                                         cropSize:self.photoView.cropView.frame.size
                                    imageViewSize:self.photoView.photoContentView.bounds.size];
  
  UIImage *image = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  
  if (self.autoSaveToLibray) {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
      if (!error) {
      }
    }];
  }
  
  [self.delegate photoTweaksController:self didFinishWithCroppedImage:image];
}

- (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality {
  CGSize srcSize = size;
  CGFloat rotation = 0.0;
  
  switch(orientation) {
    case UIImageOrientationUp: {
      rotation = 0;
    } break;
    case UIImageOrientationDown: {
      rotation = M_PI;
    } break;
    case UIImageOrientationLeft:{
      rotation = M_PI_2;
      srcSize = CGSizeMake(size.height, size.width);
    } break;
    case UIImageOrientationRight: {
      rotation = -M_PI_2;
      srcSize = CGSizeMake(size.height, size.width);
    } break;
    default:
      break;
  }
  
  CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGContextRef context = CGBitmapContextCreate(NULL,
                                               size.width,
                                               size.height,
                                               8,  //CGImageGetBitsPerComponent(source),
                                               0,
                                               rgbColorSpace,//CGImageGetColorSpace(source),
                                               kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big//(CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                               );
  CGColorSpaceRelease(rgbColorSpace);
  
  CGContextSetInterpolationQuality(context, quality);
  CGContextTranslateCTM(context,  size.width/2,  size.height/2);
  CGContextRotateCTM(context,rotation);
  
  CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                         -srcSize.height/2,
                                         srcSize.width,
                                         srcSize.height),
                     source);
  
  CGImageRef resultRef = CGBitmapContextCreateImage(context);
  CGContextRelease(context);
  
  return resultRef;
}

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize {
  CGImageRef source = [self newScaledImage:sourceImage
                           withOrientation:sourceOrientation
                                    toSize:sourceSize
                               withQuality:kCGInterpolationNone];
  
  CGFloat aspect = cropSize.height/cropSize.width;
  CGSize outputSize = CGSizeMake(outputWidth, outputWidth*aspect);
  
  CGContextRef context = CGBitmapContextCreate(NULL,
                                               outputSize.width,
                                               outputSize.height,
                                               CGImageGetBitsPerComponent(source),
                                               0,
                                               CGImageGetColorSpace(source),
                                               CGImageGetBitmapInfo(source));
  CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
  CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));
  
  CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width,
                                                          outputSize.height / cropSize.height);
  uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height / 2.0);
  uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
  CGContextConcatCTM(context, uiCoords);
  
  CGContextConcatCTM(context, transform);
  CGContextScaleCTM(context, 1.0, -1.0);
  
  CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                         -imageViewSize.height/2.0,
                                         imageViewSize.width,
                                         imageViewSize.height)
                     , source);
  
  CGImageRef resultRef = CGBitmapContextCreateImage(context);
  CGContextRelease(context);
  CGImageRelease(source);
  return resultRef;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Change listner on photo tweak view

- (void)photoTweakViewDidUndergoRotationChange:(TDTPhotoTweakView *)photoTweakView {
  [self hideResetBarButton:NO];
  if ([self.delegate respondsToSelector:@selector(photoTweaksControllerDidRotate:)]) {
    [self.delegate photoTweaksControllerDidRotate:self];
  }
}

- (void)photoTweakViewDidUndergoReset:(TDTPhotoTweakView *)photoTweakView {
  [self hideResetBarButton:YES];
  if ([self.delegate respondsToSelector:@selector(photoTweaksControllerDidReset:)]) {
    [self.delegate photoTweaksControllerDidReset:self];
  }
}

- (void)photoTweakViewDidUndergoCropFrameChange:(TDTPhotoTweakView *)photoTweakView {
  [self hideResetBarButton:NO];
}

- (void)photoTweakViewDidUndergoAngleChange:(TDTPhotoTweakView *)photoTweakView currentAngle:(CGFloat)angle {
  [self hideResetBarButton:NO];
  if ([self.delegate respondsToSelector:@selector(photoTweaksControllerDidRotateSlider:toAngle:)]) {
    [self.delegate photoTweaksControllerDidRotateSlider:self toAngle:angle];
  }
}

- (void)photoTweakViewDidUndergoLockingChange:(TDTPhotoTweakView *)photoTweakView withWidthToHeightRatio:(CGFloat)ratio {
  [self hideResetBarButton:NO];
  if ([self.delegate respondsToSelector:@selector(photoTweaksController:didLockCroppingToOption:)]) {
    TDTCropRatioOption *option = [self ratioOptionWithWidthToHeightRatio:ratio inArray:self.cropOptions];
    [self.delegate photoTweaksController:self didLockCroppingToOption:option];
  }
}

@end
