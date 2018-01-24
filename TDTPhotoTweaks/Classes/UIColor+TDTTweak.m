//
//  UIColor+TDTTweak.m
//  TDTPhotoTweaks
//  Heavily inspired from https://github.com/itouch2/PhotoTweaks

#import "UIColor+TDTTweak.h"

@implementation UIColor (TDTTweak)

+ (UIColor *)maskColor {
  return [UIColor colorWithWhite:0.0 alpha:0.6];
}

+ (UIColor *)cropLineColor {
  return [UIColor colorWithWhite:1.0 alpha:1.0];
}

+ (UIColor *)gridLineColor {
  return [UIColor colorWithRed:0.52 green:0.48 blue:0.47 alpha:0.8];
}

+ (UIColor *)photoTweakCanvasBackgroundColor {
  return [UIColor colorWithWhite:0.0 alpha:1.0];
}

@end
