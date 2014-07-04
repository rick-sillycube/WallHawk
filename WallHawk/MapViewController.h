//
//  MapViewController.h
//  WallHawk
//
//  Created by SillyMacMini2 on 14年6月27日.
//  Copyright (c) 2014年 SillyMacMini2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#define kMapViewControllerBackgroundViewTag 99

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    UITapGestureRecognizer *singleFingerTap;
}
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) IBOutlet UILabel* addressLabel;
@end
