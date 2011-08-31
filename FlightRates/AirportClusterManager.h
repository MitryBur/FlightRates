//
//  AirportClusterManager.h
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AirportAnnotation.h"
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>


@interface SingleAirportCluster : AirportAnnotation

@property (nonatomic, retain) NSMutableArray *flights;

@end

@interface AirportClusters : NSObject

@property (nonatomic, retain) NSMutableArray *clusters;

@property (nonatomic, assign) NSInteger gridSizeByLatitude;
@property (nonatomic, assign) NSInteger gridSizeByLongitude;

+ (NSArray *)clusterizeAnnotations: (NSArray *)annotations byRegion: (MKCoordinateRegion) region;

@end

//First add to cluster visible annotations