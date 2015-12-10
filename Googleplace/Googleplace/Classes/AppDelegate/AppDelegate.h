//
//  AppDelegate.h
//  Googleplace

#import <UIKit/UIKit.h>
@class Reachability;
@class PlaceListViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *internetReachable;
    Reachability *hostReachable;
    PlaceListViewController *objPlaceListViewController;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void) checkNetworkStatus:(NSNotification *)notice;

-(void) checkInterNetConncetion;
-(void) Createfolder;

@end
