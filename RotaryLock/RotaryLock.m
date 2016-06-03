//
//  RotaryLock.m
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import "RotaryLock.h"

static IMP original_initWithDefaultSizeAndLightStyle;
static IMP original_initWithDefaultSize;
static IMP original_setCustomBackgroundColor;
static IMP original_dealloc;
static IMP original_setBackgroundAlpha;
static IMP original_touchesShouldCancelInContentView;


void RTinitWithDefault(id self, SEL _cmd){
	
	CGRect frame = [(UIView *) self frame];
	
	RTPSView *pv = [[RTPSView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
	pv.delegate = self;
	
	objc_setAssociatedObject(self,"RTPSView", pv, OBJC_ASSOCIATION_ASSIGN);
	
	for(NSUInteger i = 1;i<[[(SBUIPasscodeLockNumberPad *)self subviews] count]-3;i++){
		[(UIView *)[[(SBUIPasscodeLockNumberPad *)self subviews] objectAtIndex:i] setHidden:true];
	}
	
	[(UIView *)[[(SBUIPasscodeLockNumberPad *)self subviews] objectAtIndex:0] setFrame:frame];
	[(UIView *)[[(UIView *)self subviews] objectAtIndex:0] layer].hidden=false;
		
	CGFloat radius = 290;
		
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, frame.size.height) cornerRadius:0];
	UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(frame.size.width/2-radius/2, frame.size.width/2-radius/2,radius,radius) cornerRadius:radius];
	[path appendPath:circlePath];
	[path setUsesEvenOddFillRule:YES];
		
	CAShapeLayer *fillLayer = [CAShapeLayer layer];
	fillLayer.path = path.CGPath;
	fillLayer.fillRule = kCAFillRuleEvenOdd;
	fillLayer.fillColor = [UIColor blackColor].CGColor;
	[[(UIView *)[[(UIView *)self subviews] objectAtIndex:0] layer] setMask:fillLayer];
	
	[self addSubview:pv];
}

id RT_initWithDefaultSizeAndLightStyle(id self, SEL _cmd, BOOL lightStyle){
	self = original_initWithDefaultSizeAndLightStyle(self,_cmd,lightStyle);
	RTinitWithDefault(self, _cmd);
	return self;
}

id RT_initWithDefaultSize(id self, SEL _cmd){
	self = original_initWithDefaultSize(self,_cmd);
	RTinitWithDefault(self, _cmd);
	return self;
}

void RT_setCustomBackgroundColor(id self, SEL _cmd, UIColor *color){
	original_setCustomBackgroundColor(self,_cmd,color);
	[(RTPSView *)objc_getAssociatedObject(self,"RTPSView") setCustomBackgroundColor:color];
}

void RT_setBackgroundAlpha(id self, SEL _cmd, CGFloat alpha){
	SetBackAlpha setAlpha = (SetBackAlpha)original_setBackgroundAlpha;
	setAlpha(self, _cmd, alpha);
	[(RTPSView *)objc_getAssociatedObject(self,"RTPSView") setBackgroundAlpha:alpha];
}

void RT_dealloc(id self, SEL _cmd){
	RTPSView *KRView = objc_getAssociatedObject(self,"RTPSView");
	
	[KRView removeFromSuperview];
	KRView.delegate = nil;
	[KRView release];
	
	original_dealloc(self,_cmd);
}

void RTdidHitButton(id self, SEL _cmd, NSInteger number){
	
	/*only after a key down and key up the event will be sent*/
	[[(SBUIPasscodeLockNumberPad *)self delegate] passcodeLockNumberPad:self
																keyDown:[[(SBUIPasscodeLockNumberPad *)self buttons] objectAtIndex:number]];
	
	[[(SBUIPasscodeLockNumberPad *)self delegate] passcodeLockNumberPad:self
																  keyUp:[[(SBUIPasscodeLockNumberPad *)self buttons] objectAtIndex:number]];
}


BOOL RT_touchesShouldCancelInContentView(id self, SEL _cmd, id view){
	/*
	 se wether to cancel the scrolling or not.
	 if the user is rotating the wheel the scrollview should stop scrolling or it will feel wierd
	 */
	
	if([view class]==[RTRotaryWheel class]||[view class]==[RTWheelNumber class]||[view class]==[RTWheelEnterButton class]){
		return false;
	}
	
	return (BOOL)original_touchesShouldCancelInContentView(self,_cmd,view);
}

#if TARGET_OS_IPHONE

MSInitialize {
	
	Class SBUIPasscodeLockNumberPad = objc_getClass("SBUIPasscodeLockNumberPad");
	
	/*
	 initWithDefaultSize available on iOS 7
	 initWithDefaultSizeAndLightStyle: available on iOS 8 and later
	 */
	if(class_respondsToSelector(SBUIPasscodeLockNumberPad,@selector(initWithDefaultSizeAndLightStyle:))){
		MSHookMessageEx(SBUIPasscodeLockNumberPad,
						@selector(initWithDefaultSizeAndLightStyle:),
						(IMP) &RT_initWithDefaultSizeAndLightStyle,
						&original_initWithDefaultSizeAndLightStyle);
	}else{
		MSHookMessageEx(SBUIPasscodeLockNumberPad,
						@selector(initWithDefaultSize),
						(IMP) &RT_initWithDefaultSize,
						&original_initWithDefaultSize);
	}
	
	/*
	 New version of Cydia Substrate have a bug that will make class_addProtocol crash so
	 the RTPSViewDelegate protocol wont be added to SBUIPasscodeLockNumberPad
	 this will result to conformsToProtocol: return false event if it is supported.
	 and this fine because we wont check if the object conform to the protocol or not
	 */
	
	//class_addProtocol(SBUIPasscodeLockNumberPad,objc_getProtocol("RTPSViewDelegate"));
	
	const char *types[]={"v","@",":",@encode(NSInteger)};
	class_addMethod(SBUIPasscodeLockNumberPad, @selector(RTdidHitButton:), (IMP)RTdidHitButton, *types);
	
	/*
	 setCustomBackgroundColor: is called in some cases like the timer snooze button appear
	 */
	MSHookMessageEx(SBUIPasscodeLockNumberPad,
					@selector(setCustomBackgroundColor:),
					(IMP) &RT_setCustomBackgroundColor,
					&original_setCustomBackgroundColor);
	
	/* 
	 setBackgroundAlpha: is called while scrolling
	 */
	MSHookMessageEx(SBUIPasscodeLockNumberPad,
					@selector(setBackgroundAlpha:),
					(IMP) &RT_setBackgroundAlpha,
					&original_setBackgroundAlpha);
	
	MSHookMessageEx(SBUIPasscodeLockNumberPad,
					@selector(dealloc),
					(IMP) &RT_dealloc,
					&original_dealloc);
	
	
	Class SBLockScreenScrollView = objc_getClass("SBLockScreenScrollView");
	
	MSHookMessageEx(SBLockScreenScrollView,
					@selector(touchesShouldCancelInContentView:),
					(IMP) &RT_touchesShouldCancelInContentView,
					&original_touchesShouldCancelInContentView);
	
}

#endif