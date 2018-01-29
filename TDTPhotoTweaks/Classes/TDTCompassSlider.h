//
//  TDTCompassSlider.h
//  Pods
//
//  Created by Dinesh Kumar on 1/2/18.
//
//

#import <UIKit/UIKit.h>

@class TDTCompassSlider;

@protocol TDTCompassSliderDelegate <NSObject>

- (void)compassSliderBeginRotate:(TDTCompassSlider *_Nonnull)slider;
- (void)compassSliderDidRotate:(TDTCompassSlider *_Nonnull)slider delta:(CGFloat)delta;
- (void)compassSliderEndRotate:(TDTCompassSlider *_Nonnull)slider;

@end

@interface TDTCompassSlider : UIView

@property (nonatomic, assign) CGFloat rotationLimit;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, weak) id <TDTCompassSliderDelegate> _Nullable delegate;

@end
