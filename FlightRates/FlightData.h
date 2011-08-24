//
//  FlightData.h
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AirportAnnotation.h"

@interface FlightData : NSObject

//Parsed data from JSON file
@property (nonatomic, retain) NSDictionary *sourceFlightData;

//'AirportAnnotation' object of departure airport
@property (nonatomic, retain) AirportAnnotation *departureAnnotation;

//Array of 'AirportAnnotation' objects of destination airports
@property (nonatomic, retain) NSArray *destinationAnnotations;

//Initialization
- (id)initWithFlightData: (NSDictionary *)data;

@end
