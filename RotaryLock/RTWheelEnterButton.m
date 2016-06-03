//
//  RTWheelEnterButton.m
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import "RTWheelEnterButton.h"

@implementation RTWheelEnterButton

-(instancetype)initWithFrame:(CGRect)frame{
	if(self=[super initWithFrame:frame]){
	
		CGFloat radius = 96;
		
		_circle = [CAShapeLayer layer];
		_border = [CAShapeLayer layer];
		
		_circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2,radius,radius) cornerRadius:radius].CGPath;
		_circle.position = CGPointMake(0,0);
		_circle.fillColor = [UIColor colorWithWhite:0.11 alpha:1].CGColor;
		_circle.opacity = 0.73;
		
		_border.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 1,radius+2,radius+2) cornerRadius:radius-1].CGPath;
		_border.position = CGPointMake(0,0);
		_border.fillColor = [UIColor clearColor].CGColor;
		_border.strokeColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
		_border.lineWidth = 2;
		
		[self.layer addSublayer:_border];
		[self.layer addSublayer:_circle];
		
		_enterImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/RotaryLockScreen/WheelEnterButton.png"]];
		[self addSubview:_enterImage];
		
		[self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDragInside];
		[self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDragEnter];
	
		[self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchDragExit];
		[self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpOutside];
		[self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchDragOutside];
		[self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchCancel];
	
		[self addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

-(void)touchDown{
	[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		_circle.opacity=0;
	} completion:nil];
}

-(void)touchUp{
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		_circle.opacity = (float)_alpha;
	} completion:nil];
}

-(void)enterAction{
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		_circle.opacity = (float)_alpha;
	} completion:nil];
	
	[_delegate didPressedButton];
}

-(void)setBackgroundAlpha:(CGFloat)alpha{
	_alpha = alpha;
	_circle.opacity = (float)alpha;
}

-(NSString *)accessibilityHint{
	return @"Enter";
}

- (void)dealloc{
	[_border removeFromSuperlayer];
	[_circle removeFromSuperlayer];
	
	[_enterImage removeFromSuperview];
	[_enterImage release];
	
	[super dealloc];
}

@end
