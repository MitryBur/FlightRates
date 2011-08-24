//
//  FlightRatesAppDelegate.m
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlightRatesAppDelegate.h"
#import "MapViewController.h"
#import "FlightData.h"

//Comment this when using on iOS device to avoid unnecessary JSON file deletion.
#define DELETE_JSON_FILE

@implementation FlightRatesAppDelegate

@synthesize window = _window;
@synthesize mapViewController = _mapViewController;
@synthesize flightData = _flightData;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self loadFlightDataFromFile];

    //Assign flightdata model object to mapViewController
    self.mapViewController.flightData =self.flightData;
    
    self.window.rootViewController = self.mapViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_mapViewController release];
    [_flightData release];
    [super dealloc];
}

#pragma MARK - Custom methods

//Moves JSON file with flight data from app bundle to app documents directory  if necessary, and fills in a FlightData object;
- (void) loadFlightDataFromFile
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LEDPoints.json"];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"LEDPoints.json"];
        
    NSLog(@"Source Path: %@\n Documents Path: %@ \n Folder Path: %@", sourcePath, documentsDirectory, folderPath);
    
    NSError *error;
    if([[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:folderPath error:&error])
    {
        NSLog(@"File successfully copied");
    }
    else
    {
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }
    
    NSString *data=@"";
    
    data = [self readFile:@"LEDPoints.json"];
#ifdef DELETE_JSON_FILE
    [self deleteFile:@"LEDPoints.json"];
#endif

    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    
    NSDictionary *flightDataFromFile = [jsonKitDecoder objectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]];
   
    NSLog(@"total items: %d", [flightDataFromFile count]);
    
    FlightData *tempFlightData= [[FlightData alloc] initWithFlightData:flightDataFromFile];
    self.flightData = tempFlightData;
    [tempFlightData release];
}



//Reads file from documents directory

-(NSString *)readFile:(NSString *)fileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error= NULL;
    NSLog(@"appFile Path: %@", appFile);
    
    if ([fileManager fileExistsAtPath:appFile])
    {
        id resultData=[NSString stringWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:&error];
        if (error == NULL)
        {
            NSLog(@"Data successfully read");
            return resultData;
        }        
    }
    NSLog(@"Error description-%@ \n", [error localizedDescription]);
    NSLog(@"Error reason-%@", [error localizedFailureReason]);
    
    return NULL;
}

//Deletes file from the documents directory
-(void)deleteFile:(NSString *)fileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error= NULL;
    NSLog(@"appFile Path: %@", appFile);
    
    if ([fileManager fileExistsAtPath:appFile])
    {
        if ([[NSFileManager defaultManager] removeItemAtPath:appFile error:&error])	
		{
			NSLog(@"File successfully deleted");
		}
        else
        {
            NSLog(@"Error description-%@ \n", [error localizedDescription]);
            NSLog(@"Error reason-%@", [error localizedFailureReason]);
        }
    }
}

#pragma mark - Network Activity Indictor

//Sets whether network activity indicator should be shown 
- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible 
{
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible) 
        NumberOfCallsToSetVisible++;
    else 
        NumberOfCallsToSetVisible--;
	
    // Display the indicator only when counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}
@end
