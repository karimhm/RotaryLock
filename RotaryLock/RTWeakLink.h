//
//  RTWeakLink.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTWeakLink : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)sel;
- (void)update:(id)sender;

@end
