#import <Foundation/Foundation.h>

@interface PlaceBean : NSObject
{

    NSString *lid;
    NSString *icon;
    NSString *name;
    NSString *address;
    NSString *photoref;
    NSString *lat;
    NSString *lng;
    UIImage *contentImage;
}


@property (nonatomic, strong) NSString *lid;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *photoref;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) UIImage *contentImage;

@end
