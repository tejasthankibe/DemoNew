#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString *) stringWithTrim:(NSString *) str;
+(NSString *) convertDateToString:(NSDate *) objDate format:(NSString *) formate;
+(BOOL) isInternet;
+(void) isInternet: (BOOL) IsInternet;
+(BOOL) isHost;
+(void) isHost: (BOOL) IsHost;
+(BOOL) isInternetActive;
+(BOOL) isInternetActive:(BOOL) isShowAlert;
+(BOOL) IS_Iphone5;

@end
