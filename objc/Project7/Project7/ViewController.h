//
//  ViewController.h
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "City.h"

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSDictionary<NSString *, id> *pages;
@property BOOL firstRun;
- (void)focusOn:(City *)city;
@end

