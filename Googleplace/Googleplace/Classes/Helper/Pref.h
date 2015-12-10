#import <Foundation/Foundation.h>

@interface Pref : NSObject

+(void) setValueForKey: (NSString *) Key Value: (NSString *) Value;
+(NSString *) getValueForKey: (NSString *) Key DefaultValue: (NSString *) DefaultValue;

@end
