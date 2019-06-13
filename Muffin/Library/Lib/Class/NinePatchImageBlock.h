//
//  NinePatchImageBlock.h
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NinePatchImageBlock : NSObject {
    
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGRect currentDrawingRect;
@property (nonatomic, assign) BOOL verticalStretchable;
@property (nonatomic, assign) BOOL horizontalStretchable;


- (id)initWithImage:(UIImage *)blockImage withRect:(CGRect)blockRect withVerticalStretchable:(BOOL)blockVerticalStretchable withHorizontalStretchable:(BOOL)blockHorizontalStretchable;
- (NSString*)description;
@end
