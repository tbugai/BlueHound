//
//  BlueToothDevice.h
//  BlueHound
//
//  Created by Tim Bugai on 5/3/12.
//  Copyright (c) 2012 Collective Idea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueToothDevice : NSObject

@property (strong, retain) NSString *name;
@property (strong, retain) NSString *uuid;

@end
