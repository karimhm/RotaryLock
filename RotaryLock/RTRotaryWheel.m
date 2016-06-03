//
//  RTRotaryWheel.m
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import "RTRotaryWheel.h"

@implementation RTRotaryWheel

-(instancetype)initWithFrame:(CGRect)frame{
	if(self=[super initWithFrame:frame]){
		self.backgroundColor=[UIColor clearColor];
		
		CGFloat radius = 144;
		_circle = [CAShapeLayer layer];
		// Make a circular shape
		_circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
												  cornerRadius:radius].CGPath;
		// Center the shape in _view
		_circle.position = CGPointMake(1,1);
		
		// Configure the apperence of the circle
		_circle.fillColor = [UIColor clearColor].CGColor;
		_circle.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
		_circle.lineWidth = 2;
		
		// Add to parent layer
		[self.layer addSublayer:_circle];
		
		_wheelNumbersArray = [NSArray arrayWithObjects:[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc],[RTWheelNumber alloc], nil];
		[_wheelNumbersArray retain];
		
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		
		_numbers=[_wheelNumbersArray count];
		
		for(NSInteger i=0;i<[_wheelNumbersArray count];i++){
			
			RTWheelNumber *number = [_wheelNumbersArray objectAtIndex:i];
			
			[number initWithFrame:CGRectMake(
											 cos(((360/[_wheelNumbersArray count]*i+270)*M_PI/180))*119+120,
											 sin(((360/[_wheelNumbersArray count]*i+270)*M_PI/180))*119+120,
											 50, 50)
							 text:[numberFormatter stringFromNumber:@(i)] number:i];
			
			number.transform=CGAffineTransformRotate(number.transform,(360/[_wheelNumbersArray count]*i)* M_PI / 180);
			number.delegate=self;
			
			[self addSubview:[_wheelNumbersArray objectAtIndex:i]];
		}
		[numberFormatter release];
	}
	return self;
}

-(void)setWheelCanMove:(BOOL)canMove{
	[_delegate setWheelCanMove:canMove];
}

-(void)didPressedButton:(NSInteger)number{
	[_delegate didPressedButton:number];
}

-(void)pressNumber:(NSUInteger)number{
	[[self.wheelNumbersArray objectAtIndex:number] pushNumber];
}

- (void)dealloc{
	for(NSInteger i=0;i<[_wheelNumbersArray count];i++){
		RTWheelNumber *number = [_wheelNumbersArray objectAtIndex:i];
		
		[number removeFromSuperview];
		number.delegate = nil;
		[number release];
	}
	
	[_wheelNumbersArray release];
	[_circle removeFromSuperlayer];
	[_circle release];
	
	[super dealloc];
}

@end
