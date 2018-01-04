//
//  TDTCompassSlider.m
//  Pods
//
//  Created by Dinesh Kumar on 1/2/18.
//
//

#import "TDTCompassSlider.h"

@interface TDTCompassSlider() {
  CGPoint touchesStartLocation;
  CGFloat deltaAngle;
  CGAffineTransform startTransform;
  CGFloat temporaryRotation;
}

@property (nonatomic, strong) UIImageView * sliderBGImageView;

@end

@implementation TDTCompassSlider

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

-(void)setRotation:(CGFloat)rotation {
  if (_rotation != rotation) {
    _rotation = rotation;
    _sliderBGImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, _rotation);
  }
}

-(CGSize)intrinsicContentSize {
  return CGSizeMake(150, 50);
}

- (CGRect)frameForSliderImageViewForImage:(UIImage *)image {
  CGFloat originX = (- image.size.width + self.bounds.size.width)/2.0;
  CGFloat originY = (- image.size.height + self.bounds.size.height);
  return CGRectMake(originX,
                    originY,
                    image.size.width,
                    image.size.height);
}

- (void)setup {
  [self setFrame:CGRectMake(0, 0, 210.0, 50.0)];
  [self setBackgroundColor:[UIColor clearColor]];
  [self setClipsToBounds:YES];
  
  _rotation = 0.0;
  
  UIImage *image = [UIImage imageNamed:@"slider"
                              inBundle:[NSBundle bundleForClass:[self class]]
         compatibleWithTraitCollection:nil];
  
  CGRect frame = [self frameForSliderImageViewForImage:image];
  _sliderBGImageView = [[UIImageView alloc] initWithFrame:frame];
  [_sliderBGImageView setImage:image];
  [self addSubview:_sliderBGImageView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([self.delegate respondsToSelector:@selector(tdt_compassSliderBeginRotate:)]) {
    [self.delegate tdt_compassSliderBeginRotate:self];
  }
  CGPoint touchPoint = [[touches anyObject] locationInView:self];
  float dx = touchPoint.x - self.sliderBGImageView.center.x;
  float dy = touchPoint.y - self.sliderBGImageView.center.y;
  deltaAngle = atan2(dy,dx);
  temporaryRotation = self.rotation;
  startTransform = self.sliderBGImageView.transform;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView:self];
  float dx = pt.x  - self.sliderBGImageView.center.x;
  float dy = pt.y  - self.sliderBGImageView.center.y;
  float ang = atan2(dy,dx);
  float angleDifference = ang - deltaAngle;
  self.rotation = (temporaryRotation + angleDifference);
  self.sliderBGImageView.transform = CGAffineTransformRotate(startTransform, angleDifference);
  if ([self.delegate respondsToSelector:@selector(tdt_compassSliderDidRotate:delta:)]) {
    [self.delegate tdt_compassSliderDidRotate:self delta:angleDifference];
  }
  return;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([self.delegate respondsToSelector:@selector(tdt_compassSliderEndRotate:)]) {
    [self.delegate tdt_compassSliderEndRotate:self];
  }
}

@end
