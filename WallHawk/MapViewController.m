//
//  MapViewController.m
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月27日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;
@synthesize addressLabel;
@synthesize address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self zoomToCurrentLocation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    int touchedViewTag = [touch.view tag];
    NSLog(@"Touched view tag: %d", [touch.view tag]);
    
    if(touchedViewTag == kMapViewControllerBackgroundViewTag)
        [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomToCurrentLocation {
    /*
     float spanX = 0.00725;
     float spanY = 0.00725;
     region.center.latitude = 1000;//self.latitude;
     region.center.longitude = 1000;//self.longitude;
     region.span.latitudeDelta = spanX;
     region.span.longitudeDelta = spanY;
     */
    
    //address = @"Yuen Long, Hong Kong";
    NSLog(@"Addr: %@", address);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     for (CLPlacemark* placemark in placemarks)
                     {
                         NSLog(@"Lat, Long: (%f, %f)", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                         
                         /*
                          NSLog(@"region: %@",placemark.region);
                          NSLog(@"country: %@",placemark.country);  // Give Country Name
                          NSLog(@"locality: %@",placemark.locality); // Extract the city name
                          NSLog(@"subLocality: %@",placemark.subLocality);
                          NSLog(@"name: %@",placemark.name);
                          NSLog(@"ocean: %@",placemark.ocean);
                          NSLog(@"postalCode: %@",placemark.postalCode);
                          NSLog(@"location %@",placemark.location);
                          */
                         
                         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (placemark.location.coordinate, 2000, 2000);
                         [mapView setRegion:region animated:YES];
                         
                         // Add an annotation
                         MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                         point.coordinate = placemark.location.coordinate;
                         point.title = @"Target";
                         point.subtitle = @"here!!!";
                         
                         [self.mapView addAnnotation:point];
                         break;
                     }
                 }];
    
    [addressLabel setText:address];
    
    return;
}

@end
