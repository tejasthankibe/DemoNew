#import "Image.h"

@implementation Image

@synthesize ImageName;
@synthesize ContentImage;

-(id) initWithImageName:(NSString *)imageName ContentImage:(UIImage *)contentImage {
    if(self == [super init]) {
        self.ImageName = imageName;
        self.ContentImage = contentImage;
    }
                
    return self;
}

@end
