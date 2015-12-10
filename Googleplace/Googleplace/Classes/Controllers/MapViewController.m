//
//  MapViewController.m
//  Googleplace
//

#import "MapViewController.h"
#import "myAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize lid;
@synthesize name;
@synthesize lat;
@synthesize lng;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"Mapview";
     objMap.delegate = self;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.lat floatValue];
    coordinate.longitude = [self.lng floatValue];
    myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate title:self.name];
    [objMap addAnnotation:annotation];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [self.lat floatValue];
    zoomLocation.longitude= [self.lng floatValue];
  
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [objMap setRegion:viewRegion animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -MapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[objMap dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }else {
        annotationView.annotation = annotation;
    }
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

@end
