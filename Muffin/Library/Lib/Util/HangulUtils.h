//
//  HangulUtils.h
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 4. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HangulUtils : NSObject
{
	NSArray *arrayChosung;
	NSArray *arrayJungSung;
	NSArray *arrayJongSung;
    NSMutableString *resultBuffer;
}

// singletone으로 만듦.
+ (HangulUtils *) GetInstance:(BOOL)isrelease;

- (id)			init;
- (void)		initInitialSound;
- (NSString*)	getHangulInitialSound : (NSString *)value ChoList:(BOOL)isChoList;
- (NSString*)	getHangulInitialSound : (NSString *)value keyword:(NSString *)searchKeyword;
- (BOOL)		getIsChoSungList	  : (NSString *)name;
- (void)		dealloc;

/*
 * 문자열로부터 초성 리스트 반환하는 함수.
 */
- (NSString *) makeChosungFromString:(NSString *)text;
- (NSString *) makeOneChosungFromString:(NSString *)text;
- (NSString *) makeOnlyNamesChosungFromString:(NSString *)text;

/*
 * 주어진 캑릭터 코드가 문자열에 있는지 검사.
 * searchchar: 찾고자하는 코드
 * source: 소스 데이터.
 */
- (BOOL) hasCharacter:(NSString *)source searchchar:(unichar)searchchar;

/*
 * 주어진 캐릭터가 초성인지 판단.
 */
- (BOOL) isChosung:(NSUInteger)searchchar;

/*
 * 주어진 문자의 초성 반환.
 */
- (NSUInteger) getChosung:(NSUInteger)source;


- (NSString *)doubleChosungReplace:(NSString *)chosung;
- (NSString *)getChosungs:(NSString *)name;


@end
