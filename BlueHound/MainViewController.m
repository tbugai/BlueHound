//
//  ViewController.m
//  BlueTooth-LE-Browser
//
//  Created by Tim Bugai on 4/5/12.
//  Copyright (c) 2012 Collective Idea. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceListTableViewController.h"
#import "BlueToothDevice.h"

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

- (IBAction)scanButtonToggled:(id)sender {
  if (scanning) {
    scanning = false;
    [scanButton setTitle:@"Start Scanning" forState:UIControlStateNormal];
    
    [self stopScan];
  } else {
    scanning = true;
    [scanButton setTitle:@"Stop Scanning" forState:UIControlStateNormal];
    
    [self startScan];
  }
}

- (void)startScan {
  if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
    NSLog(@"starting to scan...");
    
    self.discoveredDevices = nil;
    self.discoveredDevices = [NSMutableArray array];
    
    [scanningIndicator startAnimating];
    
    NSDictionary *scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self.centralManager scanForPeripheralsWithServices:nil options:scanOptions];
      
    scanTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
  }  
}

- (void)stopScan {
  NSLog(@"scanning ended");
  [scanningIndicator stopAnimating];
  [scanTimer invalidate];
  
  [self.centralManager stopScan];
  
  self.deviceTable.list = self.discoveredDevices;
  [self.deviceTable.tableView reloadData];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  switch (central.state) {
    case CBCentralManagerStatePoweredOn:
      NSLog(@"Bluetooth is powered on");
      [self startScan];
      scanning = true;
      break;
      
    default:
      NSLog(@"Bluetooth state is unknown");
      break;
  }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
  NSLog(@"device found: %@", peripheral.UUID);
  
  BlueToothDevice *device = [[BlueToothDevice alloc] init];
  device.name = peripheral.name;
  device.uuid = [NSString stringWithFormat:@"%@", peripheral.UUID];
  [self.discoveredDevices addObject:device];
}
@end
