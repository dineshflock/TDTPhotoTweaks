//
//  TDTCropRatioOption.h
//  Pods
//
//  Created by Dinesh Kumar on 2/12/18.
//

#import <Foundation/Foundation.h>

@interface TDTCropRatioOption : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) CGFloat widthToHeightRatio;

- (instancetype)initWithName:(NSString *)name
            widthHeightRatio:(CGFloat)widthToHeightRatio;

@end
