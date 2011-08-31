//
//  AirportCluster.h
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AirportAnnotation.h"

@interface SingleAirportCluster : AirportAnnotation

@property (nonatomic, retain) NSMutableArray *airports;

@end

@interface AirportClusters : NSObject

@property (nonatomic, retain) NSMutableArray *clusters;

@property (nonatomic, assign) NSInteger gridSize;


@end

//First add to cluster visible annotations