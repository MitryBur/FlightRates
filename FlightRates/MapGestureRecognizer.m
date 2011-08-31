//
//  MapGestureRecognizer.m
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapGestureRecognizer.h"

@implementation MapGestureRecognizer
@synthesize touchesEndedCallback = _touchesEndedCallback;

- (id)init
{
    self = [super init];
    if (self) {
        self.cancelsTouchesInView = NO;
        self.delegate = self;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchesEndedCallback)
    {
        self.touchesEndedCallback(touches, event);
        NSLog(@"Touches began, callback done");
    }
    else
    {
        NSLog(@"Touches began, callback skipped");
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchesEndedCallback)
    {
        self.touchesEndedCallback(touches, event);
        NSLog(@"Touches ended, callback done");
    }
    else
    {
        NSLog(@"Touches ended, callback skipped");
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) dealloc
{
    [super dealloc];
}

@end
