//
//  PlaceListViewController.m
//  Googleplace
//


#import "PlaceListViewController.h"
#import "PlaceBean.h"
#import "Placecell.h"
#import "MapViewController.h"
#import "Googleplace.h"
#import "AppDelegate.h"
@interface PlaceListViewController ()

@end

@implementation PlaceListViewController

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
    self.title = @"Place List";
    if(locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
   
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = button;

    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void) viewDidAppear:(BOOL)animated
{
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Helper Method
-(void) refresh
{
    [self GetPlaceList];
//    [MBProgressHUD ProgressPopup].delegate = self;
//    [MBProgressHUD ProgressPopup].labelText = @"Loading...";
//    [[MBProgressHUD ProgressPopup] showWhileExecuting:@selector(GetPlaceList) onTarget:self withObject:nil animated:YES];
//    [super viewDidAppear:YES];
}
-(void) GetPlaceList
{
        if(![Utilities isInternetActive])
        return;
//        NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
//        [para setObject:KEY forKey:@"key"];
//        [para setObject:@"false" forKey:@"sensor"];
//        [para setObject:TYPES forKey:@"types"];
//        [para setObject:RADIUS forKey:@"radius"];
//        [para setObject:[NSString stringWithFormat:@"%f,%f",LATITUDE,LONGITUDE] forKey:@"location"];
//        
//        Connection *objConnection = [[Connection alloc] initWithURL:JSONURL para:para];
    
//        NSDictionary * objdic = [[NSDictionary alloc] init];
//        objdic = [objConnection GetJsonResponse];
        [objPlacelist removeAllObjects];
        objPlacelist = [[NSMutableArray alloc] init];
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%f%@%f", JSONURL,@"?key=",KEY,@"&sensor=false&types=",TYPES,@"&radius=",RADIUS,@"&location=",LATITUDE,@",",LONGITUDE];
    string =[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"string ==== %@",string);
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        NSLog(@"json response ==== %@",(NSDictionary *)responseObject);
        NSDictionary *objdic =(NSDictionary *)responseObject;
        
        if ([[Utilities stringWithTrim:[objdic objectForKey:@"status"]]isEqualToString:@"OK"])
        {
            
            objdic = [objdic objectForKey:@"results"];
            for(NSDictionary *dic in objdic)
            {
                objPlaceBean = [[PlaceBean alloc] init];
                NSDictionary *geodic = [dic objectForKey:@"geometry"];
                NSDictionary *locationdic = [geodic objectForKey:@"location"];
                objPlaceBean.lat = [locationdic objectForKey:@"lat"];
                objPlaceBean.lng = [locationdic objectForKey:@"lng"];
                NSDictionary *photodic = [dic objectForKey:@"photos"];
                int i =0;
                for(NSDictionary *dic1 in photodic)
                {
                    if(i>0)
                        break;
                    objPlaceBean.photoref = [dic1 objectForKey:@"photo_reference"];
                    i++;
                }
                objPlaceBean.lid =[dic objectForKey:@"id"];
                objPlaceBean.name =[dic objectForKey:@"name"];
                objPlaceBean.address =[dic objectForKey:@"vicinity"];
                [objPlacelist addObject:objPlaceBean];
                
                /*Save above data in core data model*/
                
                /*TODO Write logic here to prevent dublicate entry*/
                Googleplace * objGoogleplace = [NSEntityDescription insertNewObjectForEntityForName:@"Googleplace"inManagedObjectContext:self.managedObjectContext];
                
                objGoogleplace.lid = objPlaceBean.lid;
                objGoogleplace.name = objPlaceBean.name;
                objGoogleplace.address = objPlaceBean.address;
                objGoogleplace.photoref = objPlaceBean.photoref;
                objGoogleplace.lat = objPlaceBean.lng;
                objGoogleplace.lng = objPlaceBean.lng;
                
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Error ===========  %@", [error localizedDescription]);
                }
                objPlaceBean = nil;
                objGoogleplace = nil;
            }
        }
        [tblPlace reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
    

    /*========== fetching============================*/
/* Temp Code
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Googleplace"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];

    NSError *error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    NSLog(@"Rcd =============== %d",fetchedRecords.count);
    NSLog(@"People Rcd +++++++ +++++++ %d",objPlacelist.count);
 */
    
}


#pragma mark - Tableview Delegate & Datasource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [objPlacelist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"";
    
    CellIdentifier = @"iPhone_Placecell";
    Placecell *cell = (Placecell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (Placecell *) currentObject;
                break;
            }
        }
    }
    
    objPlaceBean = [objPlacelist objectAtIndex:indexPath.row];
    cell.lblname.text = objPlaceBean.name;
    cell.lbladdress.text = objPlaceBean.address;
    
    [cell.imgicon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",PHOTOURL,@"maxwidth=100&photoreference=",objPlaceBean.photoref,@"&sensor=false&key=",KEY]]
                   placeholderImage:[UIImage imageNamed:@"no_image.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
//    if(objPlaceBean.photoref == nil || objPlaceBean.photoref == NULL)
//    {
//        cell.imgicon.image  = [UIImage imageNamed:@"no_image.png"];
//    }
//    else
//    {
//        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserData"];
//        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",objPlaceBean.lid,@".png"]];
//        
//        objPlaceBean.contentImage = [UIImage imageWithContentsOfFile:path];
//        
//        if(!objPlaceBean.contentImage)
//        {
//            path = objPlaceBean.photoref;
//            
//            if(tblPlace.dragging == NO && tblPlace.decelerating == NO) {
//                Image *imgThumb = [[Image alloc] initWithImageName:path ContentImage:objPlaceBean.contentImage];
//                [self startIconDownload:imgThumb forIndexPath:indexPath];
//            }
//        }
//        else
//        {
//            cell.imgicon.image = objPlaceBean.contentImage;
//        }
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *objMapViewController = [[MapViewController alloc] initWithNibName:@"iPhone_MapView" bundle:nil];
    objPlaceBean = [objPlacelist objectAtIndex:indexPath.row];
    objMapViewController.lid = objPlaceBean.lid;
    objMapViewController.lat = objPlaceBean.lat;
    objMapViewController.lng = objPlaceBean.lng;
    objMapViewController.name = objPlaceBean.name;
    [self.navigationController pushViewController:objMapViewController animated:YES];
}



#pragma mark -
#pragma mark LocationManager Delegate Event
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    
    LATITUDE = [lastLocation coordinate].latitude;
    LONGITUDE = [lastLocation coordinate].longitude;
    
    if(Is_Call == 0)
    {
        [self GetPlaceList];
        
//        [MBProgressHUD ProgressPopup].delegate = self;
//        [MBProgressHUD ProgressPopup].labelText = @"Loading...";
//        [[MBProgressHUD ProgressPopup] showWhileExecuting:@selector(GetPlaceList) onTarget:self withObject:nil animated:YES];
//        [super viewDidAppear:YES];
        Is_Call = 1;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    LATITUDE = newLocation.coordinate.latitude;
    LONGITUDE = newLocation.coordinate.longitude;
    
    if(Is_Call == 0)
    {
        [self GetPlaceList];
//        [MBProgressHUD ProgressPopup].delegate = self;
//        [MBProgressHUD ProgressPopup].labelText = @"Loading...";
//        [[MBProgressHUD ProgressPopup] showWhileExecuting:@selector(GetPlaceList) onTarget:self withObject:nil animated:YES];
      
        Is_Call = 1;
    }
}

@end
