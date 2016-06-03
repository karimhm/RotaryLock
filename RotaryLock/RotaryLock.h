//
//  RotaryLock.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CydiaSubstrate/CydiaSubstrate.h>
#import "RTPSView.h"

typedef void (*SetBackAlpha)(id,SEL,CGFloat);

@protocol SBUIPasscodeNumberPadButton;
@class SBUIPasscodeLockNumberPad;
@protocol SBUIPasscodeLockNumberPadDelegate <NSObject>

@optional

- (void)passcodeLockNumberPad:(SBUIPasscodeLockNumberPad *)numberPad keyCancelled:(UIControl<SBUIPasscodeNumberPadButton> *)key;
- (void)passcodeLockNumberPad:(SBUIPasscodeLockNumberPad *)numberPad keyDown:(UIControl<SBUIPasscodeNumberPadButton> *)key;
- (void)passcodeLockNumberPad:(SBUIPasscodeLockNumberPad *)numberPad keyUp:(UIControl<SBUIPasscodeNumberPadButton> *)key;
- (void)passcodeLockNumberPadBackspaceButtonHit:(SBUIPasscodeLockNumberPad *)button;
- (void)passcodeLockNumberPadCancelButtonHit:(SBUIPasscodeLockNumberPad *)button;
- (void)passcodeLockNumberPadEmergencyCallButtonHit:(SBUIPasscodeLockNumberPad *)button;

@end

@interface SBUIPasscodeLockNumberPad : UIView

- (instancetype)initWithDefaultSizeAndLightStyle:(BOOL)lightStyle;
- (instancetype)initWithDefaultSize;

@property (assign, nonatomic) id<SBUIPasscodeLockNumberPadDelegate> delegate;
@property (nonatomic, readonly) NSArray *buttons;

@end