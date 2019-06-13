//
//  EDTagListView.h
//  Muffin
//
//  Created by escdream on 2018. 10. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDRoundView.h"
#import "EDRoundButton.h"

@interface EDTagListView : EDRoundView
{
    NSMutableDictionary * dicTag;
}

@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat buttonMinWidth;
@property (nonatomic, strong) UIFont * buttonFont;


@property (nonatomic, strong) UIColor * normalTextColor;
@property (nonatomic, strong) UIColor * selectTextColor;
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, strong) UIColor * selectColor;



- (void) addTag:(NSString *) sTagString sData:(NSString *)sData;



@end
