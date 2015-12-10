
#import "Connection.h"
#import "JSONKit.h"
@implementation Connection

- (Connection *) initWithURL: (NSString *) URL para: (NSMutableDictionary *) para;
{
    mURL = URL;
    mPara = para;
	return self;
}

- (void) dealloc 
{ 
    [super dealloc];
}
 
#pragma mark -
#pragma mark Public Helper Method


- (NSDictionary *) GetJsonResponse
{    
    NSString *queryString = @"";
    
    if(mPara != nil)
    {
        queryString = [queryString stringByAppendingString:@"?"];
        NSArray *keys = [mPara allKeys];
        for (NSString *key in keys) 
        {            
            queryString = [queryString stringByAppendingString: [NSString stringWithFormat:@"%@=%@&", key, [mPara objectForKey: key]]];
        }
        queryString = [queryString substringToIndex:queryString.length - 1];
    }
    
    mURL = [NSString stringWithFormat:@"%@%@", mURL, queryString];

    mURL =[mURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString: mURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    webData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    
    NSString* Response = [[[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding] autorelease];
        
    return [Response objectFromJSONString];
}

@end
