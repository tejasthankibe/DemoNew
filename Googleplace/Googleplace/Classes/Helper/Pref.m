#import "Pref.h"

@implementation Pref

+(void) setValueForKey:(NSString *)Key Value:(NSString *)Value {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",Value] forKey:[NSString stringWithFormat:@"%@",Key]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getValueForKey:(NSString *)Key DefaultValue:(NSString *)DefaultValue {
    NSString *Value = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",Key]];
    
    return Value == nil ? DefaultValue : Value;
}

@end
