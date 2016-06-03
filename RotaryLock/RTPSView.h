//
//  RTPSView.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTRotaryView.h"

@protocol RTPSViewDelegate <NSObject>

-(void)RTdidHitButton:(NSInteger)number;

@end

@interface RTPSView : UIView <RTRotaryViewDelegate>

-(void)setBackgroundAlpha:(CGFloat)alpha;
-(void)setCustomBackgroundColor:(UIColor *)color;

@property (assign, nonatomic) RTRotaryView *rotaryView;
@property (assign, nonatomic) id<RTPSViewDelegate>delegate;

@end
