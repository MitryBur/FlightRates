//
//  FlightRatesAppDelegate.h
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"

@class MapViewController;
@class FlightData;

@interface FlightRatesAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MapViewController *mapViewController;
@property (nonatomic, retain) IBOutlet FlightData *flightData;


//Moves JSON file with flight data from app bundle to app documents directory  if necessary, and fills in a FlightData object;
- (void) loadFlightDataFromFile;

//Reads file from the documents directory
-(NSString *)readFile:(NSString *)fileName;
//Deletes file from the documents directory
-(void)deleteFile:(NSString *)fileName;

//Sets whether network activity indicator should be shown 
- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible; 

@end
