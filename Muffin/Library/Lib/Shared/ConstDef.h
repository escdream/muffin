//
//  ConstDef.h
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#ifndef ConstDef_h
#define ConstDef_h

#define TABLE_HEADER_HEIGHT  50
#define TABLE_ROW_HEIGHT     44.0f

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

typedef enum _MuffineUserLoginState{
    UserInfoStateError  = -1,
    UserInfoStateNone   = 0,
    UserInfoStateNormal = 1,
    UserInfoStateAdmin  = 2,
} MuffineUserLoginState;

#endif /* ConstDef_h */

