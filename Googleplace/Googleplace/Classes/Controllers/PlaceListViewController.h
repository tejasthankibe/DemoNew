//
//  PlaceListViewController.h
//  Googleplace
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "IconDownloader.h"
#import "Image.h"
#import "UIImageView+WebCache.h"
@class PlaceBean;
@interface PlaceListViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITableView *tblPlace;
    NSTimer *objTimer;
    NSMutableArray *objPlacelist;
    PlaceBean *objPlaceBean;
    CLLocationManager* locationManager;
    int Is_Call;
    double LATITUDE;
    double LONGITUDE;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
-(void) GetPlaceList;
-(void)startIconDownload:(Image *)contentRecord forIndexPath:(NSIndexPath *)indexPath;
-(void) refresh;
@end
