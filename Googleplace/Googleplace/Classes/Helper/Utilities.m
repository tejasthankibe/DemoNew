#import "Utilities.h"
#import "Pref.h"
#import <Twitter/Twitter.h>
static BOOL _isInternet = NO;
static BOOL _isHost = NO;
@implementation Utilities

+(NSString *) stringWithTrim:(NSString *)str {
    if(str == NULL)
        return @"";
    //    str=[str stringByReplacingOccurrencesOfString:@"." withString:@""];
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+(BOOL) isInternet
{
    return _isInternet;
}

+(void) isInternet: (BOOL) IsInternet
{
    _isInternet = IsInternet;
}

+(BOOL) isHost
{
    return _isHost;
}

+(void) isHost: (BOOL) IsHost
{
    _isHost = IsHost;
}

+(BOOL) isInternetActive
{
    return [self isInternetActive:YES];
}

+(BOOL) isInternetActive:(BOOL) isShowAlert
{
    Boolean Result = YES;
    UIAlertView *viewMessage = [[UIAlertView alloc] initWithTitle:nil message: @"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if(!_isInternet)
    {
        [viewMessage setTitle: @"Alert!"];
        [viewMessage setMessage:@"Internet not working"];
        Result = NO;
    }
    /*
     else if(!_isHost)
     {
     [viewMessage setTitle: @"Host Not Working"];
     [viewMessage setMessage:@"Please Check Your Host"];
     Result = NO;
     }
     */
    if(!Result && isShowAlert)
        [viewMessage show];
    
    
    return Result;
}



+(NSString *) convertDateToString:(NSDate *) objDate format:(NSString *) formate {   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:uslocale];
    
    [dateFormatter setDateFormat: formate];
    return [dateFormatter stringFromDate:objDate];
}

+(NSDate *) convertStringToDate:(NSString *) strDate format:(NSString *) formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:uslocale];
    
    [dateFormatter setDateFormat: formate];
    
    return [dateFormatter dateFromString:strDate];
}

+(NSString *) convertDateStringToString: (NSString *) strDate currentFormat:(NSString *) currentFormat parseFormat:(NSString *) parseFormat {
    return [self convertDateToString:[self convertStringToDate: strDate format: currentFormat] format: parseFormat];
}

+(NSString *) convertDateToMillisecond:(NSDate *) objDate {
    NSString *str = [NSString stringWithFormat: @"%lf", [objDate timeIntervalSince1970] * 1000];
    str = [str substringToIndex: [str rangeOfString:@"."].location];
    return str;
}

+(UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(NSString *) GetUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *) string;
}

+(BOOL) IsEmail: (NSString *) emailID  {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];    
    return [emailTest evaluateWithObject:emailID];
}



+ (NSDate*) SystemTimeToUTCTime:(NSDate*)sourceDate
{
    NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone* utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval gmtInterval = gmtOffset - currentGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:sourceDate]; 
    
    NSString *GMT =  [Utilities convertDateToString:destinationDate format:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@" GMT %@",GMT);
    
    //    [self UTCTimeToSystemTime:destinationDate];
    return destinationDate;
}

+(BOOL) IS_Iphone5
{
    return [UIScreen mainScreen].bounds.size.height == 568.0; //[[self platform] isEqualToString:@"iPhone5,1"];
}
@end
