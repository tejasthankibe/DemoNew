#import <UIKit/UIKit.h>

@interface Image : NSObject

@property (nonatomic, strong) NSString *ImageName;
@property (nonatomic, strong) UIImage *ContentImage;

- (id) initWithImageName:(NSString *) imageName ContentImage:(UIImage *) contentImage;

@end
