//
//  RTRotaryView.m
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import "RTRotaryView.h"

@implementation RTRotaryView

- (instancetype)initWithFrame:(CGRect)frame{
	if(self = [super initWithFrame:frame]){
	self.backgroundColor = [UIColor clearColor];
	
		_canMove = true;
		_activeNumber = 0;
	
		_rotaryWheel=[[RTRotaryWheel alloc] initWithFrame:CGRectMake(self.center.x-145, self.center.y-145, 290, 290)];
		_rotaryWheel.delegate = self;
	
		[self addSubview:_rotaryWheel];
		
		_enterButton=[[RTWheelEnterButton alloc] initWithFrame:CGRectMake(self.center.x-50, self.center.y-50, 100 , 100)];
		_enterButton.delegate = self;
		[self addSubview:_enterButton];
	
		_canUpdate=false;
	
		/*
		RTWeakLink is neded because CADisplayLink retains the target so there will be a Retain Cycle
		*/
		_weakLink = [[RTWeakLink alloc] initWithTarget:self selector:@selector(update:)];
	
		_displayLink = [CADisplayLink displayLinkWithTarget:_weakLink selector:@selector(update:)];
		[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	}
	return self;
}


-(void)didPressedButton{
	[_delegate didHitButton:_activeNumber];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	CGPoint location = [[[event allTouches] anyObject] locationInView:self];
	CGFloat dx = location.x - _rotaryWheel.center.x;
	CGFloat dy = location.y - _rotaryWheel.center.y;
	
	_deltaAngle = RTAtan2(dy,dx);
	_startTransform = _rotaryWheel.transform;
	_didMoved = false;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(_canMove){
		
		CGPoint location = [[[event allTouches] anyObject] locationInView:self];
		
		CGFloat dx = location.x  - _rotaryWheel.center.x;
		CGFloat dy = location.y  - _rotaryWheel.center.y;
		CGFloat ang = RTAtan2(dy,dx);
		CGFloat angleDifference = _deltaAngle - ang;
		_rotaryWheel.transform = CGAffineTransformRotate(_startTransform, -angleDifference);
		
		CGFloat angle,radians = RTAtan2(_rotaryWheel.transform.b, _rotaryWheel.transform.a);
		
		if(radians*180/M_PI<0){
			angle = (radians*180/M_PI)+360;
		}else{
			angle = radians*180/M_PI;
		}
		
		angle-=180/_rotaryWheel.numbers-18;
		
		if(_lastAngle>340&&angle<20){
			_rotatedAngle = angle-_lastAngle;
			_direction=1;
		}else if(_lastAngle<20&&angle>340){
			_rotatedAngle = _lastAngle-angle;
			_direction = 0;
		}else if(angle>_lastAngle){
			_rotatedAngle = angle-_lastAngle;
			_direction = 1;
		}else if(_lastAngle>angle){
			_rotatedAngle = _lastAngle-angle;
			_direction = 0;
		}
		
		_lastAngle = angle;
		_timestamp = event.timestamp;
		_didMoved = true;
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	_speed = ((1/(event.timestamp-_timestamp))*_rotatedAngle)/4;
	
	if(_didMoved){
		
		_startTimestamp = 0;
		_lastTimestamp = 0;
		_startTransform = _rotaryWheel.transform;
		
		if(_speed>20){
			_canUpdate = true;
		}else{
			CGFloat angle,radians = RTAtan2(_rotaryWheel.transform.b, _rotaryWheel.transform.a);
			
			if(radians*180/M_PI<0){
				angle=(radians*180/M_PI)+360;
			}else{
				angle=radians*180/M_PI;
			}
			angle-=180/_rotaryWheel.numbers;
			
			_activeNumber = 10-(angle/(360/_rotaryWheel.numbers));
			if(_activeNumber==10){
				_activeNumber = 0;
			}
			
			/* used to anounce what key is active if accessibility is on "for blind people"*/
			UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,[NSString stringWithFormat:@"%li, Entered",(long)_activeNumber]);
			
			[_rotaryWheel pressNumber:_activeNumber];
			[self didPressedButton];
		}
	}
	
	_didMoved=false;
}

-(void)setWheelCanMove:(BOOL)canMove{
	_canMove=canMove;
}

-(void)didPressedButton:(NSInteger)number{
	
	[_delegate didHitButton:number];
}

/* ANIMATE */

- (void)update:(CADisplayLink *)sender{
	
	if(self.canUpdate){
		
		CFTimeInterval time = self.displayLink.timestamp-self.startTimestamp;
		if (!self.startTimestamp) {
			time=0;
			self.startTimestamp=self.displayLink.timestamp;
		}
		
		CGFloat speed = self.speed-(self.speed*1.7)*(self.displayLink.timestamp-self.startTimestamp);
		self.speed = speed;
		
		if(speed<1){
			self.canUpdate=false;
			
			CGFloat angle,radians = RTAtan2(self.rotaryWheel.transform.b, self.rotaryWheel.transform.a);
			
			if(radians*180/M_PI<0){
				angle = (radians*180/M_PI)+360;
			}else{
				angle = radians*180/M_PI;
			}
			angle-=180/self.rotaryWheel.numbers;
			
			self.activeNumber = 10-(angle/(360/self.rotaryWheel.numbers));
			if(self.activeNumber==10){
				self.activeNumber = 0;
			}

			[self.rotaryWheel pressNumber:self.activeNumber];
		}
		
		if(self.direction){
			self.rotaryWheel.transform = CGAffineTransformRotate(self.rotaryWheel.transform,((speed*time)*M_PI/180));
		}else{
			self.rotaryWheel.transform = CGAffineTransformRotate(self.rotaryWheel.transform,-((speed*time)*M_PI/180));
		}
		self.lastTimestamp = self.displayLink.timestamp;
	}
}

- (void)dealloc{
	
	[_rotaryWheel removeFromSuperview];
	[_enterButton removeFromSuperview];
	
	_rotaryWheel.delegate = nil;
	_enterButton.delegate = nil;
	
	[_rotaryWheel release];
	[_enterButton release];
	
	[_displayLink invalidate];
	[_weakLink release];
	
	[super dealloc];
}

@end
