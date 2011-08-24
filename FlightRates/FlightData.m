//
//  FlightData.m
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlightData.h"

@implementation FlightData
@synthesize sourceFlightData = _sourceFlightData;
@synthesize departureAnnotation = _departureAnnotation;
@synthesize destinationAnnotations= _destionationAnnotations;

- (id)initWithFlightData: (NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.sourceFlightData = data;
       
        CLLocationCoordinate2D location;
        
        //Departure annotation creation
        NSDictionary *departureAnnotationData = [data objectForKey:@"departure"]; 
       
        location.latitude = [[departureAnnotationData objectForKey:@"latitude"] doubleValue];
        location.longitude = [[departureAnnotationData objectForKey:@"longitude"] doubleValue];

        AirportAnnotation *tempDepartureAnnotation = [[AirportAnnotation alloc] initWithCoordinate:location];
        
        tempDepartureAnnotation.title = [NSString stringWithFormat:@"%@, %@", [departureAnnotationData objectForKey:@"city"], 
                                                                                            [departureAnnotationData objectForKey:@"airport"]];
        tempDepartureAnnotation.subtitle = @"Пункт вылета"; 
        tempDepartureAnnotation.departure = YES;
        self.departureAnnotation = tempDepartureAnnotation;
        [tempDepartureAnnotation release];
        
        //Destination annotations creation
        NSArray *destinationAnnotationDataArray = [data objectForKey:@"arrivals"];
        NSMutableArray *tempDepartureAnnotations = [[NSMutableArray alloc] init];
        for (NSDictionary *destinationAnnotationData in destinationAnnotationDataArray)
        {
            CLLocationCoordinate2D location;
            location.latitude = [[destinationAnnotationData objectForKey:@"latitude"] doubleValue];
            location.longitude = [[destinationAnnotationData objectForKey:@"longitude"] doubleValue];
            
            AirportAnnotation *tempAnnotation = [[AirportAnnotation alloc] initWithCoordinate:location];
            tempAnnotation.title = [NSString stringWithFormat:@"%@, %@", [destinationAnnotationData objectForKey:@"city"], 
                                                                                            [destinationAnnotationData objectForKey:@"airport"]];
            tempAnnotation.subtitle = [NSString stringWithFormat:@"%Стоимость перелета %@ %@", [destinationAnnotationData objectForKey:@"price"], 
                                                                                            [destinationAnnotationData objectForKey:@"currency"]];
            //Not departure point
            tempAnnotation.departure = NO;
            
            [tempDepartureAnnotations addObject:tempAnnotation];
            [tempAnnotation release];
        }
        
        self.destinationAnnotations = tempDepartureAnnotations;
        [tempDepartureAnnotations release];
        NSLog(@"Destination annotations count: %d", [self.destinationAnnotations count]);
    }
    return self;
}

- (void)dealloc {
    [_sourceFlightData release];
    [_destionationAnnotations release];
    [_departureAnnotation release];
    
    [super dealloc];
}

@end
