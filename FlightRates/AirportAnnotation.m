//
//  AirportAnnotation.m
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AirportAnnotation.h"

@implementation AirportAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize departure;

- (id) initWithCoordinate:(CLLocationCoordinate2D) initCoordinate
{
    coordinate = initCoordinate;
    NSLog(@"%f, %f", initCoordinate.latitude, initCoordinate.longitude);
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
