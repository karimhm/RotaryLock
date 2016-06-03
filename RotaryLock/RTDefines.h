//
//  RTDefines.h
//  RotaryLock
//
//  Created by Karim on 6/3/16.
//  Copyright © 2016 Karim. All rights reserved.
//

#if defined(__LP64__) && __LP64__
#define RTAtan2(__double, __double2) atan2(__double, __double2)
#else
#define RTAtan2(__float, __float2) atan2f(__float, __float2)
#endif