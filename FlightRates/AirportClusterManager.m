//
//  AirportClusterManager.m
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AirportClusterManager.h"


@implementation SingleAirportCluster

@synthesize flights = _flights;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc
{
    [_flights release];
    [super dealloc];
}

@end



@implementation AirportClusters

@synthesize clusters = _clusters;
//@synthesize gridSize = _gridSize;
@synthesize gridSizeByLatitude = _gridSizeByLatitude;
@synthesize gridSizeByLongitude = _gridSizeByLongitude;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSArray *)clusterizeAnnotations: (NSArray *)annotations byRegion: (MKCoordinateRegion) region 
{
    CGFloat gridSizeX;
    CGFloat gridSizeY;
    CGFloat mapSizeX;
    CGFloat mapSizeY;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
    {
        mapSizeX = 360*480/region.span.longitudeDelta;
        mapSizeY = 180*640/region.span.latitudeDelta;

    }
    else
    {
        mapSizeX = 360*480/region.span.longitudeDelta;
        mapSizeY = 180*640/region.span.latitudeDelta;

    }
    gridSizeX = 32*2/mapSizeX*360; 
    gridSizeY = 39*2/mapSizeY*180; 
    NSMutableDictionary *pins = [[NSMutableDictionary alloc] init];
    int i=0;
    for (AirportAnnotation *tempAnnotation in annotations) {
        NSInteger row = (NSInteger) (tempAnnotation.coordinate.latitude/gridSizeY);
        NSInteger col = (NSInteger) (tempAnnotation.coordinate.longitude/gridSizeX);
        NSString *key = [NSString stringWithFormat:@"row:%i-col:%i",row,col];
        NSLog(key);
        CLLocationCoordinate2D location;
        location.latitude= row*gridSizeY+gridSizeY/2;
        location.longitude= col*gridSizeX+gridSizeX/2;

        AirportAnnotation *pin = [[AirportAnnotation alloc] initWithCoordinate:location];
        pin.title = [NSString stringWithFormat:@"Cluster %i",i];
        pin.subtitle = [NSString stringWithFormat:@"Cluser"];
        if([pins objectForKey:key] == nil)
        {
            [pins setObject:pin forKey:key];
        }
        [pin release];         
        i++;
    }
    return [pins allValues];
    //for(AirportAnnotation tempAnnotation in annotations)
}

- (void) dealloc
{
    [_clusters release];
    [super dealloc];
    
}

@end
