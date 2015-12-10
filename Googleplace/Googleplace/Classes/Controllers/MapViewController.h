//
//  MapViewController.h
//  Googleplace
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<MKMapViewDelegate>
{
    
    NSString *lid;
    NSString *name;
    NSString *lat;
    NSString *lng;
    IBOutlet MKMapView *objMap;
}


@property (nonatomic, strong) NSString *lid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readwrite) NSString *lat;
@property (nonatomic, readwrite) NSString *lng;
@end
