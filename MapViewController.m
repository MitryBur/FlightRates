//
//  MapViewController.m
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "FlightRatesAppDelegate.h"
#import "AirportClusterManager.h"


#define DEFAULT_SPAN_LATITUDE 5
#define DEFAULT_SPAN_LONGITUDE 5

//Comment this to hide route between departure and destination points on a map
#define SHOW_OVERLAY_ROUTE

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize flightData = _flightData;
@synthesize routeLine = _routeLine;
@synthesize originalZoom = _originalZoom;
@synthesize pins = _pins;
@synthesize lastClusterizedAnnotations = _lastClusterizedAnnotations;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


- (void) showStartPosition
{
    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
    span.latitudeDelta = DEFAULT_SPAN_LATITUDE;
    span.longitudeDelta = DEFAULT_SPAN_LONGITUDE;
    
    CLLocationCoordinate2D location;
    location.latitude =  59.800278;
    location.longitude = 30.2625;
    
    
    region.span=span;
    region.center=location;
    
    //Add annotationd
    [self.mapView addAnnotation:self.flightData.departureAnnotation];
    [self.mapView addAnnotations:self.flightData.destinationAnnotations]; 
    
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    
    location.latitude = -85;
    location.longitude = -175;
    
    AirportAnnotation *tempAnnotation = [[AirportAnnotation alloc] initWithCoordinate:location];
    tempAnnotation.title = @"city";
    
    // tempAnnotation.subtitle = [NSString stringWithFormat:@"%Стоимость перелета %@ %@", [ objectForKey:@"price"], 
    //                          [destinationAnnotationData objectForKey:@"currency"]];
    //Not departure point 
    
    
    [self.mapView addAnnotation:tempAnnotation];
    [tempAnnotation release];
    
    NSLog(@"MapViewController: items = %d", [self.flightData.sourceFlightData count]);
    
    self.pins = [[NSMutableArray alloc] init] ;
    
    for(int i=0;i<1000;i++) {
        CGFloat latDelta = (rand()*1.0/RAND_MAX)*130+10;
        CGFloat lonDelta = (rand()*1.0/RAND_MAX)*130+10;
        
        CGFloat lat = 0;
        CGFloat lng = 0;
        
        
        CLLocationCoordinate2D newCoord = {lat+latDelta, lng+lonDelta};
        AirportAnnotation *pin = [[AirportAnnotation alloc] initWithCoordinate:newCoord];
        pin.title = [NSString stringWithFormat:@"Pin %i",i+1];;
        pin.subtitle = [NSString stringWithFormat:@"Pin %i subtitle",i+1];
        [self.pins addObject:pin];
        [pin release]; 
    }
    //  if (self.mapView == nil)
    {
        NSLog(@"Map nil %i %i",[self.pins count],[[self.mapView overlays] count]);
    }
    [self.mapView addAnnotations:self.pins]; 
    self.lastClusterizedAnnotations = self.pins;
    NSLog(@"Prerelease");
    
    //[pins release];
    NSLog(@"Postrelease_");
    
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"default"];
    
    if(annotationView == nil) 
    {
        annotationView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"default"] autorelease];
    }
    
    //Check whether the point is departure to set different color for it
    if (((AirportAnnotation *) annotation).departure)
    {
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.animatesDrop = YES;
        
    }
    else
    {
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.animatesDrop = NO;
        
    }
    annotationView.canShowCallout = YES;
    annotationView.calloutOffset = CGPointMake(-5 , 5);
    
    
    return annotationView;
}

#ifdef SHOW_OVERLAY_ROUTE
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (self.routeLine != nil)
    {
        [self.mapView removeOverlay:self.routeLine];
    }
    
    CLLocationCoordinate2D  points[2];
    points[0] = self.flightData.departureAnnotation.coordinate;
    points[1] = view.annotation.coordinate;
    self.routeLine = [MKPolygon polygonWithCoordinates:points count:2];
    
    [self.mapView addOverlay:self.routeLine];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    
    MKPolylineView *polyLineView = [[[MKPolylineView alloc] initWithOverlay: overlay] autorelease];
    polyLineView.strokeColor = [UIColor orangeColor];
    polyLineView.lineWidth   = 2.0f;
    polyLineView.opaque = NO;
    polyLineView.alpha = 0.5f;
    
    return polyLineView;
}

#endif


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showStartPosition];
    /*  MapGestureRecognizer *changeMapPositionRecognizer = [[MapGestureRecognizer alloc] init];
     changeMapPositionRecognizer.touchesEndedCallback = ^(NSSet * touches, UIEvent * event) 
     {
     
     [self.mapView removeAnnotations:self.flightData.destinationAnnotations];
     //[NSThread sleepForTimeInterval:1.0];
     [self.mapView addAnnotations:self.flightData.destinationAnnotations];
     
     
     };
     [self.mapView addGestureRecognizer:changeMapPositionRecognizer];
     [changeMapPositionRecognizer release];*/
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGestureRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:pinchGestureRecognizer];
    [pinchGestureRecognizer release];
    
    UITapGestureRecognizer *dubTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDubTap:)];
    dubTapGestureRecognizer.delegate = self;
    dubTapGestureRecognizer.numberOfTapsRequired = 2;
    dubTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:dubTapGestureRecognizer];
    [dubTapGestureRecognizer release];
    
    
}

- (void) handlePinch:(UIGestureRecognizer *)pinchGestureRecognizer
{
    switch (pinchGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.mapView removeAnnotations:self.flightData.destinationAnnotations];
            
            [self.mapView removeAnnotations:self.lastClusterizedAnnotations];
            
            if (self.routeLine != nil) {
                [self.mapView removeOverlay:self.routeLine];
            }
            NSLog(@"Pinch began recognized");
            
            break;
        case UIGestureRecognizerStateEnded:
            [self.mapView addAnnotations:self.flightData.destinationAnnotations];
            
            self.lastClusterizedAnnotations = [AirportClusters clusterizeAnnotations:self.lastClusterizedAnnotations byRegion:self.mapView.region]; 
            [self.mapView addAnnotations:self.lastClusterizedAnnotations]; 
            
            if (self.routeLine != nil) {
                // [self.mapView addOverlay:self.routeLine];
            }
            NSLog(@"Pinch end recognized");
            
            break;            
        default:
            NSLog(@"Pinch not finished");
            break;
    }
}

- (void) handleDubTap:(UIGestureRecognizer *) dubTapGestureRecognizer
{
    NSLog(@"Dub tap done");
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mapView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Loading Map

- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    [(FlightRatesAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];	
}

- (void) mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    [(FlightRatesAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];	
}

-(void) mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    [(FlightRatesAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];	
    NSLog(@"Error description-%@ \n", [error localizedDescription]);
    NSLog(@"Error reason-%@", [error localizedFailureReason]);
}

#pragma mark - Dealloc 

-(void) dealloc{
    [_mapView release];
    [_flightData release];
    [_routeLine release];
    [_pins release];
    [_lastClusterizedAnnotations release];
    [super dealloc];
}


@end
