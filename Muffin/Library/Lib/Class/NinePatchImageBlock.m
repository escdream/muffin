//
//  NinePatchImageBlock.m
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NinePatchImageBlock.h"


@implementation NinePatchImageBlock

@synthesize image;
@synthesize rect;
@synthesize currentDrawingRect;
@synthesize verticalStretchable;
@synthesize horizontalStretchable;


- (id)initWithImage:(UIImage *)blockImage withRect:(CGRect)blockRect withVerticalStretchable:(BOOL)blockVerticalStretchable withHorizontalStretchable:(BOOL)blockHorizontalStretchable
{
    if ((self = [super init]) != nil) {
        image = blockImage;
        rect = blockRect;
        verticalStretchable = blockVerticalStretchable;
        horizontalStretchable = blockHorizontalStretchable;
    }
    return self;
}

- (NSString*)description
{
    
    return [NSString stringWithFormat:@"image size width [%f] height [%f] , rect [%@] , verticalStrectchable [%d] , horizontalStretchable [%d]" , image.size.width , image.size.height , NSStringFromCGRect(rect) , verticalStretchable , horizontalStretchable];
}

- (void)dealloc
{

}

@end
