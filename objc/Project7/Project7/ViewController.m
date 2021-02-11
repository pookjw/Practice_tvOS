//
//  ViewController.m
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)setup {
    self.pages = @{};
    self.firstRun = YES;
}

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(51.38, -2.36);
    [self updateMap];
}

- (void)focusOn:(City *)city {
    self.mapView.centerCoordinate = city.coordinates;
}

- (void)updateMap {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://en.wikipedia.org/w/api.php?ggscoord=%f%%7C%f&action=query&prop=coordinates%%7Cpageimages%%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude]];
    if (url == nil) return;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.pages = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"query"][@"pages"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadAnnotations];
        });
    });
}

- (void)reloadAnnotations {
    // remove all existing annotations
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSLog(@"%@", self.pages);
    
    // create a new, empty map rect
    MKMapRect visibleMap = MKMapRectNull;
    
    // loop over all the pages we received from Wikipedis
    for (NSDictionary *page in self.pages.allValues) {
        // create a point annotation for it, configuring its title and coordinate
        MKPointAnnotation *point = [MKPointAnnotation new];
        point.title = (NSString *)page[@"title"];
        point.coordinate = CLLocationCoordinate2DMake([(NSNumber *)page[@"coordinates"][0][@"lat"] doubleValue],
                                                      [(NSNumber *)page[@"coordinates"][0][@"lon"] doubleValue]);
        
        // add that to the map
        [self.mapView addAnnotation:point];
        
        // add its position to our overall map rect+
        // https://gist.github.com/andrewgleave/915374
        MKMapPoint mapPoint = MKMapPointForCoordinate(point.coordinate);
        MKMapRect pointRect = MKMapRectMake(mapPoint.x, mapPoint.y, 0.1, 0.1);
        visibleMap = MKMapRectUnion(visibleMap, pointRect);
    }
    
    // if this is the first time we have loaded pins
    if (self.firstRun) {
        // zoom to the configure map rect
        [self.mapView setVisibleMapRect:visibleMap
                            edgePadding:UIEdgeInsetsMake(60, 60, 90, 90)
                               animated:YES];
        
        // mark that we've done it at lease once
        self.firstRun = NO;
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateMap];
}

@end
