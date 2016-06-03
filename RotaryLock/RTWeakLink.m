//
//  RTWeakLink.m
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import "RTWeakLink.h"

@implementation RTWeakLink{
	id Target;
	SEL Selector;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)sel{
	if(self = [super init]){
		Target = target;
		Selector = sel;
	}
	return self;
}

- (void)update:(id)sender{
	[Target performSelector:Selector withObject:sender];
}

@end
