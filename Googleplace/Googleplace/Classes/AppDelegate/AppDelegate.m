//
//  AppDelegate.m
//  Googleplace

#import "AppDelegate.h"
#import "Reachability.h"
#import "PlaceListViewController.h"
@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //start location manager
//   [[GetLocation sharedInstance] start];
    
// Create userdata folder in cache directory
    if([[Pref getValueForKey:@"Userdata" DefaultValue:@"0"]intValue] == 0)
    {
        [self Createfolder];
        [Pref setValueForKey:@"Userdata" Value:@"1"];
    }
    // check for internet connection
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
	[internetReachable startNotifier];
	
	// check if a pathway to a random host exists
	hostReachable = [Reachability reachabilityWithHostName: @"www.google.co.in"];
	[hostReachable startNotifier];
    
    [self checkInterNetConncetion];
    
    
    objPlaceListViewController = [[PlaceListViewController alloc]     initWithNibName:@"iPhone_PlaceList" bundle:nil];
   
    UINavigationController *objnavigation = [[UINavigationController alloc]  initWithRootViewController:objPlaceListViewController];
    self.window.rootViewController = objnavigation;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Googleplace" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Googleplace.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
      
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Notifications

-(void) checkNetworkStatus:(NSNotification *)notice
{
	// called after network status changes
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	{
		case NotReachable:
		{
			NSLog(@"The internet is down.");
            [Utilities isInternet: NO];
			
			break;
			
		}
		case ReachableViaWiFi:
		{
			
            [Utilities isInternet: YES];
			
			break;
			
		}
		case ReachableViaWWAN:
		{
			
            [Utilities isInternet: YES];
			
			break;
			
		}
	}
	
	NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
	switch (hostStatus)
	{
		case NotReachable:
		{
		
            [Utilities isHost: NO];
			
			break;
			
		}
		case ReachableViaWiFi:
		{
			
            [Utilities isHost: YES];
			
			break;
			
		}
		case ReachableViaWWAN:
		{
		
            [Utilities isHost: YES];
			
			break;
			
		}
	}
    
}


#pragma mark - Private Helper Method
-(void) checkInterNetConncetion

{
	// called after network status changes
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	{
		case NotReachable:
		{
			
            [Utilities isInternet: NO];
			
			break;
			
		}
		case ReachableViaWiFi:
		{
			
            [Utilities isInternet: YES];
			
			break;
			
		}
		case ReachableViaWWAN:
		{
            [Utilities isInternet: YES];
			
			break;
			
		}
	}
}

-(void) Createfolder
{
    NSString  *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"UserData"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSLog(@"UserData Path %@",dataPath);
}
@end
