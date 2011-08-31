//
//  MapGestureRecognizer.h
//  FlightRates
//
//  Created by Dmitry Burmistrov on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Code block containing activities to do when touches ended.
typedef void (^TouchesEventBlock) (NSSet * touches, UIEvent * event);

@interface MapGestureRecognizer : UIPinchGestureRecognizer <UIGestureRecognizerDelegate>

@property(nonatomic, copy) TouchesEventBlock touchesEndedCallback;

@end
