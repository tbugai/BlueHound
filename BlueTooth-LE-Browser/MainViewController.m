//
//  ViewController.m
//  BlueTooth-LE-Browser
//
//  Created by Tim Bugai on 4/5/12.
//  Copyright (c) 2012 Collective Idea. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceListTableViewController.h"

@implementation MainViewController

@synthesize centralManager,
            deviceTable,
            discoveredDevices;

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.discoveredDevices    = [NSMutableArray new];
  self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
 
  self.deviceTable = [[DeviceListTableViewController alloc] init];
  self.deviceTable.tableView.frame = CGRectMake(22,200,724,778);
  
  [self.view addSubview:self.deviceTable.tableView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationPortrait;
}

- (void)startScan {
  if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
    NSLog(@"starting to scan...");
    [self.centralManager scanForPeripheralsWithServices:nil options:0];
    scanTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
  }  
}

- (void)stopScan {
  NSLog(@"scanning ended");
  [self.centralManager stopScan];
  self.deviceTable.list = [discoveredDevices copy];
  [self.deviceTable.tableView reloadData];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  switch (central.state) {
    case CBCentralManagerStatePoweredOn:
      NSLog(@"Bluetooth is powered on");
      [self startScan];
      break;
      
    default:
      NSLog(@"Bluetooth state is unknown");
      break;
  }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
  NSLog(@"device found: %@", peripheral.name);
  if (![self.discoveredDevices containsObject:peripheral]) {
    [self.discoveredDevices addObject:peripheral];
  }
  
  for (NSString *key in [advertisementData allKeys]) {
    NSLog(@"%@ : %@", key, [advertisementData objectForKey:key]);
  }
}
@end
