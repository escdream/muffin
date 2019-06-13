//
//  iToast.h
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// Added By shpark on 2011/11/03

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum iToastGravity {
	iToastGravityTop =  0,
	iToastGravityBottom = 1,
	iToastGravityCenter = 2
}iToastGravity;

typedef enum iToastDuration {
	iToastDurationLong = 5000,
	iToastDurationShort = 1000,
	iToastDurationNormal = 3000
}iToastDuration;

typedef enum iToastType {
	iToastTypeInfo = 0,
	iToastTypeNotice = 1,
	iToastTypeWarning = 2,
	iToastTypeError = 3,
}iToastType;


@class iToastData;

@interface iToast : NSObject {
    NSMutableArray *arrViews;
}

+ (iToast*)sharedToast;
- (iToastData *) showText:(NSString *)text duration:(iToastDuration)duration gravity:(iToastGravity)gravity;

@end

@interface iToastData : NSObject
{
    UIView *toastView;
    NSString *sToastText;
    iToastDuration toastDuration;
    NSTimer *toastTimer;
}

@property (nonatomic , strong , setter = setToastMes: ) UIView *toastView;
@property (nonatomic , strong , setter = setToastText:) NSString *sToastText;
@property (nonatomic , assign , setter = setDuration: ) iToastDuration toastDuration;
@property (nonatomic , strong , setter = setToastTimer:) NSTimer *toastTimer;

- (id)initWithText:(NSString*)sText duration:(iToastDuration)duration gravity:(iToastGravity)gravity;

@end

