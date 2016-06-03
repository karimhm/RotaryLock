//
//  RTWheelNumber.m
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import "RTWheelNumber.h"

@implementation RTWheelNumber

- (void)drawRect:(CGRect)rect {
	self.layer.backgroundColor=[UIColor clearColor].CGColor;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect rectangle = CGRectMake(24, 0, 2, 8);
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
	CGContextFillRect(context, rectangle);
}

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text number:(NSInteger)number{
	if(self=[super initWithFrame:frame]){
		_number=number;
	
		_label = [[UILabel alloc] initWithFrame:CGRectMake(14, 14, 22, 32)];
		_label.text = text;
		_label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:36];
		_label.textAlignment = NSTextAlignmentCenter;
		_label.textColor = [UIColor whiteColor];
		_label.backgroundColor = [UIColor clearColor];
		_label.layer.shadowRadius = 3.0;
		_label.layer.shadowOpacity = 1;
		_label.layer.masksToBounds = NO;
		_label.layer.shouldRasterize = YES;
	
		[self addSubview:_label];
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	[_delegate setWheelCanMove:true];
	
	/* used to create bounce effect */
	[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(tapAction) userInfo:nil repeats:NO];
	_canTap = true;
	_canMove = true;
	_moved = false;
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(_canMove){
		_canTap = false;
		_moved = true;
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!_moved){
		if(_canMove){
			_canTap = false;
			[self pressNumberWithCompletion:^(BOOL completed){
				[_delegate setWheelCanMove:true];
				[_delegate didPressedButton:_number];
				[self unpressNumber];
			}];
		}else{
			[self unpressNumber];
			[_delegate didPressedButton:_number];
		}
	}
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(_canMove){
		_canTap = false;
		[self pressNumberWithCompletion:^(BOOL completed){
			[_delegate setWheelCanMove:true];
			[self unpressNumber];
		}];
	}else{
		[self unpressNumber];
		[_delegate didPressedButton:_number];
	}
}

-(void)tapAction{
	if(_canTap){
		_canMove = false;
		[_delegate setWheelCanMove:false];
		[self pressNumberWithCompletion:nil];
	}
}

-(void)pressNumberWithCompletion:(void (^)(BOOL finished))completion{
	[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		_label.transform = CGAffineTransformMakeScale(0.7,0.7);
	} completion:completion];
}

-(void)unpressNumber{
	[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		_label.transform = CGAffineTransformMakeScale(1.2,1.2);
	}completion:^(BOOL completed){
		[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			_label.transform = CGAffineTransformMakeScale(1,1);
		} completion:nil];
	}];
}

-(void)pushNumber{
	[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		_label.transform = CGAffineTransformMakeScale(0.5,0.5);
	} completion:^(BOOL completed){
		
		[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			_label.transform = CGAffineTransformMakeScale(1.35,1.35);
		} completion:^(BOOL completed){
			
			[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				_label.transform = CGAffineTransformMakeScale(1,1);
			} completion:nil];
			
		}];
	}];
}

- (void)dealloc{
	[_label removeFromSuperview];
	[_label release];
	[super dealloc];
}

@end
