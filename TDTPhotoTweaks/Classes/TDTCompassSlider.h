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

- (void)tdt_compassSliderDidRotate:(TDTCompassSlider *_Nonnull)slider delta:(CGFloat)delta;

@end

@interface TDTCompassSlider : UIView

@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, weak) id <TDTCompassSliderDelegate> _Nullable delegate;

@end
