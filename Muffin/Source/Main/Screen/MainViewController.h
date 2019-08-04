//
//  MainViewController.h
//  LGSideMenuControllerDemo
//

#import "LGSideMenuController.h"
#import "KeyboardManager.h"

@interface MainViewController : LGSideMenuController
{
    KeyboardManager * m_keyboardManager;
}

- (void)setupWithType:(NSUInteger)type;

@end
