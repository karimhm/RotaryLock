//
//  RTPSView.m
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import "RTPSView.h"

@implementation RTPSView

-(instancetype)initWithFrame:(CGRect)frame{
	if(self = [super initWithFrame:frame]){
		self.backgroundColor = [UIColor clearColor];

		_rotaryView = [[RTRotaryView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		_rotaryView.delegate=self;
		
		[self addSubview:_rotaryView];
	}
	return self;
}

-(void)didHitButton:(NSInteger)number{
	
	/*
	 0 need to be 10 because in the 0 button is at the bottom and 1 is the first button
	 the shift is necessary
	 */
	if(number==0){
		number=10;
	}else{
		number-=1;
	}
	
	[self.delegate RTdidHitButton:number];
}

-(void)setBackgroundAlpha:(CGFloat)alpha{
	[_rotaryView.enterButton setBackgroundAlpha:alpha];
}

-(void)setCustomBackgroundColor:(UIColor *)color{
	_rotaryView.enterButton.circle.fillColor = color.CGColor;
}

-(void)dealloc{
	
	[_rotaryView removeFromSuperview];
	_rotaryView.delegate = nil;
	[_rotaryView release];
	
	[super dealloc];
}

@end