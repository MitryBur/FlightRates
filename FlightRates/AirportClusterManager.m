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

+ (void)clusterizeAnnotations: (NSArray *)annotations byRegion: (MKCoordinateRegion) region 
{
    NSInteger gridSizeX;
    NSInteger gridSizeY;

    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
    {
        gridSizeX = 360*480/region.span.longitudeDelta;
        gridSizeY = 180*640/region.span.latitudeDelta;

    }
    else
    {
        gridSizeX = 360*480/region.span.longitudeDelta;
        gridSizeY = 180*640/region.span.latitudeDelta;

    }
    //for(AirportAnnotation tempAnnotation in annotations)
}

- (void) dealloc
{
    [_clusters release];
    [super dealloc];
    
}

@end
