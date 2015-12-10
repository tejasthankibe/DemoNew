
#import <Foundation/Foundation.h>

@interface Connection : NSObject
{
    NSString *mURL;
    NSMutableDictionary *mPara;
    NSData *webData;    
}

- (Connection *) initWithURL: (NSString *) URL para: (NSMutableDictionary *) para;

- (NSDictionary *) GetJsonResponse;
@end
