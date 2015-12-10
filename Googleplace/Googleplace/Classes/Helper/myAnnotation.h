


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface myAnnotation : NSObject <MKAnnotation>
@property (strong, nonatomic) NSString *title;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;
@end
