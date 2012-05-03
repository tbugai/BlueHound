//
//  ViewController.h
//  BlueTooth-LE-Browser
//
//  Created by Tim Bugai on 4/5/12.
//  Copyright (c) 2012 Collective Idea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceListTableViewController.h"

@interface MainViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate> {
  IBOutlet UIActivityIndicatorView  *scanningIndicator;
  IBOutlet UIButton                 *scanButton;
  NSTimer                           *scanTimer;
}

@property (strong, nonatomic) DeviceListTableViewController *deviceTable;
@property (strong, nonatomic) NSMutableArray *discoveredDevices;
@property (strong, nonatomic) CBCentralManager *centralManager;


@end
