//
//  RTRotaryWheel.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTWheelNumber.h"
#import "RTWheelEnterButton.h"

@protocol RTRotaryWheelDelegate <NSObject>

-(void)setWheelCanMove:(BOOL)canMove;
-(void)didPressedButton:(NSInteger)number;

@end

@interface RTRotaryWheel : UIView <RTWheelNumberDelegate>

@property (assign, nonatomic) NSArray *wheelNumbersArray;
@property (nonatomic) NSUInteger numbers;
@property (assign, nonatomic) CAShapeLayer *circle;
@property (assign, nonatomic) id<RTRotaryWheelDelegate>delegate;

-(void)pressNumber:(NSUInteger)number;

@end
