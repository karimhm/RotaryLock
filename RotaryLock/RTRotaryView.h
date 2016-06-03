//
//  RTRotaryView.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTRotaryWheel.h"
#import "RTWheelEnterButton.h"
#import "RTWeakLink.h"
#import "RTDefines.h"

@protocol RTRotaryViewDelegate <NSObject>

-(void)didHitButton:(NSInteger)number;

@end

@interface RTRotaryView : UIView <RTWheelEnterButtonDelegate,RTRotaryWheelDelegate>

@property (assign, nonatomic) RTRotaryWheel *rotaryWheel;
@property (assign, nonatomic) RTWheelEnterButton *enterButton;

@property (assign, nonatomic) RTWeakLink *weakLink;

@property (nonatomic) NSInteger activeNumber;
@property CGAffineTransform startTransform;
@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) BOOL canMove;
@property (nonatomic) BOOL didMoved;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) CGFloat lastAngle;
@property (nonatomic) CGFloat rotatedAngle;
@property (nonatomic) CGFloat speed;

@property (nonatomic) int direction;

@property (nonatomic) BOOL canUpdate;

@property (nonatomic) CFTimeInterval startTimestamp;
@property (nonatomic) CFTimeInterval lastTimestamp;
@property (assign, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) id<RTRotaryViewDelegate>delegate;

@end
