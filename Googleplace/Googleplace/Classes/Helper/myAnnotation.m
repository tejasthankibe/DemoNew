

#import "myAnnotation.h"

@implementation myAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
  if ((self = [super init])) {
    self.coordinate =coordinate;
    self.title = title;
  }
  return self;
}

@end
