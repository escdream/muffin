//
//  ConfigUtil.h
//  SmartVIGS
//
//

#import <Foundation/Foundation.h>

@interface ConfigUtil : NSObject

+ (void) loadConfigFile;
+ (void) saveConfigFile;
+ (void) setCloudSetting;
+ (BOOL) isCloudSetting;


+ (void) saveConfigData:(NSString*)sFileName sKeyName:(NSString*)sKeyName sValue:(NSString*)sValue;
+ (NSString*) loadConfigData:(NSString*)sFileName sKeyName:(NSString*)sKeyName;
@end
