//
//  MapViewController.h
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AirportAnnotation.h"
#import "FlightData.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) FlightData *flightData;

//Line between departure and destination point
@property (nonatomic, retain) MKPolygon* routeLine;

@property (nonatomic, assign) MKZoomScale originalZoom;

@property (nonatomic, retain) NSMutableArray *pins;

@property (nonatomic, retain) NSArray *lastClusterizedAnnotations;


// Initializes map and shows start position on it
- (void) showStartPosition;

@end
