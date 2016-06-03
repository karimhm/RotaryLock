//
//  RTWheelNumber.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTWheelNumberDelegate <NSObject>

-(void)didPressedButton:(NSInteger)number;
-(void)setWheelCanMove:(BOOL)canMove;

@end

@interface RTWheelNumber : UIView

@property (assign, nonatomic) UILabel *label;

@property (nonatomic) BOOL canTap;
@property (nonatomic) BOOL moved;
@property (nonatomic) BOOL canMove;

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text number:(NSInteger)number ;
-(void)pushNumber;

@property (assign, nonatomic) id<RTWheelNumberDelegate>delegate;
@property (nonatomic) NSInteger number;

@end
