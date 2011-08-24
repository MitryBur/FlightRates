//
//  AirportAnnotation.h
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AirportAnnotation : NSObject <MKAnnotation>


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

//Property denotes whether the point is departure. Used to set different color for departure point pin
@property (nonatomic, assign) BOOL departure; 

@end

