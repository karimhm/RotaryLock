//
//  RTWheelEnterButton.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTWheelEnterButtonDelegate <NSObject>

-(void)didPressedButton;

@end

@interface RTWheelEnterButton : UIButton

-(void)setBackgroundAlpha:(CGFloat)alpha;

@property (nonatomic) CGFloat alpha;
@property (assign, nonatomic) CAShapeLayer *circle;
@property (assign, nonatomic) CAShapeLayer *border;
@property (assign, nonatomic) UIImageView *enterImage;
@property (assign, nonatomic) id<RTWheelEnterButtonDelegate>delegate;

@end
